import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/base/depindancy_injection.dart';
import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../../currencies/presentation/controller/currencies_view_model.dart';
import '../../../currencies/presentation/screens/currencies_screen.dart';
import '../../../historical/presentation/screens/historical_screen.dart';
import '../../../transfer/presentation/screens/transfer_screen.dart';
import '../controller/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = 'Home Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final viewModel = sl<HomeViewModel>();
  final currenciesViewModel = sl<CurrenciesViewModel>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currenciesViewModel.getCurrenciesData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GenericCubit<int>, GenericCubitState<int>>(
      bloc: viewModel.currentIndex,
      listener: (context, currentIndexState) {},
      builder: (context, currentIndexState) {
        return Scaffold(
          body:
              currentIndexState.data == 0
                  ? CurrenciesScreen(viewModel: currenciesViewModel)
                  : currentIndexState.data == 1
                  ? HistoricalScreen(currenciesViewModel: currenciesViewModel)
                  : TransferScreen(currenciesViewModel: currenciesViewModel),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedLabelStyle:
                    AppFontStyleGlobal(
                      AppLocalizations.of(context)!.locale,
                    ).bodyRegular1,

                unselectedLabelStyle:
                    AppFontStyleGlobal(
                      AppLocalizations.of(context)!.locale,
                    ).smallTab,
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: AppColors.bottomNavigationBarColor,
              currentIndex: currentIndexState.data,
              selectedIconTheme: IconThemeData(size: 35),
              unselectedIconTheme: IconThemeData(size: 25),
              selectedItemColor: AppColors.primaryColor,
              onTap: (index) => viewModel.updateCurrentIndex(index),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.paid_outlined),
                  label: AppLocalizations.of(context)!.translate('currencies'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined),
                  label: AppLocalizations.of(context)!.translate('historical'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.swap_horiz_outlined),
                  label: AppLocalizations.of(context)!.translate('transfer'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
