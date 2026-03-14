// ═══════════════════════════════════════════════════════════════
//  lib/widgets/telemetry_bar.dart
//  Şahin Göz — Drone Telemetri HUD Çubuğu
//
//  Sorumluluk:
//    Drone'un anlık irtifa, hız, pil ve sinyal verilerini
//    video altında yatay bir şerit olarak gösterir.
//
//  Performans:
//    Her telemetri değeri için ayrı granüler provider kullanılır.
//    Böylece sadece değişen metrik rebuild tetikler; tüm çubuk
//    yeniden çizilmez. Örn: sadece pil değiştiğinde
//    _BatteryCell rebuild olur, diğerleri olmaz.
//
//  Animasyon:
//    Sayı değişimlerinde AnimatedSwitcher + SlideTransition ile
//    yukarıdan kayma efekti uygulanır.
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';
import '../providers/drone_provider.dart';
import '../models/drone_telemetry.dart';
import '../services/websocket_service.dart';

// ─────────────────────────────────────────────────────────────
//  ANA TELEMETRY BAR
// ─────────────────────────────────────────────────────────────

/// Video oynatıcı altında gösterilen yatay telemetri şeridi.
class TelemetryBar extends ConsumerWidget {
  const TelemetryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sadece bağlantı durumu değiştiğinde bu katman rebuild olur
    final connState = ref.watch(connectionStateProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSm, vertical: 7),
      decoration: const BoxDecoration(
        color: AppColors.bg1,
        border: Border(
          top: BorderSide(color: AppColors.border2, width: 1),
          bottom: BorderSide(color: AppColors.border1, width: 1),
        ),
      ),
      child: Row(
        children: [
          // ── Pil ───────────────────────────────────────
          const Expanded(child: _BatteryCell()),

          _Divider(),

          // ── İrtifa ────────────────────────────────────
          const Expanded(child: _AltitudeCell()),

          _Divider(),

          // ── Hız ───────────────────────────────────────
          const Expanded(child: _SpeedCell()),

          _Divider(),

          // ── Sinyal ────────────────────────────────────
          const Expanded(child: _SignalCell()),

          _Divider(),

          // ── Bağlantı durumu ───────────────────────────
          Expanded(child: _ConnectionCell(state: connState)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  AYIRICI
// ─────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1, height: 26,
      color: AppColors.border1,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  PIl HÜCRESİ — granüler batteryProvider
// ─────────────────────────────────────────────────────────────

class _BatteryCell extends ConsumerWidget {
  const _BatteryCell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battery = ref.watch(batteryProvider);
    final color = _batteryColor(battery);

    return _TelCell(
      label: 'PIl',
      icon: _batteryIcon(battery),
      iconColor: color,
      valueWidget: _AnimatedValue(
        value: '$battery%',
        color: color,
      ),
      suffix: _BatteryBar(percent: battery, color: color),
    );
  }

  Color _batteryColor(int pct) {
    if (pct > 50) return AppColors.green;
    if (pct > 20) return AppColors.amber;
    return AppColors.red;
  }

  IconData _batteryIcon(int pct) {
    if (pct > 75) return Icons.battery_full_rounded;
    if (pct > 50) return Icons.battery_4_bar_rounded;
    if (pct > 25) return Icons.battery_2_bar_rounded;
    return Icons.battery_alert_rounded;
  }
}

/// İnce pil doluluk çubuğu
class _BatteryBar extends StatelessWidget {
  const _BatteryBar({required this.percent, required this.color});
  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22, height: 7,
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.6), width: 1),
        borderRadius: BorderRadius.circular(1.5),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            width: (22 - 2) * (percent / 100),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  İRTİFA HÜCRESİ — telemetryProvider.altitude
// ─────────────────────────────────────────────────────────────

class _AltitudeCell extends ConsumerWidget {
  const _AltitudeCell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alt = ref.watch(
        telemetryProvider.select((t) => t.altitude));

    return _TelCell(
      label: 'İRTİFA',
      icon: Icons.height_rounded,
      iconColor: AppColors.cyan,
      valueWidget: _AnimatedValue(
        value: '${alt.toStringAsFixed(1)}',
        color: AppColors.text1,
        suffix: 'm',
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  HIZ HÜCRESİ — telemetryProvider.speed
// ─────────────────────────────────────────────────────────────

class _SpeedCell extends ConsumerWidget {
  const _SpeedCell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = ref.watch(
        telemetryProvider.select((t) => t.speed));

    return _TelCell(
      label: 'HIZ',
      icon: Icons.speed_rounded,
      iconColor: AppColors.cyan,
      valueWidget: _AnimatedValue(
        value: '${speed.toStringAsFixed(1)}',
        color: AppColors.text1,
        suffix: ' km/s',
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SİNYAL HÜCRESİ — telemetryProvider.signal
// ─────────────────────────────────────────────────────────────

class _SignalCell extends ConsumerWidget {
  const _SignalCell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signal = ref.watch(
        telemetryProvider.select((t) => t.signal));

    final color = signal >= 80
        ? AppColors.green
        : signal >= 40
            ? AppColors.amber
            : AppColors.red;

    return _TelCell(
      label: 'SİNYAL',
      icon: Icons.network_wifi_rounded,
      iconColor: color,
      valueWidget: _AnimatedValue(
        value: '$signal',
        color: color,
        suffix: '%',
      ),
      suffix: _SignalBars(signal: signal, color: color),
    );
  }
}

/// 4 çubuklu sinyal gücü göstergesi
class _SignalBars extends StatelessWidget {
  const _SignalBars({required this.signal, required this.color});
  final int signal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final filled = (signal / 25).ceil().clamp(0, 4);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (i) {
        final height = 4.0 + i * 3.0;
        final active = i < filled;
        return Container(
          width: 3,
          height: height,
          margin: const EdgeInsets.only(left: 1.5),
          decoration: BoxDecoration(
            color: active ? color : AppColors.border2,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  BAĞLANTI DURUMU HÜCRESİ
// ─────────────────────────────────────────────────────────────

class _ConnectionCell extends StatelessWidget {
  const _ConnectionCell({required this.state});
  final WsConnectionState state;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (state) {
      WsConnectionState.connected     => ('BAĞLI',      AppColors.green),
      WsConnectionState.connecting    => ('BAĞLANIYOR', AppColors.amber),
      WsConnectionState.reconnecting  => ('YEN. BAĞ.',  AppColors.amber),
      WsConnectionState.disconnected  => ('BAĞLI DEĞİL',AppColors.red),
      WsConnectionState.error         => ('HATA',        AppColors.red),
    };

    return _TelCell(
      label: 'DURUM',
      icon: state == WsConnectionState.connected
          ? Icons.wifi_rounded
          : Icons.wifi_off_rounded,
      iconColor: color,
      valueWidget: Text(label,
          style: AppTextStyles.mono(7.5,
              color: color, letterSpacing: 0.5)),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  TEL HÜCRESİ — Ortak bileşen
// ─────────────────────────────────────────────────────────────

/// Tek bir telemetri metriğini gösterir.
class _TelCell extends StatelessWidget {
  const _TelCell({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.valueWidget,
    this.suffix,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final Widget valueWidget;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Etiket
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 9, color: iconColor),
            const SizedBox(width: 2),
            Text(label,
                style: AppTextStyles.hudLabel),
          ],
        ),
        const SizedBox(height: 3),
        // Değer + opsiyonel suffix widget
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            valueWidget,
            if (suffix != null) ...[
              const SizedBox(width: 3),
              suffix!,
            ],
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ANİMASYONLU DEĞER METNİ
//  Değer değiştiğinde yukarıdan kayarak giriş yapar
// ─────────────────────────────────────────────────────────────

class _AnimatedValue extends StatelessWidget {
  const _AnimatedValue({
    required this.value,
    required this.color,
    this.suffix = '',
  });

  final String value;
  final Color color;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.4),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Text(
        '$value$suffix',
        key: ValueKey(value),
        style: AppTextStyles.hudValue.copyWith(color: color),
      ),
    );
  }
}
