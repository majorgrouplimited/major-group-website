// ═══════════════════════════════════════════════════════════════
//  lib/screens/splash_screen.dart
//  Şahin Göz — Açılış Ekranı
//
//  Sorumluluk:
//    Uygulama ilk açıldığında 2.2 saniye gösterilir.
//    Hexagonal logo animasyonu (ölçek + opacity) + marka adı.
//    Ardından MainShellScreen'e geçer.
//    Üretimde bu süreyi gerçek başlatma süresiyle
//    (WebSocket handshake, config fetch) eşleştirin.
// ═══════════════════════════════════════════════════════════════

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';
import 'main_shell_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hexCtrl;
  late final Animation<double> _hexRotation;

  @override
  void initState() {
    super.initState();

    // Hexagonal logo yavaş döndürme
    _hexCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _hexRotation = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(CurvedAnimation(parent: _hexCtrl, curve: Curves.linear));

    // 2.2s sonra ana ekrana geç
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainShellScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    });
  }

  @override
  void dispose() {
    _hexCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg0,
      body: Stack(
        children: [
          // ── Izgara arkaplan ──────────────────────────
          Positioned.fill(
            child: CustomPaint(painter: _SplashGridPainter()),
          ),

          // ── Radial gradient ──────────────────────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.7,
                  colors: [
                    AppColors.cyan.withOpacity(0.06),
                    AppColors.bg0,
                  ],
                ),
              ),
            ),
          ),

          // ── Merkez içerik ────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dönen hexagonal çerçeve + logo
                SizedBox(
                  width: 80, height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Dış dönen altıgen halkası
                      AnimatedBuilder(
                        animation: _hexRotation,
                        builder: (_, __) => Transform.rotate(
                          angle: _hexRotation.value,
                          child: CustomPaint(
                            size: const Size(80, 80),
                            painter: _HexRingPainter(),
                          ),
                        ),
                      ),
                      // Sabit iç logo
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0x2600BFFF),
                              Color(0x0D00BFFF),
                            ],
                          ),
                          boxShadow: AppShadows.cyanGlow,
                        ),
                        child: ClipPath(
                          clipper: _HexClipper(),
                          child: Container(
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.videocam_rounded,
                              color: AppColors.cyan,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .scale(
                  begin: const Offset(0.4, 0.4),
                  end: const Offset(1.0, 1.0),
                  curve: Curves.easeOutBack,
                  duration: const Duration(milliseconds: 700),
                )
                .fadeIn(duration: const Duration(milliseconds: 500)),

                const SizedBox(height: 24),

                // Marka adı
                Text('ŞAHİN GÖZ',
                    style: AppTextStyles.display(28,
                        color: AppColors.cyan, letterSpacing: 6.0))
                    .animate(delay: 300.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 6),

                Text('DRONE İZLEME SİSTEMİ',
                    style: AppTextStyles.mono(9,
                        color: AppColors.text3, letterSpacing: 3.5))
                    .animate(delay: 450.ms)
                    .fadeIn(duration: 500.ms),

                const SizedBox(height: 36),

                // Alt yükleniyor çizgisi
                SizedBox(
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      backgroundColor: AppColors.border1,
                      valueColor: const AlwaysStoppedAnimation(AppColors.cyan),
                      minHeight: 1.5,
                    ),
                  ),
                )
                .animate(delay: 600.ms)
                .fadeIn(duration: 400.ms),

                const SizedBox(height: 10),

                Text('BAĞLANTI KURULUYOR...',
                    style: AppTextStyles.mono(7.5,
                        color: AppColors.text4, letterSpacing: 2.0))
                    .animate(delay: 700.ms)
                    .fadeIn(duration: 400.ms),
              ],
            ),
          ),

          // ── Sürüm numarası (sağ alt) ─────────────────
          Positioned(
            bottom: 24, right: 20,
            child: Text('v1.0.0',
                style: AppTextStyles.mono(8, color: AppColors.text4))
                .animate(delay: 800.ms)
                .fadeIn(duration: 400.ms),
          ),

          // ── Şirket adı (sol alt) ─────────────────────
          Positioned(
            bottom: 24, left: 20,
            child: Text('MAJOR GRUP',
                style: AppTextStyles.mono(8, color: AppColors.text4))
                .animate(delay: 800.ms)
                .fadeIn(duration: 400.ms),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  YARDIMCI: Splash ızgara CustomPainter
// ─────────────────────────────────────────────────────────────

class _SplashGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0A00B4FF)
      ..strokeWidth = 0.8;
    const step = 22.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_SplashGridPainter _) => false;
}

// ─────────────────────────────────────────────────────────────
//  YARDIMCI: Dönen hexagonal halka CustomPainter
// ─────────────────────────────────────────────────────────────

class _HexRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final r = size.width / 2 - 2;
    final paint = Paint()
      ..color = AppColors.cyan.withOpacity(0.35)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * math.pi / 180;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);

    // Köşe noktaları
    final dotPaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    for (var i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * math.pi / 180;
      canvas.drawCircle(
        Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)),
        2.0,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_HexRingPainter _) => false;
}

// ─────────────────────────────────────────────────────────────
//  YARDIMCI: Hex clip path
// ─────────────────────────────────────────────────────────────

class _HexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    final p = Path();
    final cx = s.width / 2, cy = s.height / 2, r = s.width / 2;
    for (var i = 0; i < 6; i++) {
      final a = (i * 60 - 30) * math.pi / 180;
      final x = cx + r * math.cos(a), y = cy + r * math.sin(a);
      i == 0 ? p.moveTo(x, y) : p.lineTo(x, y);
    }
    p.close();
    return p;
  }

  @override
  bool shouldReclip(_HexClipper _) => false;
}
