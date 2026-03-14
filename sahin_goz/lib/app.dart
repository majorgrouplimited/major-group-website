// ═══════════════════════════════════════════════════════════════
//  lib/app.dart  (Step 3 — güncellendi)
//  Şahin Göz — Kök Uygulama Widget'ı
//  Değişiklik: home → SplashScreen (MainShellScreen yerine)
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

class SahinGozApp extends ConsumerWidget {
  const SahinGozApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Şahin Göz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: const Locale('tr', 'TR'),
      home: const SplashScreen(),
    );
  }
}
