import 'package:flutter/material.dart';

import '../app_colors/app_colors.dart';

class ThemeManager {
  static ThemeData? appTheme() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      appBarTheme: const AppBarTheme(color: Colors.transparent, elevation: 0),
      primaryColor: AppColors.primaryColor,
      indicatorColor:Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.grayColor,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
