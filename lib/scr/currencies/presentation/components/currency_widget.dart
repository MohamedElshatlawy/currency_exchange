import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:x_transfer/core/common/app_colors/app_colors.dart';

import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/components/app_text/app_text.dart';
import '../../../../core/components/app_text/models/app_text_model.dart';
import '../../../../core/components/custom_network_image.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../domain/entities/currency_entity.dart';

class CurrencyWidget extends StatelessWidget {
  final CurrencyEntity currency;
  const CurrencyWidget({super.key, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                CustomNetworkImage(
                  url: "https://flagcdn.com/w80/${currency.imgSymbol}.png",
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                  border: Border.all(color: AppColors.shadow),
                ),
                SizedBox(width: 10.w),
                AppText(
                  text: "${currency.code}",
                  model: AppTextModel(
                    style: AppFontStyleGlobal(
                      AppLocalizations.of(context)!.locale,
                    ).button.copyWith(color: AppColors.black),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: AppText(
              text: "${currency.name}",
              model: AppTextModel(
                style: AppFontStyleGlobal(
                  AppLocalizations.of(context)!.locale,
                ).button.copyWith(color: AppColors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
