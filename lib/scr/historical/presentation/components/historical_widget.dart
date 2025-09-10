import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:x_transfer/core/common/app_colors/app_colors.dart';

import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/common/app_component_style/component_style.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/components/app_text/app_text.dart';
import '../../../../core/components/app_text/models/app_text_model.dart';
import '../../../../core/components/custom_network_image.dart';
import '../../../../core/components/text_form_field/app_text_field.dart';
import '../../../../core/components/text_form_field/models/app_text_field_model.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../../currencies/domain/entities/currency_entity.dart';

class HistoricalWidget extends StatefulWidget {
  final GenericCubit<CurrenciesResponseEntity> currenciesDetails;
  final void Function(CurrencyEntity?)? onChanged;
  final CurrencyEntity? selectedCurrency;
  final String title;
  const HistoricalWidget({
    super.key,
    required this.currenciesDetails,
    required this.selectedCurrency,
    required this.title,
    this.onChanged,
  });

  @override
  State<HistoricalWidget> createState() => _HistoricalWidgetState();
}

class _HistoricalWidgetState extends State<HistoricalWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: widget.title,
          model: AppTextModel(
            style: AppFontStyleGlobal(
              AppLocalizations.of(context)!.locale,
            ).button.copyWith(fontSize: 18.sp, color: AppColors.grayColor),
          ),
        ),
        SizedBox(height: 16),
        BlocBuilder<
          GenericCubit<CurrenciesResponseEntity>,
          GenericCubitState<CurrenciesResponseEntity>
        >(
          bloc: widget.currenciesDetails,
          builder: (context, currencyState) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                border: Border.all(
                  color: AppColors.hint.withValues(alpha: 0.3),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CurrencyEntity>(
                  value: widget.selectedCurrency,
                  hint: AppText(
                    text: AppLocalizations.of(
                      context,
                    )!.translate('select_currency'),
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                        AppLocalizations.of(context)!.locale,
                      ).button.copyWith(color: AppColors.hint),
                    ),
                  ),
                  icon: Icon(
                    Icons.expand_more_outlined,
                    color: AppColors.hint.withValues(alpha: 0.5),
                    size: 35,
                  ),
                  isExpanded: true,
                  items:
                  currencyState.data.currencies!.map((e) {
                    return DropdownMenuItem<CurrencyEntity>(
                      value: e,
                      child: Row(
                        children: [
                          CustomNetworkImage(
                            url:
                            "https://flagcdn.com/w80/${e.imgSymbol}.png",
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            border: Border.all(
                              color: AppColors.shadow,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          AppText(
                            text: "${e.code}",
                            model: AppTextModel(
                              style: AppFontStyleGlobal(
                                AppLocalizations.of(context)!.locale,
                              ).button.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: widget.onChanged,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
