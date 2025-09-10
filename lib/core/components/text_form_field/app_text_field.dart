import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/app_colors/app_colors.dart';
import '../../common/app_font_style/app_font_style_global.dart';
import '../../util/localization/app_localizations.dart';
import '../app_text/app_text.dart';
import '../app_text/models/app_text_model.dart';
import 'models/app_text_field_model.dart';

class AppTextField extends StatefulWidget {
  final AppTextFieldModel model;

  const AppTextField({super.key, required this.model});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.model.label != null) ...[
          AppText(
            text: widget.model.label!,
            model: AppTextModel(
              style: AppFontStyleGlobal(
                AppLocalizations.of(context)!.locale,
              ).smallTab.copyWith(fontSize: 12.sp, color: AppColors.black),
            ),
          ),
          const SizedBox(height: 10),
        ],
        TextFormField(
          focusNode: _focusNode,
          onTapOutside: (pointerDownEvent) {
            _focusNode.unfocus();
          },
          cursorHeight: 24,
          cursorWidth: 2.5,
          cursorColor: AppColors.primaryColor,
          controller: widget.model.controller,
          initialValue: widget.model.initialValue,
          obscuringCharacter: '*',
          inputFormatters: widget.model.inputFormatter,
          obscureText: widget.model.obscureInputText,
          readOnly: widget.model.readOnly,
          onChanged: widget.model.onChangeInput,
          onEditingComplete: widget.model.onEditingComplete,
          onTap: widget.model.onTap,
          maxLines: widget.model.maxLines,
          minLines: widget.model.minLines,
          maxLength: widget.model.maxLength,
          keyboardType: widget.model.keyboardType,
          textInputAction: widget.model.textInputAction,
          decoration: widget.model.decoration.copyWith(
            counter: const SizedBox(),
            contentPadding:
                widget.model.minLines! > 1
                    ? const EdgeInsets.symmetric(vertical: 15, horizontal: 18)
                    : null,
            suffixIcon: widget.model.suffixIcon,
            prefixIcon: widget.model.prefixIcon,
            labelStyle: AppFontStyleGlobal(
              AppLocalizations.of(context)!.locale,
            ).smallTab.copyWith(
              fontSize: 12.sp,
              color:
                  _focusNode.hasFocus ||
                          widget.model.controller!.text.isNotEmpty
                      ? AppColors.primaryColor
                      : AppColors.hint,
              height: 0,
            ),
          ),
          validator: widget.model.validator,
          expands: widget.model.expands!,
          style:
              widget.model.style ??
              AppFontStyleGlobal(
                AppLocalizations.of(context)!.locale,
              ).bodyRegular1.copyWith(
                overflow: TextOverflow.ellipsis,
                color: AppColors.grayColor,
                height:
                    widget.model.minLines! > 1 &&
                            widget.model.controller!.text.isNotEmpty
                        ? null
                        : 1,
              ),
        ),
      ],
    );
  }
}
