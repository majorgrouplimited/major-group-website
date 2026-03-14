// ═══════════════════════════════════════════════════════════════
//  lib/screens/main_shell_screen.dart  (Step 2 — güncellendi)
//  Şahin Göz — Ana Kabuk Ekranı
//
//  Değişiklik: Canlı sekmesi artık DashboardScreen'e bağlı.
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';
import '../providers/drone_provider.dart';
import 'dashboard_screen.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final hasAlerts = ref.watch(
        droneProvider.select((s) => s.valueOrNull?.hasAlerts ?? false));

    return Scaffold(
      backgroundColor: AppColors.bg0,
      // IndexedStack: tüm sekmeler bellekte, state korunur
      body: IndexedStack(
        index: _currentTab,
        children: const [
          DashboardScreen(),                         // 0 — Canlı
          _PlaceholderTab(label: 'Güvenlik Kayıtları'), // 1 — Step 4
          _PlaceholderTab(label: 'Ayarlar'),            // 2 — Step 4
          _PlaceholderTab(label: 'Profil'),              // 3 — Step 4
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentTab,
        hasAlerts: hasAlerts,
        onTap: (i) => setState(() => _currentTab = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.hasAlerts,
    required this.onTap,
  });

  final int currentIndex;
  final bool hasAlerts;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bg1,
        border: Border(top: BorderSide(color: AppColors.border2, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding > 0 ? 0 : 4),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.cyan,
            unselectedItemColor: AppColors.text3,
            selectedLabelStyle: AppTextStyles.mono(7.5, letterSpacing: 0.3),
            unselectedLabelStyle: AppTextStyles.mono(7.5, letterSpacing: 0.3),
            type: BottomNavigationBarType.fixed,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.videocam_outlined),
                activeIcon: Icon(Icons.videocam),
                label: 'CANLI',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shield_outlined),
                    if (hasAlerts)
                      Positioned(
                        right: -2, top: -2,
                        child: Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.bg1, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
                activeIcon: const Icon(Icons.shield),
                label: 'GÜVENLİK',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.tune_outlined),
                activeIcon: Icon(Icons.tune),
                label: 'AYARLAR',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'PROFİL',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.construction_rounded,
              color: AppColors.text4, size: 32),
          const SizedBox(height: 12),
          Text(label,
              style: AppTextStyles.display(18, color: AppColors.text3)),
          const SizedBox(height: 6),
          Text('Step 4\'te eklenecek',
              style: AppTextStyles.mono(10, color: AppColors.text4)),
        ],
      ),
    );
  }
}
