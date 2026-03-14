// ═══════════════════════════════════════════════════════════════
//  lib/models/drone_telemetry.dart
//  Şahin Göz — Drone Telemetri Veri Modeli
//
//  Sorumluluk:
//    WebSocket üzerinden gelen anlık drone verilerini temsil eder.
//    Equatable ile değer eşitliği sağlanır; aynı veri gelirse
//    provider gereksiz rebuild tetiklemez.
//
//  WebSocket JSON şeması (beklenen format):
//    {
//      "altitude":    45.2,    // metre
//      "speed":       12.5,    // km/s
//      "battery":     74,      // yüzde (0-100)
//      "lat":         41.0082, // enlem
//      "lng":         28.9784, // boylam
//      "heading":     270,     // yön (derece, 0=kuzey)
//      "satellites":  12,      // GPS uydu sayısı
//      "signal":      87,      // bağlantı kalitesi (0-100)
//      "timestamp":   "2024-01-01T12:00:00Z"
//    }
// ═══════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';

/// Drone'dan gelen anlık telemetri verisi.
/// Tüm alanlar null-safe; bağlantı kesildiğinde [DroneTelemetry.empty]
/// kullanılır.
class DroneTelemetry extends Equatable {
  const DroneTelemetry({
    required this.altitude,
    required this.speed,
    required this.battery,
    required this.lat,
    required this.lng,
    required this.heading,
    required this.satellites,
    required this.signal,
    required this.timestamp,
  });

  /// Yükseklik (metre)
  final double altitude;

  /// Hız (km/saat)
  final double speed;

  /// Pil seviyesi (0–100)
  final int battery;

  /// GPS enlem
  final double lat;

  /// GPS boylam
  final double lng;

  /// Pusula yönü (0 = kuzey, 90 = doğu, 180 = güney, 270 = batı)
  final int heading;

  /// Görünen uydu sayısı
  final int satellites;

  /// Sinyal kalitesi (0–100)
  final int signal;

  /// Son güncelleme zamanı
  final DateTime timestamp;

  // ── Fabrika: sıfır/başlangıç durumu ────────────────────────
  factory DroneTelemetry.empty() => DroneTelemetry(
        altitude: 0.0,
        speed: 0.0,
        battery: 100,
        lat: 41.0082,
        lng: 28.9784,
        heading: 0,
        satellites: 0,
        signal: 0,
        timestamp: DateTime.now(),
      );

  // ── JSON ayrıştırma (WebSocket mesajından) ──────────────────
  factory DroneTelemetry.fromJson(Map<String, dynamic> json) =>
      DroneTelemetry(
        altitude:   (json['altitude']   as num?)?.toDouble() ?? 0.0,
        speed:      (json['speed']      as num?)?.toDouble() ?? 0.0,
        battery:    (json['battery']    as int?) ?? 100,
        lat:        (json['lat']        as num?)?.toDouble() ?? 41.0082,
        lng:        (json['lng']        as num?)?.toDouble() ?? 28.9784,
        heading:    (json['heading']    as int?) ?? 0,
        satellites: (json['satellites'] as int?) ?? 0,
        signal:     (json['signal']     as int?) ?? 0,
        timestamp:  json['timestamp'] != null
            ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'altitude':   altitude,
        'speed':      speed,
        'battery':    battery,
        'lat':        lat,
        'lng':        lng,
        'heading':    heading,
        'satellites': satellites,
        'signal':     signal,
        'timestamp':  timestamp.toIso8601String(),
      };

  // ── copyWith ────────────────────────────────────────────────
  DroneTelemetry copyWith({
    double? altitude,
    double? speed,
    int? battery,
    double? lat,
    double? lng,
    int? heading,
    int? satellites,
    int? signal,
    DateTime? timestamp,
  }) =>
      DroneTelemetry(
        altitude:   altitude   ?? this.altitude,
        speed:      speed      ?? this.speed,
        battery:    battery    ?? this.battery,
        lat:        lat        ?? this.lat,
        lng:        lng        ?? this.lng,
        heading:    heading    ?? this.heading,
        satellites: satellites ?? this.satellites,
        signal:     signal     ?? this.signal,
        timestamp:  timestamp  ?? this.timestamp,
      );

  // ── Hesaplanan özellikler ───────────────────────────────────

  /// Pil durumuna göre renk (Flutter Color döner — import gerekir)
  String get batteryStatus {
    if (battery > 50) return 'normal';
    if (battery > 20) return 'uyarı';
    return 'kritik';
  }

  /// Sinyal gücü etiketi (Türkçe)
  String get signalLabel {
    if (signal >= 80) return 'GÜÇLÜ';
    if (signal >= 50) return 'ORTA';
    if (signal >= 20) return 'ZAYIF';
    return 'YOK';
  }

  /// Yön etiketi (Türkçe)
  String get headingLabel {
    if (heading >= 337 || heading < 23)  return 'K';
    if (heading >= 23  && heading < 68)  return 'KD';
    if (heading >= 68  && heading < 113) return 'D';
    if (heading >= 113 && heading < 158) return 'GD';
    if (heading >= 158 && heading < 203) return 'G';
    if (heading >= 203 && heading < 248) return 'GB';
    if (heading >= 248 && heading < 293) return 'B';
    return 'KB';
  }

  /// Enlem/boylam formatlanmış metin
  String get coordsFormatted =>
      '${lat.toStringAsFixed(4)}°K  ${lng.toStringAsFixed(4)}°D';

  @override
  List<Object?> get props => [
        altitude, speed, battery, lat, lng,
        heading, satellites, signal, timestamp,
      ];

  @override
  String toString() =>
      'DroneTelemetry(irt: ${altitude}m, hiz: ${speed}km/h, pil: $battery%)';
}
