import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import 'app_colors.dart';

class NetlayanTheme {
  /// Menghasilkan ThemeData berdasarkan peran pengguna (Role) dengan variasi aksen laut yang konsisten.
  static ThemeData getThemeForRole(UserRole? role) {
    Color primaryColor = AppColors.primaryOceanBlue;
    Color secondaryColor = AppColors.secondaryAqua;
    Color ctaColor = AppColors.accentCoral;

    if (role == UserRole.nelayan) {
      primaryColor = AppColors.primaryDarkDeepBlue;
      secondaryColor = AppColors.secondaryAqua;
      ctaColor = AppColors.secondaryAqua;
    } else if (role == UserRole.kurirLogistik) {
      primaryColor = AppColors.primaryOceanBlue;
      secondaryColor = AppColors.successSeaGreen;
      ctaColor = AppColors.successSeaGreen;
    } else if (role == UserRole.kementerianPerdagangan || role == UserRole.petugasTpi) {
      primaryColor = AppColors.adminPrimary;
      secondaryColor = AppColors.secondaryAqua;
      ctaColor = AppColors.secondaryAqua;
    } else {
      // Pembeli (Buyer)
      primaryColor = AppColors.primaryOceanBlue;
      secondaryColor = AppColors.secondaryAqua;
      ctaColor = AppColors.accentCoral;
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        tertiary: ctaColor,
        onTertiary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textNavy,
      ),
      scaffoldBackgroundColor: AppColors.backgroundSandWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor == AppColors.primaryOceanBlue ? AppColors.primaryDarkDeepBlue : primaryColor,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.surface,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ctaColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
