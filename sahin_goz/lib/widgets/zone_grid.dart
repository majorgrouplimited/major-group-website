// ═══════════════════════════════════════════════════════════════
//  lib/widgets/zone_grid.dart
//  Şahin Göz — 4×2 Bölge Seçici Grid
//
//  Sorumluluk:
//    8 ZoneCard widget'ını 4×2 grid içinde düzenler.
//    Başlık çubuğu: toplam bölge sayısı, aktif uyarı sayısı,
//    YZ modeli durumu.
//
//  Layout:
//    Sabit 4 sütun, 2 satır — NeverScrollableScrollPhysics.
//    Expanded(flex: AppSizes.zoneFlex) içinde tam oturur.
//    Her kart eşit alan kaplar; aspect ratio 1:1.05.
//
//  Performans:
//    zonesProvider + activeZoneProvider ile sadece ilgili
//    değişimde rebuild tetiklenir.
//    Her ZoneCard kendi AnimationController'larını yönetir;
//    grid rebuild'i animasyonları sıfırlamaz (GlobalKey değil,
//    zone.id const key kullanılır).
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';
import '../providers/drone_provider.dart';
import '../models/ai_alert.dart';
import 'zone_card.dart';

class ZoneGrid extends ConsumerWidget {
  const ZoneGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zones    = ref.watch(zonesProvider);
    final activeId = ref.watch(activeZoneProvider).id;
    final alerts   = ref.watch(alertsProvider);

    final criticalCount = alerts
        .where((a) => a.type == AiAlertType.trespassing && !a.acknowledged)
        .length;
    final warningCount = alerts
        .where((a) => a.type != AiAlertType.trespassing && !a.acknowledged)
        .length;

    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSizes.paddingSm, 4, AppSizes.paddingSm, 0),
      decoration: BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: AppColors.border1),
      ),
      child: Column(
        children: [
          // ── Başlık çubuğu ──────────────────────────────
          _GridHeader(
            zoneCount: zones.length,
            criticalCount: criticalCount,
            warningCount: warningCount,
          ),

          // ── Ayırıcı çizgi ─────────────────────────────
          const Divider(height: 1, color: AppColors.border1),

          // ── Kart grid'i ───────────────────────────────
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(7, 6, 7, 7),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1.0,
              ),
              itemCount: zones.length,
              itemBuilder: (_, i) {
                final zone = zones[i];
                return ZoneCard(
                  // zone.id const key: ZoneCard state'i korunur
                  key: ValueKey('zone_card_${zone.id}'),
                  zone: zone,
                  isActive: zone.id == activeId,
                );
              },
            ),
          ),
        ],
      ),
    )
    .animate()
    .slideY(
      begin: 0.12,
      end: 0,
      curve: Curves.easeOutCubic,
      duration: const Duration(milliseconds: 480),
    )
    .fadeIn(duration: const Duration(milliseconds: 320));
  }
}

// ─────────────────────────────────────────────────────────────
//  BAŞLIK ÇUBUĞU
// ─────────────────────────────────────────────────────────────

class _GridHeader extends StatelessWidget {
  const _GridHeader({
    required this.zoneCount,
    required this.criticalCount,
    required this.warningCount,
  });

  final int zoneCount;
  final int criticalCount;
  final int warningCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 6),
      child: Row(
        children: [
          // ── Sol: BÖLGELER etiketi ────────────────────
          Text('BÖLGELER', style: AppTextStyles.zoneLabel),
          const SizedBox(width: 6),
          Text(
            '$zoneCount NOKTA',
            style: AppTextStyles.mono(7, color: AppColors.text4),
          ),

          const Spacer(),

          // ── Kritik uyarı rozeti ──────────────────────
          if (criticalCount > 0) ...[
            _AlertBadge(
              count: criticalCount,
              color: AppColors.red,
              label: 'KRİTİK',
            ),
            const SizedBox(width: 5),
          ],

          // ── Uyarı rozeti ─────────────────────────────
          if (warningCount > 0) ...[
            _AlertBadge(
              count: warningCount,
              color: AppColors.amber,
              label: 'UYARI',
            ),
            const SizedBox(width: 5),
          ],

          // ── Aktif göstergesi ─────────────────────────
          _ActiveIndicator(),
        ],
      ),
    );
  }
}

class _AlertBadge extends StatelessWidget {
  const _AlertBadge({
    required this.count,
    required this.color,
    required this.label,
  });
  final int count;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        border: Border.all(color: color.withOpacity(0.45), width: 0.8),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        '$count $label',
        style: AppTextStyles.mono(6.5, color: color, letterSpacing: 0.5),
      ),
    );
  }
}

class _ActiveIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.08),
        border: Border.all(color: AppColors.green.withOpacity(0.3), width: 0.8),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4, height: 4,
            decoration: const BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text('CANLI',
              style: AppTextStyles.mono(6.5,
                  color: AppColors.green, letterSpacing: 1.0)),
        ],
      ),
    );
  }
}
