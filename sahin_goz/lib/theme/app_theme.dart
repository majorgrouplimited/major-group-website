// ═══════════════════════════════════════════════════════════════
//  lib/theme/app_theme.dart
//  Şahin Göz — Merkezi Tema & Tasarım Sistemi
//
//  Sorumluluk: Web prototipinin CSS değişkenlerini Dart renk
//  sabitlerene dönüştürür. Tipografi, gölgeler ve Material 3
//  tema konfigürasyonu bu dosyada merkezi olarak yönetilir.
//  Hiçbir widget içinde hardcoded renk KULLANILMAMALIDIR.
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Renk paleti — CSS --bg0..--text4 ile birebir eşleşir.
abstract final class AppColors {
  // Arkaplan katmanları (koyu → açık)
  static const Color bg0 = Color(0xFF060A0D);
  static const Color bg1 = Color(0xFF0A1018);
  static const Color bg2 = Color(0xFF0E161F);
  static const Color bg3 = Color(0xFF131E2A);
  static const Color bg4 = Color(0xFF1A2535);

  // Vurgu renkleri
  static const Color cyan   = Color(0xFF00BFFF);
  static const Color green  = Color(0xFF00FF9D);
  static const Color amber  = Color(0xFFFFB400);
  static const Color red    = Color(0xFFFF3355);
  static const Color orange = Color(0xFFFF6B35); // İnşaat turuncusu

  // Metin hiyerarşisi
  static const Color text1 = Color(0xFFE0F0FF);
  static const Color text2 = Color(0xFFB0C8E6);
  static const Color text3 = Color(0xFF647896);
  static const Color text4 = Color(0xFF46738C);

  // Sınır renkleri
  static const Color border1 = Color(0x1A00B4FF);
  static const Color border2 = Color(0x3800B4FF);
  static const Color border3 = Color(0x6600B4FF);

  // Glow renkleri (BoxShadow için)
  static const Color glowCyan   = Color(0x4000BFFF);
  static const Color glowGreen  = Color(0x4000FF9D);
  static const Color glowRed    = Color(0x4DFF3355);
  static const Color glowAmber  = Color(0x4DFFB400);
  static const Color glowOrange = Color(0x4DFF6B35);
}

/// Tipografi — Rajdhani, Share Tech Mono, Barlow, Barlow Condensed
abstract final class AppTextStyles {
  /// Başlıklar, HUD, marka adı
  static TextStyle display(
    double size, {
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.text1,
    double letterSpacing = 2.0,
  }) =>
      GoogleFonts.rajdhani(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// Telemetri, koordinatlar, sayısal veriler
  static TextStyle mono(
    double size, {
    Color color = AppColors.text2,
    double letterSpacing = 1.0,
  }) =>
      GoogleFonts.shareTechMono(
        fontSize: size,
        color: color,
        letterSpacing: letterSpacing,
      );

  /// Genel gövde metni
  static TextStyle body(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.text2,
  }) =>
      GoogleFonts.barlow(
        fontSize: size,
        fontWeight: weight,
        color: color,
      );

  /// Kompakt etiketler, buton metinleri
  static TextStyle condensed(
    double size, {
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.text2,
    double letterSpacing = 1.5,
  }) =>
      GoogleFonts.barlowCondensed(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );

  // ── Hazır stiller ──────────────────────────────────────────
  static TextStyle get brandName =>
      display(16, color: AppColors.cyan, letterSpacing: 2.5);

  static TextStyle get brandSub =>
      mono(7, color: AppColors.text3, letterSpacing: 2.0);

  static TextStyle get hudValue =>
      mono(11, color: AppColors.text1, letterSpacing: 0.5);

  static TextStyle get hudLabel =>
      mono(7, color: AppColors.text3, letterSpacing: 1.5);

  static TextStyle get zoneLabel =>
      condensed(9, color: AppColors.text3, letterSpacing: 2.0);

  static TextStyle get zoneName =>
      display(10, weight: FontWeight.w600,
          color: AppColors.text1, letterSpacing: 0.5);

  static TextStyle get alertText =>
      mono(7, color: AppColors.red, letterSpacing: 0.5);

  static TextStyle get coordText =>
      mono(8, color: AppColors.green, letterSpacing: 0.5);
}

/// Glow/BoxShadow yardımcıları
abstract final class AppShadows {
  static List<BoxShadow> glow(Color color,
      {double spread = 8, double blur = 18}) =>
      [BoxShadow(color: color.withOpacity(0.35),
          blurRadius: blur, spreadRadius: spread / 4)];

  static List<BoxShadow> get cyanGlow  => glow(AppColors.cyan);
  static List<BoxShadow> get greenGlow => glow(AppColors.green, spread: 6, blur: 14);
  static List<BoxShadow> get redGlow   => glow(AppColors.red,   spread: 6, blur: 14);
  static List<BoxShadow> get amberGlow => glow(AppColors.amber, spread: 6, blur: 14);
  static List<BoxShadow> get orangeGlow => glow(AppColors.orange, spread: 8, blur: 20);
}

/// Boyut sabitleri
abstract final class AppSizes {
  static const double radiusSm = 8.0;
  static const double radius   = 12.0;
  static const double radiusLg = 16.0;

  static const double paddingXs = 6.0;
  static const double paddingSm = 10.0;
  static const double padding   = 14.0;
  static const double paddingLg = 20.0;

  // Canlı ekran dikey flex oranları
  static const int cameraFlex  = 38;
  static const int controlFlex = 10;
  static const int mapFlex     = 8;
  static const int zoneFlex    = 44;
}

/// Material 3 Koyu Tema
abstract final class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: AppColors.cyan,
        onPrimary: AppColors.bg0,
        secondary: AppColors.orange,
        onSecondary: AppColors.bg0,
        tertiary: AppColors.green,
        error: AppColors.red,
        surface: AppColors.bg1,
        onSurface: AppColors.text1,
        surfaceContainerHighest: AppColors.bg2,
        outline: AppColors.border2,
        outlineVariant: AppColors.border1,
      ),
      scaffoldBackgroundColor: AppColors.bg0,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg0,
        foregroundColor: AppColors.text1,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.bg0,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: AppTextStyles.display(16,
            color: AppColors.cyan, letterSpacing: 2.0),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bg1,
        selectedItemColor: AppColors.cyan,
        unselectedItemColor: AppColors.text3,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.bg1,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          side: const BorderSide(color: AppColors.border1),
        ),
      ),
      dividerTheme: const DividerThemeData(
          color: AppColors.border1, thickness: 1, space: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bg2,
        contentTextStyle: AppTextStyles.body(13, color: AppColors.text1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          side: const BorderSide(color: AppColors.border2),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      iconTheme: const IconThemeData(color: AppColors.text2, size: 20),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.cyan : AppColors.text3),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.cyan.withOpacity(0.25)
                : AppColors.bg3),
        trackOutlineColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.border3
                : AppColors.border1),
      ),
      textTheme: GoogleFonts.barlowTextTheme(base.textTheme).copyWith(
        displayLarge:   AppTextStyles.display(32),
        displayMedium:  AppTextStyles.display(26),
        displaySmall:   AppTextStyles.display(22),
        headlineMedium: AppTextStyles.display(18, weight: FontWeight.w600),
        headlineSmall:  AppTextStyles.display(16, weight: FontWeight.w600),
        titleLarge:     AppTextStyles.display(14, weight: FontWeight.w600),
        bodyLarge:      AppTextStyles.body(16),
        bodyMedium:     AppTextStyles.body(14),
        bodySmall:      AppTextStyles.body(12),
        labelLarge:     AppTextStyles.condensed(12),
        labelSmall:     AppTextStyles.mono(10),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
