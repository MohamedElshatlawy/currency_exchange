import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/base/depindancy_injection.dart';
import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/components/app_bar/app_bar.dart';
import '../../../../core/components/app_bar/model/app_bar_model.dart';
import '../../../../core/util/constants.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../../currencies/domain/entities/currency_entity.dart';
import '../../../currencies/presentation/controller/currencies_view_model.dart';
import '../../domain/entities/historical_entity.dart';
import '../components/historical_line_chart.dart';
import '../components/historical_widget.dart';
import '../controller/historical_view_model.dart';

class HistoricalScreen extends StatefulWidget {
  final CurrenciesViewModel currenciesViewModel;

  const HistoricalScreen({super.key, required this.currenciesViewModel});
  @override
  State<HistoricalScreen> createState() => _HistoricalScreenState();
}

class _HistoricalScreenState extends State<HistoricalScreen> {
  final viewModel = sl<HistoricalViewModel>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Constants.appBarSize,
        child: CustomAppBar(
          model: CustomAppBarModel(
            title: AppLocalizations.of(context)!.translate('historical'),
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
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 16,
                      left: 24.w,
                      top: 3,
                      right: 24.w,
                    ),
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
                        HistoricalWidget(
                          title: AppLocalizations.of(
                            context,
                          )!.translate('first_currency'),
                          currenciesDetails:
                              widget.currenciesViewModel.currenciesDetails,
                          selectedCurrency: viewModel.selectedFirstCurrency,
                          onChanged: (value) {
                            setState(() {
                              viewModel.selectedFirstCurrency = value!;
                            });
                            viewModel.getAllHistoricalRates();
                          },
                        ),
                        Divider(
                          color: AppColors.hint.withValues(alpha: 0.5),
                          height: 35,
                        ),
                        HistoricalWidget(
                          title: AppLocalizations.of(
                            context,
                          )!.translate('second_currency'),
                          currenciesDetails:
                              widget.currenciesViewModel.currenciesDetails,
                          selectedCurrency: viewModel.selectedSecondCurrency,
                          onChanged: (value) {
                            setState(() {
                              viewModel.selectedSecondCurrency = value!;
                            });
                            viewModel.getAllHistoricalRates();
                          },
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<GenericCubit<bool>, GenericCubitState<bool>>(
                    bloc: viewModel.loading,
                    builder: (context, loadingState) {
                      return loadingState is GenericLoadingState
                          ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                          : BlocBuilder<
                            GenericCubit<List<HistoricalEntity>>,
                            GenericCubitState<List<HistoricalEntity>>
                          >(
                            bloc: viewModel.historicalList,
                            builder: (context, historicalState) {
                              return historicalState.data.isNotEmpty
                                  ? HistoricalLineChart(
                                    items: historicalState.data,
                                  )
                                  : SizedBox();
                            },
                          );
                    },
                  ),
                ],
              );
        },
      ),
    );
  }
}
