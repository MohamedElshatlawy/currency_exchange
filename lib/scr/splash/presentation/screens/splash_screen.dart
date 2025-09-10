import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/base/depindancy_injection.dart';
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/components/app_text/app_text.dart';
import '../../../../core/components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../controller/splash_screen_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = 'Splash Screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final viewModel = sl<SplashScreenViewModel>();
  @override
  void initState() {
    viewModel.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: AppText(
            text: AppLocalizations.of(context)!.translate('app_name'),
            model: AppTextModel(
              style: AppFontStyleGlobal(
                AppLocalizations.of(context)!.locale,
              ).headingMedium2.copyWith(color: AppColors.primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
