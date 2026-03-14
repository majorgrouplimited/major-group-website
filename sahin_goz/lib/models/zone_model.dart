// ═══════════════════════════════════════════════════════════════
//  lib/models/zone_model.dart
//  Şahin Göz — Bölge (Zone) Veri Modeli
//
//  Sorumluluk:
//    8 izleme bölgesinin her birini temsil eder. Her bölgenin
//    RTSP stream URL'si, adı, koordinatları ve uyarı durumu
//    bu modelde tutulur.
// ═══════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Bölge uyarı durumu
enum ZoneAlertLevel {
  /// Normal — uyarı yok
  normal,

  /// Uyarı — örn. baretsiz işçi
  warning,

  /// Kritik — örn. yetkisiz erişim
  critical,
}

/// Tek bir izleme bölgesini temsil eder.
class ZoneModel extends Equatable {
  const ZoneModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.streamUrl,
    required this.lat,
    required this.lng,
    this.alertLevel = ZoneAlertLevel.normal,
    this.alertMessage,
    this.isActive = false,
    this.workerCount = 0,
  });

  /// Bölge numarası (1–8)
  final int id;

  /// Tam bölge adı (Türkçe)
  final String name;

  /// Kısa kod (B1, B2, ...)
  final String shortName;

  /// RTSP / HLS stream adresi.
  /// Gerçek dağıtımda bu URL sunucudan çekilmeli.
  /// Örn: "rtsp://192.168.1.100:8554/zone1"
  final String streamUrl;

  /// Bölge kamera GPS konumu (enlem)
  final double lat;

  /// Bölge kamera GPS konumu (boylam)
  final double lng;

  /// Aktif uyarı seviyesi
  final ZoneAlertLevel alertLevel;

  /// Uyarı mesajı (Türkçe, null = uyarı yok)
  final String? alertMessage;

  /// Drone şu anda bu bölgedeyse true
  final bool isActive;

  /// Bölgedeki tespit edilen işçi sayısı (YZ çıktısı)
  final int workerCount;

  // ── Hesaplanan özellikler ───────────────────────────────────

  bool get hasAlert => alertLevel != ZoneAlertLevel.normal;

  Color get indicatorColor {
    switch (alertLevel) {
      case ZoneAlertLevel.normal:   return AppColors.green;
      case ZoneAlertLevel.warning:  return AppColors.amber;
      case ZoneAlertLevel.critical: return AppColors.red;
    }
  }

  Color get borderColor {
    if (isActive) return AppColors.cyan;
    switch (alertLevel) {
      case ZoneAlertLevel.normal:   return AppColors.border1;
      case ZoneAlertLevel.warning:  return AppColors.amber;
      case ZoneAlertLevel.critical: return AppColors.red;
    }
  }

  // ── copyWith ────────────────────────────────────────────────
  ZoneModel copyWith({
    int? id,
    String? name,
    String? shortName,
    String? streamUrl,
    double? lat,
    double? lng,
    ZoneAlertLevel? alertLevel,
    String? alertMessage,
    bool? isActive,
    int? workerCount,
  }) =>
      ZoneModel(
        id:           id           ?? this.id,
        name:         name         ?? this.name,
        shortName:    shortName    ?? this.shortName,
        streamUrl:    streamUrl    ?? this.streamUrl,
        lat:          lat          ?? this.lat,
        lng:          lng          ?? this.lng,
        alertLevel:   alertLevel   ?? this.alertLevel,
        alertMessage: alertMessage ?? this.alertMessage,
        isActive:     isActive     ?? this.isActive,
        workerCount:  workerCount  ?? this.workerCount,
      );

  @override
  List<Object?> get props => [
        id, name, shortName, streamUrl,
        lat, lng, alertLevel, alertMessage,
        isActive, workerCount,
      ];
}

// ─────────────────────────────────────────────────────────────
//  VARSAYILAN BÖLGE LİSTESİ
//  Gerçek dağıtımda bu veri sunucudan çekilmelidir.
//  streamUrl'ler yerel RTSP sunucunuzun adresine göre
//  güncellenmeli; örn: "rtsp://10.0.0.1:8554/b1"
// ─────────────────────────────────────────────────────────────
const List<ZoneModel> kDefaultZones = [
  ZoneModel(
    id: 1,
    name: 'Temel Kazı',
    shortName: 'B1',
    streamUrl: 'rtsp://drone.majorgrup.local:8554/zone1',
    lat: 41.0082,
    lng: 28.9784,
    workerCount: 4,
  ),
  ZoneModel(
    id: 2,
    name: 'Ana Giriş',
    shortName: 'B2',
    streamUrl: 'rtsp://drone.majorgrup.local:8554/zone2',
    lat: 41.0085,
    lng: 28.9788,
    workerCount: 2,
  ),
  ZoneModel(
    id: 3,
    name: 'KB Kule',
    shortName: 'B3',
    streamUrl: 'rtsp://drone.majorgrup.local:8554/zone3',
    lat: 41.0079,
    lng: 28.9780,
    isActive: true, // Varsayılan aktif bölge
    workerCount: 7,
  ),
  ZoneModel(
    id: 4,
    name: 'İskele',
    shortName: 'B4',
    streamUrl: 'rtsp://drone.majorgrup.local:8554/zone4',
    lat: 41.0076,
    lng: 28.9778,
    alertLevel: ZoneAlertLevel.warning,
    alertMessage: '⚠ Baret Yok — 2 işçi',
    workerCount: 5,
  ),
  ZoneModel(
    id: 5,
    name: 'Doğu Sektörü',
    shortName: 'B5',
    streamUrl: 'rtsp://drone.majorgrup.local:8554/zone5',
    lat: 41.0088,
    lng: 28.9792,
    workerCount: 3,
  ),
  ZoneModel(
    id: 6,
    name: 'Vinç Merkezi',
    shortName: 'B6',
    streamUrl: 'rtsp://drone.majorgrup.local:8554/zone6',
    lat: 41.0072,
    lng: 28.9774,
    workerCount: 6,
  ),
  ZoneModel(
    id: 7,
    name: 'Depo',
    shortName: 'B7',
    streamUrl: 'rtsp://drone.majorgrup.local:8554/zone7',
    lat: 41.0093,
    lng: 28.9796,
    alertLevel: ZoneAlertLevel.critical,
    alertMessage: '🚨 Yetkisiz Erişim',
    workerCount: 1,
  ),
  ZoneModel(
    id: 8,
    name: 'Çevre',
    shortName: 'B8',
    streamUrl: 'rtsp://drone.majorgrup.local:8554/zone8',
    lat: 41.0068,
    lng: 28.9770,
    workerCount: 0,
  ),
];
