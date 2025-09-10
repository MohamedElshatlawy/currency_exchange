import 'package:flutter/cupertino.dart';

import '../../app_text/models/app_text_model.dart';

class CustomAppBarModel {
  final String? title;
  final AppTextModel? titleStyle;
  final bool? showBackButton;
  final void Function()? backOnTap;
  final List<Widget>? actions;

  CustomAppBarModel({
    this.title,
    this.titleStyle,
    this.showBackButton = false,
    this.backOnTap,
    this.actions,
  });
}
