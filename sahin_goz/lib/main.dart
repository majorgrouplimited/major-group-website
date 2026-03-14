// ═══════════════════════════════════════════════════════════════
//  lib/main.dart
//  Şahin Göz — Uygulama Giriş Noktası
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'theme/app_theme.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Portre moda kilitle (drone izleme uygulaması için)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Sistem UI'yı tam ekran / immersive moduna al
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.bg0,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Aktif izleme sırasında ekranı açık tut
  await WakelockPlus.enable();

  // ProviderScope: Riverpod'un kök widget'ı
  runApp(
    const ProviderScope(
      child: SahinGozApp(),
    ),
  );
}
