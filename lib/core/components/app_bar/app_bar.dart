import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/app_colors/app_colors.dart';
import '../../common/app_font_style/app_font_style_global.dart';
import '../../util/localization/app_localizations.dart';
import '../app_text/app_text.dart';
import '../app_text/models/app_text_model.dart';
import 'model/app_bar_model.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CustomAppBarModel model;
  final double height;

  const CustomAppBar({super.key, required this.model, this.height = 64});

  @override
  Size get preferredSize => Size.fromHeight(height.h);

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    final Widget? titleWidget =
        (model.title != null)
            ? AppText(
              text: model.title!,
              model:
                  model.titleStyle ??
                  AppTextModel(
                    style: AppFontStyleGlobal(
                      AppLocalizations.of(context)!.locale,
                    ).subTitle1.copyWith(
                      fontSize: 20.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
            )
            : null;
    final bool showBack = model.showBackButton == true;
    final actions = model.actions ?? const <Widget>[];

    return SafeArea(
      bottom: false,
      child: Material(
        color: AppColors.white,
        elevation: 0,
        borderRadius: BorderRadius.circular(5.r),
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: preferredSize.height,
          padding: EdgeInsetsDirectional.only(start: 24.w, end: 24.w),
          alignment: Alignment.center,
          child: Row(
            children: [
              if (showBack)
                _BackButtonIcon(
                  onPressed: model.backOnTap ?? () {},
                  direction: direction,
                )
              else
                SizedBox(width: 40.w),
              Expanded(
                child: Center(child: titleWidget ?? const SizedBox.shrink()),
              ),
              if (actions.isNotEmpty)
                Row(children: actions)
              else
                SizedBox(width: 40.w),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButtonIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final TextDirection direction;

  const _BackButtonIcon({required this.onPressed, required this.direction});

  @override
  Widget build(BuildContext context) {
    final icon =
        direction == TextDirection.ltr
            ? Icons.west_outlined
            : Icons.east_outlined;

    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 28.sp, color: AppColors.grayColor),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      splashRadius: 24.r,
    );
  }
}
