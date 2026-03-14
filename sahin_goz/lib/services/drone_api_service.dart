// ═══════════════════════════════════════════════════════════════
//  lib/services/drone_api_service.dart
//  Şahin Göz — Drone REST API Servisi
//
//  Sorumluluk:
//    Bölge değiştirme, drone durumu sorgulama ve yapılandırma
//    gibi tek seferlik HTTP çağrılarını yönetir.
//    WebSocket sürekli telemetri için; bu servis komut/sorgu için.
//
//  Base URL:
//    http://drone.majorgrup.local:8080/api/v1
//    Üretim ortamında HTTPS zorunludur.
// ═══════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:developer' as dev;

import 'package:http/http.dart' as http;

import '../models/drone_telemetry.dart';
import '../models/zone_model.dart';
import '../models/ai_alert.dart';

/// API çağrısı sonuç sarmalayıcı.
/// Flutter'da exception fırlatmak yerine Result pattern kullanılır.
class ApiResult<T> {
  const ApiResult._({this.data, this.error});

  final T? data;
  final String? error;

  bool get isSuccess => error == null;
  bool get isError => error != null;

  factory ApiResult.success(T data) => ApiResult._(data: data);
  factory ApiResult.failure(String error) => ApiResult._(error: error);

  @override
  String toString() => isSuccess ? 'Başarılı: $data' : 'Hata: $error';
}

class DroneApiService {
  DroneApiService({
    this.baseUrl = 'http://drone.majorgrup.local:8080/api/v1',
    this.timeout = const Duration(seconds: 10),
  });

  final String baseUrl;
  final Duration timeout;

  late final http.Client _client = http.Client();

  // ── Temel HTTP yardımcıları ─────────────────────────────────

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Üretimde: 'Authorization': 'Bearer $token'
      };

  Future<ApiResult<Map<String, dynamic>>> _get(String path) async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl$path'), headers: _headers)
          .timeout(timeout);
      return _parseResponse(response);
    } catch (e) {
      dev.log('[API] GET $path hatası: $e', name: 'DroneApiService');
      return ApiResult.failure('Bağlantı hatası: $e');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> _post(
      String path, Map<String, dynamic> body) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl$path'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(timeout);
      return _parseResponse(response);
    } catch (e) {
      dev.log('[API] POST $path hatası: $e', name: 'DroneApiService');
      return ApiResult.failure('Bağlantı hatası: $e');
    }
  }

  ApiResult<Map<String, dynamic>> _parseResponse(http.Response response) {
    dev.log('[API] ${response.statusCode} ${response.request?.url}',
        name: 'DroneApiService');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return ApiResult.success(body);
      } catch (e) {
        return ApiResult.failure('JSON ayrıştırma hatası: $e');
      }
    }

    return ApiResult.failure('HTTP ${response.statusCode}: ${response.reasonPhrase}');
  }

  // ── API Uç Noktaları ────────────────────────────────────────

  /// Drone'u belirtilen bölgeye yönlendirir.
  /// POST /drone/switch-zone { "zone_id": N }
  Future<ApiResult<bool>> switchZone(int zoneId) async {
    final result = await _post('/drone/switch-zone', {'zone_id': zoneId});
    if (result.isSuccess) return ApiResult.success(true);
    return ApiResult.failure(result.error!);
  }

  /// Anlık drone durumunu çeker (WebSocket yoksa fallback).
  /// GET /drone/status
  Future<ApiResult<DroneTelemetry>> fetchStatus() async {
    final result = await _get('/drone/status');
    if (result.isError) return ApiResult.failure(result.error!);

    try {
      return ApiResult.success(
          DroneTelemetry.fromJson(result.data!));
    } catch (e) {
      return ApiResult.failure('Telemetri ayrıştırma hatası: $e');
    }
  }

  /// Tüm bölge konfigürasyonlarını çeker.
  /// GET /zones
  Future<ApiResult<List<ZoneModel>>> fetchZones() async {
    final result = await _get('/zones');
    if (result.isError) return ApiResult.failure(result.error!);

    try {
      final list = result.data!['zones'] as List<dynamic>;
      final zones = list
          .map((z) => _parseZone(z as Map<String, dynamic>))
          .toList();
      return ApiResult.success(zones);
    } catch (e) {
      return ApiResult.failure('Bölge ayrıştırma hatası: $e');
    }
  }

  /// Son YZ uyarılarını getirir (sayfalı).
  /// GET /alerts?limit=50&offset=0
  Future<ApiResult<List<AiAlert>>> fetchAlerts({
    int limit = 50,
    int offset = 0,
  }) async {
    final result = await _get('/alerts?limit=$limit&offset=$offset');
    if (result.isError) return ApiResult.failure(result.error!);

    try {
      final list = result.data!['alerts'] as List<dynamic>;
      final alerts = list
          .map((a) => AiAlert.fromJson(a as Map<String, dynamic>))
          .toList();
      return ApiResult.success(alerts);
    } catch (e) {
      return ApiResult.failure('Uyarı ayrıştırma hatası: $e');
    }
  }

  /// Drone'a eve dön komutu gönderir.
  /// POST /drone/return-to-home
  Future<ApiResult<bool>> returnToHome() async {
    final result = await _post('/drone/return-to-home', {});
    if (result.isSuccess) return ApiResult.success(true);
    return ApiResult.failure(result.error!);
  }

  ZoneModel _parseZone(Map<String, dynamic> json) => ZoneModel(
        id:        json['id'] as int,
        name:      json['name'] as String,
        shortName: json['short_name'] as String,
        streamUrl: json['stream_url'] as String,
        lat:       (json['lat'] as num).toDouble(),
        lng:       (json['lng'] as num).toDouble(),
      );

  void dispose() => _client.close();
}
