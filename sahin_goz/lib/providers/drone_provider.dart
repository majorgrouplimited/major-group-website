// ═══════════════════════════════════════════════════════════════
//  lib/providers/drone_provider.dart
//  Şahin Göz — Ana Drone State Yönetimi (Riverpod)
//
//  Sorumluluk:
//    Uygulamanın tüm drone state'ini merkezi olarak yönetir:
//      • Aktif bölge (1–8)
//      • Drone telemetri verileri (irtifa, hız, pil)
//      • Bağlantı durumu
//      • YZ uyarıları
//      • Bölge listesi
//
//  Mimari Notlar:
//    - AsyncNotifier: async init (WebSocket bağlantısı) gerektiği için.
//    - İş mantığı burada; UI sadece ref.watch() ile okur.
//    - WebSocketService ve DroneApiService bağımlılık enjeksiyonu
//      ile sağlanır (test edilebilirlik için).
// ═══════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/drone_telemetry.dart';
import '../models/zone_model.dart';
import '../models/ai_alert.dart';
import '../services/websocket_service.dart';
import '../services/drone_api_service.dart';

// ─────────────────────────────────────────────────────────────
//  UYGULAMA GENELİ STATE (DroneState)
// ─────────────────────────────────────────────────────────────

/// Drone uygulamasının tam anlık durumu.
/// Immutable: her değişimde yeni bir kopya oluşturulur.
class DroneState {
  const DroneState({
    required this.zones,
    required this.activeZoneId,
    required this.telemetry,
    required this.connectionState,
    required this.alerts,
    required this.isSwitchingZone,
    this.lastError,
  });

  /// 8 izleme bölgesi
  final List<ZoneModel> zones;

  /// Şu anda aktif olan bölge ID'si (1–8)
  final int activeZoneId;

  /// Anlık telemetri (irtifa, hız, pil, GPS)
  final DroneTelemetry telemetry;

  /// WebSocket bağlantı durumu
  final WsConnectionState connectionState;

  /// Aktif YZ uyarıları (onaylanmamış)
  final List<AiAlert> alerts;

  /// Bölge geçişi sürerken true (UI'da yükleme göstergesi için)
  final bool isSwitchingZone;

  /// Son hata mesajı (Türkçe, null = hata yok)
  final String? lastError;

  // ── Hesaplanan özellikler ───────────────────────────────────

  ZoneModel get activeZone =>
      zones.firstWhere((z) => z.id == activeZoneId,
          orElse: () => zones.first);

  bool get isConnected =>
      connectionState == WsConnectionState.connected;

  bool get hasAlerts => alerts.isNotEmpty;

  int get criticalAlertCount =>
      alerts.where((a) => a.type == AiAlertType.trespassing).length;

  int get warningAlertCount =>
      alerts.where((a) => a.type != AiAlertType.trespassing).length;

  /// Aktif bölgedeki uyarılar
  List<AiAlert> get activeZoneAlerts =>
      alerts.where((a) => a.zoneId == activeZoneId).toList();

  // ── Başlangıç durumu ────────────────────────────────────────
  factory DroneState.initial() => DroneState(
        zones: kDefaultZones,
        activeZoneId: 3, // B3 KB Kule varsayılan
        telemetry: DroneTelemetry.empty(),
        connectionState: WsConnectionState.disconnected,
        alerts: const [],
        isSwitchingZone: false,
      );

  // ── copyWith ────────────────────────────────────────────────
  DroneState copyWith({
    List<ZoneModel>? zones,
    int? activeZoneId,
    DroneTelemetry? telemetry,
    WsConnectionState? connectionState,
    List<AiAlert>? alerts,
    bool? isSwitchingZone,
    String? lastError,
  }) =>
      DroneState(
        zones:            zones            ?? this.zones,
        activeZoneId:     activeZoneId     ?? this.activeZoneId,
        telemetry:        telemetry        ?? this.telemetry,
        connectionState:  connectionState  ?? this.connectionState,
        alerts:           alerts           ?? this.alerts,
        isSwitchingZone:  isSwitchingZone  ?? this.isSwitchingZone,
        lastError:        lastError,
      );

  @override
  String toString() =>
      'DroneState(zone: B$activeZoneId, '
      'bağlantı: $connectionState, '
      'uyarı: ${alerts.length})';
}

// ─────────────────────────────────────────────────────────────
//  NOTIFIER
// ─────────────────────────────────────────────────────────────

class DroneNotifier extends AsyncNotifier<DroneState> {
  late final WebSocketService _ws;
  late final DroneApiService _api;

  StreamSubscription<WsMessage>? _msgSub;
  StreamSubscription<WsConnectionState>? _connSub;

  // ── Riverpod init ───────────────────────────────────────────

  @override
  Future<DroneState> build() async {
    _ws = WebSocketService();
    _api = DroneApiService();

    // Provider dispose edildiğinde temizle
    ref.onDispose(() async {
      await _msgSub?.cancel();
      await _connSub?.cancel();
      await _ws.dispose();
      _api.dispose();
      dev.log('[DroneNotifier] Dispose edildi', name: 'DroneNotifier');
    });

    // Bağlantı durumu dinleyicisi
    _connSub = _ws.connectionState.listen(_onConnectionState);

    // Gelen mesaj dinleyicisi
    _msgSub = _ws.messages.listen(_onMessage);

    // WebSocket bağlantısını başlat
    await _ws.connect();

    return DroneState.initial();
  }

  // ── Mesaj işleyicileri ──────────────────────────────────────

  void _onConnectionState(WsConnectionState state) {
    _safeUpdate((current) => current.copyWith(connectionState: state));
  }

  void _onMessage(WsMessage msg) {
    switch (msg.type) {
      case WsMessageType.telemetry:
        _safeUpdate((current) =>
            current.copyWith(telemetry: msg.telemetry));

      case WsMessageType.alert:
        _safeUpdate((current) {
          final updated = [...current.alerts, msg.alert!];
          // Maksimum 50 uyarı tut
          if (updated.length > 50) updated.removeAt(0);
          // İlgili bölgeye uyarı seviyesi işle
          final zones = current.zones.map((z) {
            if (z.id == msg.alert!.zoneId) {
              return z.copyWith(
                alertLevel: msg.alert!.type == AiAlertType.trespassing
                    ? ZoneAlertLevel.critical
                    : ZoneAlertLevel.warning,
                alertMessage: msg.alert!.message,
              );
            }
            return z;
          }).toList();
          return current.copyWith(alerts: updated, zones: zones);
        });

      case WsMessageType.unknown:
      case WsMessageType.status:
        break;
    }
  }

  // ── Genel Eylemler ──────────────────────────────────────────

  /// Drone'u seçilen bölgeye yönlendirir.
  /// Hem API çağrısı yapar hem state günceller.
  Future<void> switchZone(int zoneId) async {
    final current = state.valueOrNull;
    if (current == null || current.activeZoneId == zoneId) return;
    if (current.isSwitchingZone) return; // Çift tıklamayı önle

    dev.log('[DroneNotifier] Bölge geçişi: B$zoneId', name: 'DroneNotifier');

    // UI'ı hemen güncelle (optimistic update)
    _safeUpdate((_) => current.copyWith(
          activeZoneId: zoneId,
          isSwitchingZone: true,
          zones: current.zones.map((z) => z.copyWith(
                isActive: z.id == zoneId,
              )).toList(),
        ));

    // WebSocket üzerinden komut gönder
    _ws.sendCommand({'cmd': 'switch_zone', 'zone_id': zoneId});

    // REST API'ye de bildir (WebSocket yoksa fallback)
    final result = await _api.switchZone(zoneId);

    _safeUpdate((current) => current.copyWith(
          isSwitchingZone: false,
          lastError: result.isError ? 'Bölge geçiş hatası: ${result.error}' : null,
        ));
  }

  /// Eve dön komutunu gönderir.
  Future<void> returnToHome() async {
    dev.log('[DroneNotifier] Eve dön komutu', name: 'DroneNotifier');
    _ws.sendCommand({'cmd': 'return_to_home'});
    await _api.returnToHome();
  }

  /// YZ uyarısını onaylar (listeden kaldırmaz, acknowledged işaretler)
  void acknowledgeAlert(String alertId) {
    _safeUpdate((current) {
      final updated = current.alerts.map((a) {
        if (a.id == alertId) return a.acknowledge();
        return a;
      }).toList();
      return current.copyWith(alerts: updated);
    });
  }

  /// Tüm onaylanmış uyarıları temizler
  void clearAcknowledgedAlerts() {
    _safeUpdate((current) {
      final active = current.alerts
          .where((a) => !a.acknowledged)
          .toList();
      return current.copyWith(alerts: active);
    });
  }

  /// Bağlantıyı manuel olarak yeniden kurar
  Future<void> reconnect() async {
    await _ws.connect();
  }

  // ── Simülasyon (Geliştirme ortamı için) ─────────────────────

  /// Gerçek bir drone yokken test için simülasyon başlatır.
  /// Üretimde bu metod ÇAĞIRILMAMALIDIR.
  void startSimulation() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (state.valueOrNull == null) {
        timer.cancel();
        return;
      }
      final current = state.value!.telemetry;
      _onMessage(WsMessage.telemetry(
        DroneTelemetry(
          altitude:   current.altitude + (0.5 - (DateTime.now().millisecond % 10) / 10),
          speed:      8.0 + (DateTime.now().second % 10) / 2,
          battery:    (current.battery - 0 ).clamp(0, 100),
          lat:        current.lat + 0.00001,
          lng:        current.lng + 0.00001,
          heading:    (current.heading + 2) % 360,
          satellites: 12,
          signal:     85 + (DateTime.now().second % 10),
          timestamp:  DateTime.now(),
        ),
      ));
    });
  }

  // ── Yardımcı ────────────────────────────────────────────────

  /// State'i güvenli şekilde günceller (null-check dahil)
  void _safeUpdate(DroneState Function(DroneState current) updater) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(updater(current));
  }
}

// ─────────────────────────────────────────────────────────────
//  PROVIDER TANIMLARI
//  UI dosyalarında import edilecek tek nokta bunlar.
// ─────────────────────────────────────────────────────────────

/// Ana drone provider — tüm state burada.
final droneProvider =
    AsyncNotifierProvider<DroneNotifier, DroneState>(DroneNotifier.new);

// Granüler selector'lar — gereksiz rebuild'leri önler

/// Sadece aktif bölge değiştiğinde rebuild
final activeZoneProvider = Provider<ZoneModel>((ref) {
  return ref.watch(droneProvider).valueOrNull?.activeZone ??
      kDefaultZones.firstWhere((z) => z.id == 3);
});

/// Sadece telemetri değiştiğinde rebuild
final telemetryProvider = Provider<DroneTelemetry>((ref) {
  return ref.watch(droneProvider).valueOrNull?.telemetry ??
      DroneTelemetry.empty();
});

/// Sadece bağlantı durumu değiştiğinde rebuild
final connectionStateProvider = Provider<WsConnectionState>((ref) {
  return ref.watch(droneProvider).valueOrNull?.connectionState ??
      WsConnectionState.disconnected;
});

/// Sadece uyarılar değiştiğinde rebuild
final alertsProvider = Provider<List<AiAlert>>((ref) {
  return ref.watch(droneProvider).valueOrNull?.alerts ?? const [];
});

/// Bölge listesi provider
final zonesProvider = Provider<List<ZoneModel>>((ref) {
  return ref.watch(droneProvider).valueOrNull?.zones ?? kDefaultZones;
});

/// Pil seviyesi değiştiğinde rebuild (telemet'riden türetilmiş)
final batteryProvider = Provider<int>((ref) {
  return ref.watch(telemetryProvider).battery;
});

/// Bağlı mı?
final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(connectionStateProvider) == WsConnectionState.connected;
});
