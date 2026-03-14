// ═══════════════════════════════════════════════════════════════
//  lib/widgets/drone_video_player.dart
//  Şahin Göz — Yüksek Performanslı Drone Video Oynatıcı
//
//  Sorumluluk:
//    flutter_vlc_player ile RTSP/HLS stream oynatma.
//    RepaintBoundary ile video yeniden çizimi izole edilir;
//    drone feed'i değiştiğinde sadece bu widget rebuild olur.
//
//  Kullanım:
//    DroneVideoPlayer(zone: currentZone)
//    Veya sadece: DroneVideoPlayer()  ← activeZoneProvider'dan okur
//
//  Mimari Notlar:
//    - VlcPlayerController StatefulWidget içinde yönetilir ve
//      dispose edilir; sızıntı yoktur.
//    - Stream URL değiştiğinde (yeni bölge) controller yeniden
//      initialize edilir, AnimatedSwitcher ile fade geçişi yapılır.
//    - Hata durumunda (stream yok / bağlantı kesildi) placeholder
//      gösterilir; kullanıcıya Türkçe hata mesajı iletilir.
// ═══════════════════════════════════════════════════════════════

import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';
import '../models/zone_model.dart';
import '../models/ai_alert.dart';
import '../providers/drone_provider.dart';

// ─────────────────────────────────────────────────────────────
//  ANA OYNATICI WİDGET
// ─────────────────────────────────────────────────────────────

/// Drone kamera akışını oynatır ve üzerine HUD katmanını ekler.
/// Consumer: [activeZoneProvider] ve [alertsProvider]'ı izler.
class DroneVideoPlayer extends ConsumerStatefulWidget {
  const DroneVideoPlayer({super.key});

  @override
  ConsumerState<DroneVideoPlayer> createState() =>
      _DroneVideoPlayerState();
}

class _DroneVideoPlayerState extends ConsumerState<DroneVideoPlayer>
    with TickerProviderStateMixin {
  VlcPlayerController? _controller;

  /// Bölge değişiminde AnimatedSwitcher key'i güncellenir
  String _currentStreamUrl = '';

  /// Oynatıcı başlatıldı mı
  bool _initialized = false;

  /// Geçerli hata mesajı (null = hata yok)
  String? _errorMessage;

  // ── REC göstergesi yanıp sönme animasyonu ──────────────────
  late final AnimationController _recAnimCtrl;
  late final Animation<double> _recOpacity;

  @override
  void initState() {
    super.initState();

    // REC • 1 sn periyot, sürekli döngü
    _recAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _recOpacity = Tween<double>(begin: 1.0, end: 0.15)
        .animate(CurvedAnimation(
          parent: _recAnimCtrl,
          curve: Curves.easeInOut,
        ));

    // İlk stream başlatmayı frame sonrasına ertele
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final zone = ref.read(activeZoneProvider);
      _initPlayer(zone.streamUrl);
    });
  }

  @override
  void dispose() {
    _recAnimCtrl.dispose();
    _disposePlayer();
    super.dispose();
  }

  // ── VLC Controller yönetimi ─────────────────────────────────

  Future<void> _initPlayer(String url) async {
    if (!mounted) return;
    setState(() {
      _initialized = false;
      _errorMessage = null;
    });

    await _disposePlayer();

    dev.log('[VideoPlayer] Başlatılıyor: $url', name: 'DroneVideoPlayer');

    try {
      _controller = VlcPlayerController.network(
        url,
        autoInitialize: true,
        autoPlay: true,
        options: VlcPlayerOptions(
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(500),
            VlcAdvancedOptions.fileCaching(1000),
          ]),
          rtp: VlcRtpOptions([
            VlcRtpOptions.rtpOverRtsp(true),
          ]),
          video: VlcVideoOptions([
            VlcVideoOptions.dropLateFrames(true),
            VlcVideoOptions.skipFrames(true),
          ]),
        ),
      );

      _controller!.addListener(_onPlayerEvent);
      _currentStreamUrl = url;

      if (mounted) {
        setState(() => _initialized = true);
      }
    } catch (e) {
      dev.log('[VideoPlayer] Başlatma hatası: $e', name: 'DroneVideoPlayer');
      if (mounted) {
        setState(() => _errorMessage = 'Stream bağlantısı kurulamadı');
      }
    }
  }

  Future<void> _disposePlayer() async {
    if (_controller != null) {
      _controller!.removeListener(_onPlayerEvent);
      try {
        await _controller!.stopRendererScanning();
        await _controller!.dispose();
      } catch (_) {}
      _controller = null;
    }
  }

  void _onPlayerEvent() {
    if (!mounted) return;
    final player = _controller;
    if (player == null) return;

    if (player.value.hasError) {
      dev.log('[VideoPlayer] Oynatıcı hatası: ${player.value.errorDescription}',
          name: 'DroneVideoPlayer');
      if (mounted) {
        setState(() =>
            _errorMessage = 'Akış hatası — sinyal kontrol edilsin');
      }
    }
  }

  // ── Bölge değişimini izle ───────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Aktif bölge değiştiğinde stream'i yenile
    ref.listen<ZoneModel>(activeZoneProvider, (prev, next) {
      if (prev?.streamUrl != next.streamUrl) {
        dev.log('[VideoPlayer] Bölge değişti → B${next.id}',
            name: 'DroneVideoPlayer');
        _initPlayer(next.streamUrl);
      }
    });

    final zone    = ref.watch(activeZoneProvider);
    final alerts  = ref.watch(alertsProvider)
        .where((a) => a.zoneId == zone.id && !a.acknowledged)
        .toList();

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              // ── 1. Video katmanı ──────────────────────────
              _VideoLayer(
                controller: _controller,
                initialized: _initialized,
                errorMessage: _errorMessage,
                streamUrl: _currentStreamUrl,
              ),

              // ── 2. CRT tarama çizgisi efekti ──────────────
              _CrtScanlines(),

              // ── 3. Köşe bracket'ları ──────────────────────
              const _CornerBrackets(),

              // ── 4. Üst HUD şeridi ─────────────────────────
              Positioned(
                top: 0, left: 0, right: 0,
                child: _TopHudBar(
                  zone: zone,
                  recOpacity: _recOpacity,
                ),
              ),

              // ── 5. Alt telemetri şeridi ───────────────────
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: _BottomHudBar(zone: zone),
              ),

              // ── 6. YZ uyarı overlay'i ─────────────────────
              if (alerts.isNotEmpty)
                AiAlertOverlay(alerts: alerts),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  VİDEO KATMANI — AnimatedSwitcher ile geçiş
// ─────────────────────────────────────────────────────────────

class _VideoLayer extends StatelessWidget {
  const _VideoLayer({
    required this.controller,
    required this.initialized,
    required this.errorMessage,
    required this.streamUrl,
  });

  final VlcPlayerController? controller;
  final bool initialized;
  final String? errorMessage;
  final String streamUrl;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (errorMessage != null) {
      return _ErrorPlaceholder(
          message: errorMessage!, key: const ValueKey('error'));
    }

    if (!initialized || controller == null) {
      return _LoadingPlaceholder(key: ValueKey('loading_$streamUrl'));
    }

    return VlcPlayer(
      key: ValueKey('vlc_$streamUrl'),
      controller: controller!,
      aspectRatio: 16 / 9,
      placeholder: _LoadingPlaceholder(key: ValueKey('vlc_ph_$streamUrl')),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  YÜKLENİYOR PLACEHOLDER
// ─────────────────────────────────────────────────────────────

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 28, height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: AppColors.cyan,
            ),
          ),
          const SizedBox(height: 10),
          Text('AKIŞ BEKLENIYOR...',
              style: AppTextStyles.mono(9,
                  color: AppColors.text3, letterSpacing: 2.0)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  HATA PLACEHOLDER
// ─────────────────────────────────────────────────────────────

class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder({required this.message, super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.signal_wifi_off_rounded,
              color: AppColors.red, size: 28),
          const SizedBox(height: 8),
          Text(message,
              style: AppTextStyles.mono(8,
                  color: AppColors.red, letterSpacing: 1.0),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('RTSP kaynağını kontrol edin',
              style: AppTextStyles.mono(7,
                  color: AppColors.text4, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ÜST HUD ÇUBUĞU  (CANLI | BÖLGE ADI | GPS)
// ─────────────────────────────────────────────────────────────

class _TopHudBar extends ConsumerWidget {
  const _TopHudBar({required this.zone, required this.recOpacity});

  final ZoneModel zone;
  final Animation<double> recOpacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetry = ref.watch(telemetryProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xDD060A0D), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          // ── CANLI etiketi ──────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.red.withOpacity(0.15),
              border: Border.all(color: AppColors.red.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // REC noktası — AnimationController ile yanıp söner
                AnimatedBuilder(
                  animation: recOpacity,
                  builder: (_, __) => Opacity(
                    opacity: recOpacity.value,
                    child: Container(
                      width: 5, height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.redGlow,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text('CANLI',
                    style: AppTextStyles.mono(8,
                        color: AppColors.red, letterSpacing: 2.0)),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // ── Bölge adı ─────────────────────────────────
          Text('${zone.shortName} · ${zone.name}',
              style: AppTextStyles.display(10,
                  color: AppColors.cyan, letterSpacing: 1.5)),

          const Spacer(),

          // ── GPS koordinatları ─────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${telemetry.lat.toStringAsFixed(4)}°K',
                style: AppTextStyles.mono(7.5, color: AppColors.green),
              ),
              Text(
                '${telemetry.lng.toStringAsFixed(4)}°D',
                style: AppTextStyles.mono(7.5, color: AppColors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ALT HUD ÇUBUĞU  (bölge bilgisi + bağlantı durumu)
// ─────────────────────────────────────────────────────────────

class _BottomHudBar extends ConsumerWidget {
  const _BottomHudBar({required this.zone});
  final ZoneModel zone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(isConnectedProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xEE060A0D), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          // ── Uyarı etiketi (varsa) ──────────────────────
          if (zone.alertMessage != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: zone.alertLevel == ZoneAlertLevel.critical
                    ? AppColors.red.withOpacity(0.2)
                    : AppColors.amber.withOpacity(0.15),
                border: Border.all(
                  color: zone.alertLevel == ZoneAlertLevel.critical
                      ? AppColors.red
                      : AppColors.amber,
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                zone.alertMessage!,
                style: AppTextStyles.mono(7,
                    color: zone.alertLevel == ZoneAlertLevel.critical
                        ? AppColors.red
                        : AppColors.amber),
              ),
            ),

          const Spacer(),

          // ── Bağlantı durumu ───────────────────────────
          Row(
            children: [
              Container(
                width: 5, height: 5,
                decoration: BoxDecoration(
                  color: isConnected ? AppColors.green : AppColors.red,
                  shape: BoxShape.circle,
                  boxShadow: isConnected
                      ? AppShadows.greenGlow
                      : AppShadows.redGlow,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                isConnected ? 'BAĞLI' : 'BAĞLI DEĞİL',
                style: AppTextStyles.mono(7,
                    color: isConnected ? AppColors.green : AppColors.red,
                    letterSpacing: 1.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  CRT TARAMA ÇİZGİLERİ (statik — pointer-events yok)
// ─────────────────────────────────────────────────────────────

class _CrtScanlines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: List.generate(
              40,
              (i) => i.isEven
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.04),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  KÖŞE BRACKET'LARI (taktik kamera çerçevesi efekti)
// ─────────────────────────────────────────────────────────────

class _CornerBrackets extends StatelessWidget {
  const _CornerBrackets();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _BracketPainter(color: AppColors.cyan.withOpacity(0.55)),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  _BracketPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    const len = 14.0;
    const gap = 6.0;

    // Sol üst
    canvas.drawLine(Offset(gap, gap), Offset(gap + len, gap), paint);
    canvas.drawLine(Offset(gap, gap), Offset(gap, gap + len), paint);

    // Sağ üst
    canvas.drawLine(
        Offset(size.width - gap, gap),
        Offset(size.width - gap - len, gap), paint);
    canvas.drawLine(
        Offset(size.width - gap, gap),
        Offset(size.width - gap, gap + len), paint);

    // Sol alt
    canvas.drawLine(
        Offset(gap, size.height - gap),
        Offset(gap + len, size.height - gap), paint);
    canvas.drawLine(
        Offset(gap, size.height - gap),
        Offset(gap, size.height - gap - len), paint);

    // Sağ alt
    canvas.drawLine(
        Offset(size.width - gap, size.height - gap),
        Offset(size.width - gap - len, size.height - gap), paint);
    canvas.drawLine(
        Offset(size.width - gap, size.height - gap),
        Offset(size.width - gap, size.height - gap - len), paint);
  }

  @override
  bool shouldRepaint(_BracketPainter old) => old.color != color;
}

// ─────────────────────────────────────────────────────────────
//  YZ UYARI OVERLAY — Baret Yok, Yetkisiz Erişim vb.
// ─────────────────────────────────────────────────────────────

/// Video üzerine YZ tespit kutularını ve uyarı metnini gösterir.
/// aFlash: AnimationController tabanlı yanıp sönme (web proto eşdeğeri)
class AiAlertOverlay extends StatefulWidget {
  const AiAlertOverlay({super.key, required this.alerts});
  final List<AiAlert> alerts;

  @override
  State<AiAlertOverlay> createState() => _AiAlertOverlayState();
}

class _AiAlertOverlayState extends State<AiAlertOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flashCtrl;
  late final Animation<double> _flashOpacity;

  @override
  void initState() {
    super.initState();
    // aFlash: 1.5s periyot, web prototipindeki @keyframes aFlash ile aynı
    _flashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _flashOpacity = Tween<double>(begin: 1.0, end: 0.25).animate(
      CurvedAnimation(parent: _flashCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flashCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flashOpacity,
      builder: (context, _) {
        return Stack(
          children: [
            // Uyarı kutucukları (her alert için)
            ...widget.alerts.map((alert) => _buildAlertBox(alert)),

            // Alt uyarı banner'ı
            Positioned(
              bottom: 28,
              left: 10,
              right: 10,
              child: Opacity(
                opacity: _flashOpacity.value,
                child: _AlertBanner(alerts: widget.alerts),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlertBox(AiAlert alert) {
    final bbox = alert.boundingBox;
    if (bbox == null) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final isCritical = alert.type == AiAlertType.trespassing;
        final borderColor =
            isCritical ? AppColors.red : AppColors.amber;

        return Positioned(
          left: bbox.x * w,
          top: bbox.y * h,
          width: bbox.width * w,
          height: bbox.height * h,
          child: Opacity(
            opacity: _flashOpacity.value,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                color: borderColor.withOpacity(0.07),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  color: borderColor.withOpacity(0.75),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 3, vertical: 1),
                  child: Text(
                    '${alert.type.icon} ${alert.type.labelTr}',
                    style: AppTextStyles.mono(6,
                        color: Colors.white, letterSpacing: 0.5),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  UYARI BANNER (Alt metin şeridi)
// ─────────────────────────────────────────────────────────────

class _AlertBanner extends StatelessWidget {
  const _AlertBanner({required this.alerts});
  final List<AiAlert> alerts;

  @override
  Widget build(BuildContext context) {
    final topAlert = alerts.first;
    final isCritical = topAlert.type == AiAlertType.trespassing;
    final color = isCritical ? AppColors.red : AppColors.amber;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        border: Border.all(color: color.withOpacity(0.6), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(topAlert.type.icon,
              style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              topAlert.message,
              style: AppTextStyles.mono(8,
                  color: color, letterSpacing: 0.5),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (alerts.length > 1) ...[
            const SizedBox(width: 5),
            Text('+${alerts.length - 1}',
                style: AppTextStyles.mono(7,
                    color: color.withOpacity(0.7))),
          ],
        ],
      ),
    );
  }
}
