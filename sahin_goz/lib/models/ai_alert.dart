// ═══════════════════════════════════════════════════════════════
//  lib/models/ai_alert.dart
//  Şahin Göz — YZ Güvenlik Uyarısı Modeli
//
//  Sorumluluk:
//    YZ (YOLOv8 tabanlı) güvenlik tespitlerini temsil eder.
//    Backend'den WebSocket veya REST üzerinden bu formatta
//    veri alınır ve UI'da kırmızı uyarı kutucuğu olarak
//    gösterilir.
//
//  Backend JSON şeması:
//    {
//      "type": "no_helmet" | "trespassing" | "inactivity",
//      "zone_id": 4,
//      "confidence": 0.94,
//      "message": "Baret Yok — İşçi #3",
//      "bbox": { "x": 0.3, "y": 0.4, "w": 0.1, "h": 0.2 },
//      "timestamp": "2024-01-01T12:05:30Z"
//    }
// ═══════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';

/// YZ tespit türleri (Türkçe etiket eklenmiştir)
enum AiAlertType {
  /// Baretsiz işçi tespiti
  noHelmet('Baret Yok', '⚠'),

  /// Yetkisiz bölge girişi
  trespassing('Yetkisiz Erişim', '🚨'),

  /// İşçi hareketsizliği (belirli süre)
  inactivity('Hareketsizlik', '⏱'),

  /// Güvenlik ihlali (genel)
  safetyViolation('Güvenlik İhlali', '🔴');

  const AiAlertType(this.labelTr, this.icon);

  /// Türkçe etiket
  final String labelTr;

  /// UI ikonu
  final String icon;
}

/// Sınırlayıcı kutu koordinatları (normalize edilmiş 0.0–1.0)
class BoundingBox extends Equatable {
  const BoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final double x;
  final double y;
  final double width;
  final double height;

  factory BoundingBox.fromJson(Map<String, dynamic> json) => BoundingBox(
        x:      (json['x'] as num).toDouble(),
        y:      (json['y'] as num).toDouble(),
        width:  (json['w'] as num).toDouble(),
        height: (json['h'] as num).toDouble(),
      );

  @override
  List<Object?> get props => [x, y, width, height];
}

/// Tek bir YZ güvenlik uyarısı
class AiAlert extends Equatable {
  const AiAlert({
    required this.id,
    required this.type,
    required this.zoneId,
    required this.confidence,
    required this.message,
    required this.timestamp,
    this.boundingBox,
    this.acknowledged = false,
  });

  final String id;
  final AiAlertType type;
  final int zoneId;

  /// YZ güven skoru (0.0–1.0)
  final double confidence;

  /// Türkçe açıklama metni
  final String message;

  final DateTime timestamp;

  /// Video karesi üzerindeki konum (null = bölge geneli uyarı)
  final BoundingBox? boundingBox;

  /// Operatör tarafından onaylandı mı
  final bool acknowledged;

  // ── Fabrika: JSON'dan ───────────────────────────────────────
  factory AiAlert.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'safety_violation';
    final alertType = switch (typeStr) {
      'no_helmet'        => AiAlertType.noHelmet,
      'trespassing'      => AiAlertType.trespassing,
      'inactivity'       => AiAlertType.inactivity,
      'safety_violation' => AiAlertType.safetyViolation,
      _                  => AiAlertType.safetyViolation,
    };

    return AiAlert(
      id:         json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type:       alertType,
      zoneId:     json['zone_id'] as int? ?? 0,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      message:    json['message'] as String? ?? alertType.labelTr,
      timestamp:  json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      boundingBox: json['bbox'] != null
          ? BoundingBox.fromJson(json['bbox'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Uyarıyı onaylandı olarak işaretle
  AiAlert acknowledge() => AiAlert(
        id: id,
        type: type,
        zoneId: zoneId,
        confidence: confidence,
        message: message,
        timestamp: timestamp,
        boundingBox: boundingBox,
        acknowledged: true,
      );

  @override
  List<Object?> get props => [id, type, zoneId, confidence, message,
        timestamp, acknowledged];

  @override
  String toString() =>
      'AiAlert(${type.icon} ${type.labelTr} — B$zoneId @ '
      '${(confidence * 100).toStringAsFixed(0)}%)';
}
