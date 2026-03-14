// ═══════════════════════════════════════════════════════════════
//  lib/screens/dashboard_screen.dart  (Step 3 — Final)
//  Şahin Göz — Ana Gösterge Paneli
//
//  Değişiklikler (Step 3):
//    • _ZonePlaceholder ve _ZoneChip kaldırıldı → ZoneGrid
//    • Sistem Durumu çubuğu eklendi (YZ modeli + şifreleme)
//    • Kullanılmayan import'lar temizlendi
// ═══════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';
import '../providers/drone_provider.dart';
import '../services/websocket_service.dart';
import '../widgets/drone_video_player.dart';
import '../widgets/telemetry_bar.dart';
import '../widgets/zone_grid.dart';

// ─────────────────────────────────────────────────────────────
//  GÖSTERGE PANELİ EKRANİ
// ─────────────────────────────────────────────────────────────

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      const simulate = bool.fromEnvironment('SIMULATE', defaultValue: true);
      if (simulate) {
        ref.read(droneProvider.notifier).startSimulation();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(droneProvider.notifier).reconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hata snackbar izleyicisi
    ref.listen<AsyncValue<DroneState>>(droneProvider, (_, next) {
      final error = next.valueOrNull?.lastError;
      if (error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.warning_amber_rounded,
                color: AppColors.amber, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text(error)),
          ]),
          backgroundColor: AppColors.bg2,
          duration: const Duration(seconds: 4),
        ));
      }
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (_) => _onBackPressed(),
      child: Scaffold(
        backgroundColor: AppColors.bg0,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── 1. Durum çubuğu ─────────────────────────
              const _StatusBar(),

              // ── 2. Ana içerik ────────────────────────────
              Expanded(
                child: Column(
                  children: [
                    // Kamera alanı
                    Expanded(
                      flex: AppSizes.cameraFlex,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            AppSizes.paddingSm, 4,
                            AppSizes.paddingSm, 0),
                        child: const DroneVideoPlayer(),
                      ),
                    ),

                    // Telemetri çubuğu
                    const TelemetryBar(),

                    // Kontrol çubuğu
                    const _ControlBar(),

                    // Sistem durumu çubuğu (Step 3 — YENİ)
                    const _SystemStatusBar(),

                    // Bölge grid'i (Step 3 — ZonePlaceholder yerini aldı)
                    const Expanded(
                      flex: AppSizes.zoneFlex,
                      child: ZoneGrid(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onBackPressed() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bg2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          side: const BorderSide(color: AppColors.border2),
        ),
        title: Text('Oturumu Kapat',
            style: AppTextStyles.display(16, color: AppColors.text1)),
        content: Text(
          'Drone izleme oturumunu kapatmak istiyor musunuz?\nDrone eve dönüş moduna alınacak.',
          style: AppTextStyles.body(13, color: AppColors.text2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('İPTAL',
                style: AppTextStyles.mono(11, color: AppColors.text3)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(droneProvider.notifier).returnToHome();
              if (mounted) SystemNavigator.pop();
            },
            child: Text('ÇIKIŞ',
                style: AppTextStyles.mono(11, color: AppColors.red)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  DURUM ÇUBUĞU
// ─────────────────────────────────────────────────────────────

class _StatusBar extends ConsumerStatefulWidget {
  const _StatusBar();

  @override
  ConsumerState<_StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends ConsumerState<_StatusBar> {
  late Timer _clockTimer;
  String _time = _nowTime();

  static String _nowTime() {
    final n = DateTime.now();
    return '${n.hour.toString().padLeft(2, '0')}:'
        '${n.minute.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => setState(() => _time = _nowTime()),
    );
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(isConnectedProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.paddingSm, 8, AppSizes.paddingSm, 6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xF7060A0D), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          _HexLogo(),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ŞAHİN GÖZ', style: AppTextStyles.brandName),
              Text('DRONE İZLEME', style: AppTextStyles.brandSub),
            ],
          ),
          const Spacer(),
          _GpsTag(),
          const SizedBox(width: 8),
          _SignalBars(connected: isConnected),
          const SizedBox(width: 8),
          Text(_time,
              style: AppTextStyles.mono(11, color: AppColors.text2)),
        ],
      ),
    );
  }
}

class _HexLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HexClipper(),
      child: Container(
        width: 22, height: 22,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.cyan, Color(0x4D00BFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: AppShadows.cyanGlow,
        ),
        child: const Icon(Icons.videocam_rounded,
            color: AppColors.cyan, size: 11),
      ),
    );
  }
}

class _HexClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    final p   = Path();
    final cx  = s.width / 2;
    final cy  = s.height / 2;
    final r   = s.width / 2;
    for (var i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * math.pi / 180;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      i == 0 ? p.moveTo(x, y) : p.lineTo(x, y);
    }
    p.close();
    return p;
  }

  @override
  bool shouldReclip(_HexClipper _) => false;
}

class _GpsTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.08),
        border: Border.all(color: AppColors.green.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text('GPS · AKTİF',
          style: AppTextStyles.mono(7.5, color: AppColors.green)),
    );
  }
}

class _SignalBars extends StatelessWidget {
  const _SignalBars({required this.connected});
  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (i) {
        final active = connected ? true : i == 0;
        return Container(
          width: 3,
          height: 5.0 + i * 2.5,
          margin: const EdgeInsets.only(left: 2),
          decoration: BoxDecoration(
            color: active ? AppColors.cyan : AppColors.border2,
            borderRadius: BorderRadius.circular(1),
            boxShadow: active ? AppShadows.cyanGlow : null,
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  KONTROL ÇUBUĞU
// ─────────────────────────────────────────────────────────────

class _ControlBar extends ConsumerWidget {
  const _ControlBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSwitching = ref.watch(
        droneProvider.select((s) => s.valueOrNull?.isSwitchingZone ?? false));
    final battery = ref.watch(batteryProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSm, vertical: 4),
      color: AppColors.bg0,
      child: Row(
        children: [
          // Pil
          _BatteryIndicator(battery: battery),
          const Spacer(),
          // Geçiş göstergesi
          if (isSwitching)
            Row(children: [
              SizedBox(
                width: 10, height: 10,
                child: CircularProgressIndicator(
                    strokeWidth: 1.5, color: AppColors.cyan),
              ),
              const SizedBox(width: 6),
              Text('BÖLGE DEĞİŞTİRİLİYOR...',
                  style: AppTextStyles.mono(8,
                      color: AppColors.cyan, letterSpacing: 1.5)),
            ]),
          const Spacer(),
          // RTH butonu
          _ReturnToHomeButton(
            onPressed: () => _confirmRth(context, ref),
          ),
        ],
      ),
    );
  }

  void _confirmRth(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bg2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          side: const BorderSide(color: AppColors.orange),
        ),
        title: Row(children: [
          const Icon(Icons.home_rounded, color: AppColors.orange, size: 20),
          const SizedBox(width: 8),
          Text('Eve Dön',
              style: AppTextStyles.display(16, color: AppColors.orange)),
        ]),
        content: Text(
          'Drone\'u kalkış noktasına geri döndürmek istiyor musunuz?',
          style: AppTextStyles.body(13, color: AppColors.text2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('İPTAL',
                style: AppTextStyles.mono(11, color: AppColors.text3)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange.withOpacity(0.15),
              foregroundColor: AppColors.orange,
              side: const BorderSide(color: AppColors.orange),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(droneProvider.notifier).returnToHome();
            },
            child: Text('EVE DÖN',
                style: AppTextStyles.display(12,
                    color: AppColors.orange, letterSpacing: 2.0)),
          ),
        ],
      ),
    );
  }
}

class _BatteryIndicator extends StatelessWidget {
  const _BatteryIndicator({required this.battery});
  final int battery;

  @override
  Widget build(BuildContext context) {
    final color = battery > 50
        ? AppColors.green
        : battery > 20
            ? AppColors.amber
            : AppColors.red;
    return Row(children: [
      Icon(Icons.battery_full_rounded, color: color, size: 14),
      const SizedBox(width: 3),
      Text('$battery%', style: AppTextStyles.mono(9, color: color)),
    ]);
  }
}

class _ReturnToHomeButton extends StatelessWidget {
  const _ReturnToHomeButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.orange.withOpacity(0.10),
          border: Border.all(color: AppColors.orange, width: 1.5),
          boxShadow: AppShadows.orangeGlow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_rounded, color: AppColors.orange, size: 15),
            Text('EVE',
                style: AppTextStyles.mono(5,
                    color: AppColors.orange, letterSpacing: 1.0)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SİSTEM DURUMU ÇUBUĞU  (Step 3 — YENİ)
//  YZ modeli aktifliği + şifreleme + bağlantı kalitesi
// ─────────────────────────────────────────────────────────────

class _SystemStatusBar extends ConsumerWidget {
  const _SystemStatusBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connState  = ref.watch(connectionStateProvider);
    final isConn     = ref.watch(isConnectedProvider);
    final signal     = ref.watch(
        telemetryProvider.select((t) => t.signal));
    final alertCount = ref.watch(alertsProvider).where((a) => !a.acknowledged).length;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSm, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bg1,
        border: const Border(
          top:    BorderSide(color: AppColors.border1),
          bottom: BorderSide(color: AppColors.border1),
        ),
      ),
      child: Row(
        children: [
          // ── YZ Modeli durumu ───────────────────────────
          _StatusChip(
            icon: Icons.psychology_outlined,
            label: 'YZ MODELİ',
            value: 'AKTİF',
            valueColor: AppColors.green,
          ),
          const SizedBox(width: 8),

          // ── Şifreleme durumu ───────────────────────────
          _StatusChip(
            icon: Icons.lock_outline_rounded,
            label: 'ŞİFRELEME',
            value: isConn ? 'AES-256' : 'YOK',
            valueColor: isConn ? AppColors.cyan : AppColors.red,
          ),
          const SizedBox(width: 8),

          // ── Sinyal kalitesi ───────────────────────────
          _StatusChip(
            icon: Icons.network_wifi_rounded,
            label: 'SİNYAL',
            value: '$signal%',
            valueColor: signal >= 70
                ? AppColors.green
                : signal >= 40
                    ? AppColors.amber
                    : AppColors.red,
          ),

          const Spacer(),

          // ── Aktif uyarı sayısı ─────────────────────────
          if (alertCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.12),
                border: Border.all(
                    color: AppColors.red.withOpacity(0.45), width: 0.8),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.red, size: 10),
                  const SizedBox(width: 3),
                  Text('$alertCount UYARI',
                      style: AppTextStyles.mono(7,
                          color: AppColors.red, letterSpacing: 0.5)),
                ],
              ),
            ),

          if (alertCount == 0)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.06),
                border: Border.all(
                    color: AppColors.green.withOpacity(0.25), width: 0.8),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text('UYARI YOK',
                  style: AppTextStyles.mono(7,
                      color: AppColors.green, letterSpacing: 0.5)),
            ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 9, color: AppColors.text4),
        const SizedBox(width: 3),
        Text('$label: ',
            style: AppTextStyles.mono(7, color: AppColors.text4)),
        Text(value,
            style: AppTextStyles.mono(7,
                color: valueColor, letterSpacing: 0.5)),
      ],
    );
  }
}
