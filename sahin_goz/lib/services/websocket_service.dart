// ═══════════════════════════════════════════════════════════════
//  lib/services/websocket_service.dart
//  Şahin Göz — WebSocket Telemetri Servisi
//
//  Sorumluluk:
//    Drone backend'ine WebSocket bağlantısı kurar ve
//    telemetri/uyarı verilerini Dart Stream'e dönüştürür.
//    Otomatik yeniden bağlanma ve hata yönetimi içerir.
//
//  Kullanım:
//    Riverpod provider içinde StreamProvider ile sarmalanır;
//    UI doğrudan bu servisi ÇAĞIRMAMALI.
//
//  Backend bağlantı noktası:
//    ws://drone.majorgrup.local:8765/telemetry
//    Mesaj formatı için drone_telemetry.dart ve ai_alert.dart
//    dokümantasyonuna bakın.
// ═══════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

import '../models/drone_telemetry.dart';
import '../models/ai_alert.dart';

/// WebSocket mesaj türleri (backend'den gelen 'type' alanı)
enum WsMessageType { telemetry, alert, status, unknown }

/// Ayrıştırılmış WebSocket mesajı (union-benzeri)
class WsMessage {
  const WsMessage._({
    required this.type,
    this.telemetry,
    this.alert,
    this.rawPayload,
  });

  final WsMessageType type;
  final DroneTelemetry? telemetry;
  final AiAlert? alert;
  final Map<String, dynamic>? rawPayload;

  factory WsMessage.telemetry(DroneTelemetry t) =>
      WsMessage._(type: WsMessageType.telemetry, telemetry: t);

  factory WsMessage.alert(AiAlert a) =>
      WsMessage._(type: WsMessageType.alert, alert: a);

  factory WsMessage.unknown(Map<String, dynamic> raw) =>
      WsMessage._(type: WsMessageType.unknown, rawPayload: raw);
}

/// WebSocket bağlantı durumu
enum WsConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// Drone WebSocket telemetri servisi.
/// Provider tarafından tek instance olarak tutulur.
class WebSocketService {
  WebSocketService({
    this.url = 'ws://drone.majorgrup.local:8765/telemetry',
    this.reconnectDelay = const Duration(seconds: 3),
    this.maxReconnectAttempts = 10,
  });

  final String url;
  final Duration reconnectDelay;
  final int maxReconnectAttempts;

  WebSocketChannel? _channel;
  StreamSubscription? _sub;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  bool _disposed = false;

  // ── Dışarıya açılan stream'ler ──────────────────────────────

  final _messageController =
      StreamController<WsMessage>.broadcast();
  final _connectionStateController =
      StreamController<WsConnectionState>.broadcast();

  Stream<WsMessage> get messages => _messageController.stream;
  Stream<WsConnectionState> get connectionState =>
      _connectionStateController.stream;

  // ── Bağlantı kurma ──────────────────────────────────────────

  /// WebSocket bağlantısını başlatır.
  /// Riverpod provider'ın ref.onDispose() içinde [dispose] çağrılmalı.
  Future<void> connect() async {
    if (_disposed) return;
    _emitState(WsConnectionState.connecting);
    dev.log('[WS] Bağlanılıyor: $url', name: 'WebSocketService');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));

      // Bağlantı onayını bekle
      await _channel!.ready;
      _reconnectAttempts = 0;
      _emitState(WsConnectionState.connected);
      dev.log('[WS] Bağlandı', name: 'WebSocketService');

      _sub = _channel!.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
    } catch (e) {
      dev.log('[WS] Bağlantı hatası: $e', name: 'WebSocketService');
      _emitState(WsConnectionState.error);
      _scheduleReconnect();
    }
  }

  // ── Veri işleme ─────────────────────────────────────────────

  void _onData(dynamic raw) {
    try {
      final json = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = json['type'] as String? ?? '';

      final msg = switch (type) {
        'telemetry' => WsMessage.telemetry(DroneTelemetry.fromJson(json)),
        'alert'     => WsMessage.alert(AiAlert.fromJson(json)),
        _           => WsMessage.unknown(json),
      };

      _messageController.add(msg);
    } catch (e) {
      dev.log('[WS] Ayrıştırma hatası: $e', name: 'WebSocketService');
    }
  }

  void _onError(Object error) {
    dev.log('[WS] Stream hatası: $error', name: 'WebSocketService');
    _emitState(WsConnectionState.error);
    _scheduleReconnect();
  }

  void _onDone() {
    dev.log('[WS] Bağlantı kapandı', name: 'WebSocketService');
    if (!_disposed) {
      _emitState(WsConnectionState.disconnected);
      _scheduleReconnect();
    }
  }

  // ── Yeniden bağlanma ────────────────────────────────────────

  void _scheduleReconnect() {
    if (_disposed) return;
    if (_reconnectAttempts >= maxReconnectAttempts) {
      dev.log('[WS] Maksimum yeniden bağlanma denemesi aşıldı',
          name: 'WebSocketService');
      _emitState(WsConnectionState.error);
      return;
    }

    _reconnectAttempts++;
    final delay = reconnectDelay * _reconnectAttempts; // artan bekleme
    dev.log('[WS] ${delay.inSeconds}s sonra yeniden bağlanılacak '
        '(deneme: $_reconnectAttempts)',
        name: 'WebSocketService');

    _emitState(WsConnectionState.reconnecting);
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, connect);
  }

  // ── Komut gönderme ──────────────────────────────────────────

  /// Drone'a JSON komutu gönderir.
  /// Örn: zoneSwitchCommand(3) → '{"cmd":"switch_zone","zone_id":3}'
  void sendCommand(Map<String, dynamic> command) {
    if (_channel == null) {
      dev.log('[WS] Kanal yok — komut gönderilemiyor',
          name: 'WebSocketService');
      return;
    }
    try {
      _channel!.sink.add(jsonEncode(command));
    } catch (e) {
      dev.log('[WS] Gönderme hatası: $e', name: 'WebSocketService');
    }
  }

  // ── Temizlik ────────────────────────────────────────────────

  Future<void> dispose() async {
    _disposed = true;
    _reconnectTimer?.cancel();
    await _sub?.cancel();
    await _channel?.sink.close(ws_status.goingAway);
    await _messageController.close();
    await _connectionStateController.close();
    dev.log('[WS] Servis kapatıldı', name: 'WebSocketService');
  }

  void _emitState(WsConnectionState state) {
    if (!_connectionStateController.isClosed) {
      _connectionStateController.add(state);
    }
  }
}
