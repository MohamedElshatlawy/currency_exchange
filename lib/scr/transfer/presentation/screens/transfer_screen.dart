import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/base/depindancy_injection.dart';
import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/components/app_bar/app_bar.dart';
import '../../../../core/components/app_bar/model/app_bar_model.dart';
import '../../../../core/components/app_text/app_text.dart';
import '../../../../core/components/app_text/models/app_text_model.dart';
import '../../../../core/util/constants.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../../currencies/domain/entities/currency_entity.dart';
import '../../../currencies/presentation/controller/currencies_view_model.dart';
import '../../domain/entities/transfer_entity.dart';
import '../components/transfer_widget.dart';
import '../controller/transfer_view_model.dart';

class TransferScreen extends StatefulWidget {
  final CurrenciesViewModel currenciesViewModel;

  const TransferScreen({super.key, required this.currenciesViewModel});
  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final viewModel = sl<TransferViewModel>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Constants.appBarSize,
        child: CustomAppBar(
          model: CustomAppBarModel(
            title: AppLocalizations.of(context)!.translate('transfer'),
          ),
        ),
      ),
      body: BlocBuilder<
        GenericCubit<CurrenciesResponseEntity>,
        GenericCubitState<CurrenciesResponseEntity>
      >(
        bloc: widget.currenciesViewModel.currenciesDetails,
        builder: (context, currencyState) {
          return currencyState is GenericLoadingState &&
                  !widget.currenciesViewModel.scrollController.isRefresh
              ? Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )
              : currencyState is GenericErrorState
              ? SizedBox()
              : SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: 50,
                  left: 24.w,
                  top: 3,
                  right: 24.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withValues(alpha: 0.5),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownMenuItemWidget(
                            title: AppLocalizations.of(
                              context,
                            )!.translate('amount'),
                            currenciesDetails:
                                widget.currenciesViewModel.currenciesDetails,
                            controller: viewModel.amountController,
                            selectedCurrency: viewModel.selectedCurrency,
                            onChanged: (value) {
                              setState(() {
                                viewModel.selectedCurrency = value!;
                              });
                              viewModel.getExchangeRate().whenComplete(() {
                                if (viewModel
                                    .amountController
                                    .text
                                    .isNotEmpty) {
                                  viewModel
                                      .transferredAmountController
                                      .text = viewModel.calculate(
                                    value: viewModel.amountController.text,
                                  );
                                }
                              });
                            },
                            onChangeInput: (val) {
                              viewModel
                                  .transferredAmountController
                                  .text = viewModel.calculate(value: val);
                            },
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Divider(
                                color: AppColors.hint.withValues(alpha: 0.5),
                                height: 100,
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryColor,
                                ),
                                child: Icon(
                                  Icons.swap_vert_outlined,
                                  color: AppColors.white,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                          DropdownMenuItemWidget(
                            title: AppLocalizations.of(
                              context,
                            )!.translate('transferred_amount'),
                            currenciesDetails:
                                widget.currenciesViewModel.currenciesDetails,
                            selectedCurrency:
                                viewModel.selectedTransferredCurrency,

                            onChanged: (value) {
                              setState(() {
                                viewModel.selectedTransferredCurrency = value!;
                              });
                              viewModel.getExchangeRate().whenComplete(() {
                                if (viewModel
                                    .transferredAmountController
                                    .text
                                    .isNotEmpty) {
                                  viewModel.amountController.text = viewModel
                                      .calculate(
                                        value:
                                            viewModel
                                                .transferredAmountController
                                                .text,
                                      );
                                }
                              });
                            },
                            controller: viewModel.transferredAmountController,
                            onChangeInput: (val) {
                              viewModel.amountController.text = viewModel
                                  .calculate(value: val);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    BlocBuilder<
                      GenericCubit<TransferResponseEntity>,
                      GenericCubitState<TransferResponseEntity>
                    >(
                      bloc: viewModel.exchangeRates,
                      builder: (context, exchangeRatesState) {
                        return exchangeRatesState is GenericLoadingState
                            ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                            : exchangeRatesState.data.exchangeRates != null
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: AppLocalizations.of(
                                    context,
                                  )!.translate('indicative_exchange_rate'),
                                  model: AppTextModel(
                                    style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale,
                                    ).button.copyWith(
                                      color: AppColors.grayColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                AppText(
                                  text:
                                      "1 ${viewModel.selectedCurrency!.code} = ${exchangeRatesState.data.exchangeRates!.first.rate} ${exchangeRatesState.data.exchangeRates!.first.code}",
                                  model: AppTextModel(
                                    style: AppFontStyleGlobal(
                                      AppLocalizations.of(context)!.locale,
                                    ).label.copyWith(color: AppColors.black),
                                  ),
                                ),
                              ],
                            )
                            : SizedBox();
                      },
                    ),
                  ],
                ),
              );
        },
      ),
    );
  }
}
