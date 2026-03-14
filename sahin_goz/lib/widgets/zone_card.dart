// ═══════════════════════════════════════════════════════════════
//  lib/widgets/zone_card.dart
//  Şahin Göz — Bölge Kart Widget'ı
//
//  Sorumluluk:
//    8 izleme bölgesinden birini temsil eden grid kartı.
//    Seçili kart: inşaat turuncusu glow sınır + titreşimli
//    AKTİF göstergesi. Uyarılı kart: kırmızı/amber sınır +
//    yanıp sönen uyarı noktası.
//
//  Video önizleme stratejisi:
//    Aktif olmayan kartlar VLC yerine statik arka plan gösterir
//    (bant genişliği tasarrufu). Kart tıklanıp aktif olunca
//    ana DroneVideoPlayer o bölgeyi oynatır.
//    Aktif kartta "CANLI" rozeti + pulsing dot görünür.
//
//  Animasyonlar:
//    - AKTİF noktası: AnimationController ile sürekli pulse
//    - Uyarı noktası: AnimationController ile aFlash yanıp sönme
//    - Sınır: AnimatedContainer ile 200ms geçiş
//    - Glow: BoxShadow AnimatedContainer içinde
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';
import '../models/zone_model.dart';
import '../providers/drone_provider.dart';

// ─────────────────────────────────────────────────────────────
//  ZONE CARD
// ─────────────────────────────────────────────────────────────

class ZoneCard extends ConsumerStatefulWidget {
  const ZoneCard({
    super.key,
    required this.zone,
    required this.isActive,
  });

  final ZoneModel zone;
  final bool isActive;

  @override
  ConsumerState<ZoneCard> createState() => _ZoneCardState();
}

class _ZoneCardState extends ConsumerState<ZoneCard>
    with TickerProviderStateMixin {
  // ── AKTİF pulse animasyonu ──────────────────────────────────
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  // ── Uyarı flash animasyonu (aFlash) ────────────────────────
  late final AnimationController _flashCtrl;
  late final Animation<double> _flashOpacity;

  // ── Dokunma efekti ─────────────────────────────────────────
  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    // Pulse: 1.6s periyot, scale 1.0→1.3, opacity 0.9→0.0
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _pulseScale = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut),
    );
    _pulseOpacity = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut),
    );

    // aFlash: 1.2s periyot, opacity 1.0→0.2
    _flashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _flashOpacity = Tween<double>(begin: 1.0, end: 0.15).animate(
      CurvedAnimation(parent: _flashCtrl, curve: Curves.easeInOut),
    );

    // Uyarı yoksa flash durdur (CPU tasarrufu)
    if (!widget.zone.hasAlert) _flashCtrl.stop();
  }

  @override
  void didUpdateWidget(ZoneCard old) {
    super.didUpdateWidget(old);
    // Uyarı durumu değişince animasyonu güncelle
    if (old.zone.hasAlert != widget.zone.hasAlert) {
      if (widget.zone.hasAlert) {
        _flashCtrl.repeat(reverse: true);
      } else {
        _flashCtrl.stop();
        _flashCtrl.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _flashCtrl.dispose();
    super.dispose();
  }

  // ── Renk hesaplama ──────────────────────────────────────────

  Color get _borderColor {
    if (widget.isActive) return AppColors.orange;
    return switch (widget.zone.alertLevel) {
      ZoneAlertLevel.critical => AppColors.red,
      ZoneAlertLevel.warning  => AppColors.amber,
      ZoneAlertLevel.normal   => AppColors.border2,
    };
  }

  Color get _bgColor {
    if (widget.isActive) return AppColors.orange.withOpacity(0.07);
    return switch (widget.zone.alertLevel) {
      ZoneAlertLevel.critical => AppColors.red.withOpacity(0.05),
      ZoneAlertLevel.warning  => AppColors.amber.withOpacity(0.04),
      ZoneAlertLevel.normal   => AppColors.bg2,
    };
  }

  List<BoxShadow>? get _glow {
    if (widget.isActive) return AppShadows.orangeGlow;
    return switch (widget.zone.alertLevel) {
      ZoneAlertLevel.critical => AppShadows.redGlow,
      ZoneAlertLevel.warning  => AppShadows.amberGlow,
      ZoneAlertLevel.normal   => null,
    };
  }

  Color get _indicatorColor {
    if (widget.isActive) return AppColors.orange;
    return switch (widget.zone.alertLevel) {
      ZoneAlertLevel.critical => AppColors.red,
      ZoneAlertLevel.warning  => AppColors.amber,
      ZoneAlertLevel.normal   => AppColors.green,
    };
  }

  // ── Build ───────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) => setState(() => _pressed = false),
      onTapCancel: ()  => setState(() => _pressed = false),
      onTap: () => ref.read(droneProvider.notifier).switchZone(widget.zone.id),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(
              color: _borderColor,
              width: widget.isActive ? 1.8 : 1.0,
            ),
            boxShadow: _glow,
          ),
          child: Stack(
            children: [
              // ── Izgara arkaplan dokusu ───────────────────
              _GridTexture(),

              // ── Kart içeriği ─────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Üst satır: bölge kodu + durum noktası
                    _CardTopRow(
                      zone: widget.zone,
                      isActive: widget.isActive,
                      indicatorColor: _indicatorColor,
                      pulseScale: _pulseScale,
                      pulseOpacity: _pulseOpacity,
                      flashOpacity: _flashOpacity,
                    ),

                    const Spacer(),

                    // Alt satır: bölge adı + işçi sayısı
                    _CardBottomRow(
                      zone: widget.zone,
                      isActive: widget.isActive,
                    ),
                  ],
                ),
              ),

              // ── Aktif kart: CANLI rozeti ─────────────────
              if (widget.isActive)
                Positioned(
                  top: 4, right: 4,
                  child: _LiveBadge(),
                ),

              // ── Uyarı mesajı overlay ─────────────────────
              if (widget.zone.alertMessage != null)
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: AnimatedBuilder(
                    animation: _flashOpacity,
                    builder: (_, __) => Opacity(
                      opacity: widget.isActive ? 1.0 : _flashOpacity.value,
                      child: _AlertStripe(zone: widget.zone),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  IZGARA DOKU ARKA PLANI
// ─────────────────────────────────────────────────────────────

class _GridTexture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(painter: _GridPainter()),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border1
      ..strokeWidth = 0.5;

    const step = 12.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}

// ─────────────────────────────────────────────────────────────
//  KART ÜST SATIRI — Bölge kodu + durum noktası
// ─────────────────────────────────────────────────────────────

class _CardTopRow extends StatelessWidget {
  const _CardTopRow({
    required this.zone,
    required this.isActive,
    required this.indicatorColor,
    required this.pulseScale,
    required this.pulseOpacity,
    required this.flashOpacity,
  });

  final ZoneModel zone;
  final bool isActive;
  final Color indicatorColor;
  final Animation<double> pulseScale;
  final Animation<double> pulseOpacity;
  final Animation<double> flashOpacity;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bölge kodu (B1–B8)
        Text(
          zone.shortName,
          style: AppTextStyles.display(
            13,
            color: isActive ? AppColors.orange : AppColors.text1,
            letterSpacing: 0.5,
          ),
        ),

        const Spacer(),

        // Durum göstergesi (pulse veya flash)
        SizedBox(
          width: 14, height: 14,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Dış halka (pulse)
              if (isActive || zone.hasAlert)
                AnimatedBuilder(
                  animation: isActive ? pulseScale : flashOpacity,
                  builder: (_, __) {
                    if (isActive) {
                      return Transform.scale(
                        scale: pulseScale.value,
                        child: Opacity(
                          opacity: pulseOpacity.value,
                          child: Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: indicatorColor.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Opacity(
                        opacity: flashOpacity.value,
                        child: Container(
                          width: 10, height: 10,
                          decoration: BoxDecoration(
                            color: indicatorColor.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }
                  },
                ),

              // İç nokta (sabit)
              Container(
                width: 5, height: 5,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: indicatorColor.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  KART ALT SATIRI — Bölge adı + işçi sayısı
// ─────────────────────────────────────────────────────────────

class _CardBottomRow extends StatelessWidget {
  const _CardBottomRow({required this.zone, required this.isActive});
  final ZoneModel zone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bölge tam adı
        Text(
          zone.name,
          style: AppTextStyles.condensed(
            7.5,
            color: isActive ? AppColors.text1 : AppColors.text2,
            letterSpacing: 0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 1),
        // İşçi sayısı (YZ tespiti)
        Row(
          children: [
            Icon(Icons.person_outline_rounded,
                size: 7, color: AppColors.text4),
            const SizedBox(width: 2),
            Text(
              '${zone.workerCount}',
              style: AppTextStyles.mono(6.5, color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  CANLI ROZETİ — Aktif kart sağ üst köşesi
// ─────────────────────────────────────────────────────────────

class _LiveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.red.withOpacity(0.85),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        'CANLI',
        style: AppTextStyles.mono(5,
            color: Colors.white, letterSpacing: 1.0),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  UYARI ŞERİDİ — Alt kısımda uyarı mesajı
// ─────────────────────────────────────────────────────────────

class _AlertStripe extends StatelessWidget {
  const _AlertStripe({required this.zone});
  final ZoneModel zone;

  @override
  Widget build(BuildContext context) {
    final color = zone.alertLevel == ZoneAlertLevel.critical
        ? AppColors.red
        : AppColors.amber;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.radiusSm),
          bottomRight: Radius.circular(AppSizes.radiusSm),
        ),
      ),
      child: Text(
        zone.alertMessage ?? '',
        style: AppTextStyles.mono(5.5, color: color, letterSpacing: 0.3),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}
