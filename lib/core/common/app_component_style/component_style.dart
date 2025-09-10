import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors/app_colors.dart';
import '../app_font_style/app_font_style_global.dart';

class ComponentStyle {
  static InputDecoration inputDecoration(
    Locale locale, {
    BorderRadius? borderRadius,
  }) => InputDecoration(
    hintStyle: AppFontStyleGlobal(locale).smallTab.copyWith(
      fontSize: 14.sp,
      color: AppColors.primaryColor,
      height: 0,
    ),
    filled: false,
    labelStyle: AppFontStyleGlobal(locale).smallTab.copyWith(
      fontSize: 12.sp,
      color: AppColors.primaryColor,
      height: 0,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: BorderSide(color: AppColors.hint.withValues(alpha: 0.3)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: BorderSide(color: AppColors.hint.withValues(alpha: 0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: const BorderSide(color: AppColors.primaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    errorStyle: AppFontStyleGlobal(
      locale,
    ).smallTab.copyWith(color: AppColors.error),
  );
  static ButtonStyle get buttonStyle => ButtonStyle(
    fixedSize: WidgetStateProperty.all(Size(323.w, 40.h)),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        // side: const BorderSide(color: AppColors.outlinedBorder, width: 1),
        borderRadius: BorderRadius.circular(5.r),
      ),
    ),
  );
  static BoxDecoration get buttonDecoration => BoxDecoration(
    color: AppColors.primaryColor,
    borderRadius: BorderRadius.circular(5.r),
  );
}
