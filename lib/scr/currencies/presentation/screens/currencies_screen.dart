import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/components/app_bar/app_bar.dart';
import '../../../../core/components/app_bar/model/app_bar_model.dart';
import '../../../../core/util/constants.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../domain/entities/currency_entity.dart';
import '../components/currency_widget.dart';
import '../controller/currencies_view_model.dart';

class CurrenciesScreen extends StatefulWidget {
  final CurrenciesViewModel viewModel;

  const CurrenciesScreen({super.key, required this.viewModel});
  @override
  State<CurrenciesScreen> createState() => _CurrenciesScreenState();
}

class _CurrenciesScreenState extends State<CurrenciesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Constants.appBarSize,
        child: CustomAppBar(
          model: CustomAppBarModel(
            title: AppLocalizations.of(context)!.translate('currencies'),
          ),
        ),
      ),
      body: BlocBuilder<
        GenericCubit<CurrenciesResponseEntity>,
        GenericCubitState<CurrenciesResponseEntity>
      >(
        bloc: widget.viewModel.currenciesDetails,
        builder: (context, currencyState) {
          return currencyState is GenericLoadingState &&
                  !widget.viewModel.scrollController.isRefresh
              ? Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )
              : SmartRefresher(
                controller: widget.viewModel.scrollController,
                enablePullUp: false,
                enablePullDown: true,
                onRefresh: () => widget.viewModel.getCurrenciesData(context: context),
                onLoading: null,
                child: ListView.separated(
                  padding: EdgeInsets.only(
                    bottom: 50,
                    left: 14.w,
                    top: 3,
                    right: 14.w,
                  ),
                  shrinkWrap: true,
                  physics:
                      MediaQuery.of(context).viewInsets.bottom == 0
                          ? null
                          : const NeverScrollableScrollPhysics(),
                  itemCount: currencyState.data.currencies!.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 16.h);
                  },
                  itemBuilder:
                      (context, index) => CurrencyWidget(
                        currency: currencyState.data.currencies![index],
                      ),
                ),
              );
        },
      ),
    );
  }
}
