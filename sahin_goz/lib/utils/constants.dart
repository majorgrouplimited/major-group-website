// ═══════════════════════════════════════════════════════════════
//  lib/utils/constants.dart
//  Şahin Göz — Uygulama Geneli Sabitler
// ═══════════════════════════════════════════════════════════════

/// WebSocket ve API URL'lerini buradan merkezi olarak yönetin.
/// Üretimde bu değerleri .env dosyasından veya Flutter
/// --dart-define flag'larıyla aktarın:
///   flutter run --dart-define=WS_URL=ws://your-server/ws
abstract final class AppConstants {
  // ── Sunucu adresleri ─────────────────────────────────────
  static const String wsUrl =
      String.fromEnvironment('WS_URL',
          defaultValue: 'ws://drone.majorgrup.local:8765/telemetry');

  static const String apiBaseUrl =
      String.fromEnvironment('API_BASE_URL',
          defaultValue: 'http://drone.majorgrup.local:8080/api/v1');

  // ── Uygulama sabitleri ───────────────────────────────────
  /// Toplam izleme bölgesi sayısı
  static const int zoneCount = 8;

  /// Varsayılan başlangıç bölgesi
  static const int defaultZoneId = 3;

  /// Pil kritik eşiği (%)
  static const int batteryCriticalThreshold = 20;

  /// Pil uyarı eşiği (%)
  static const int batteryWarningThreshold = 50;

  /// Sinyal kayıp eşiği (%)
  static const int signalLossThreshold = 20;

  /// Maksimum saklanan uyarı sayısı
  static const int maxAlertHistory = 50;

  // ── Stream ayarları ──────────────────────────────────────
  /// VLC player buffer süresi (ms)
  static const int vlcBufferMs = 300;

  /// VLC ağ cache süresi (ms) — düşük gecikme için küçük tut
  static const int vlcNetworkCacheMs = 500;
}
