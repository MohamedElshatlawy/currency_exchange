import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/common/models/failure.dart';
import '../../../../core/util/db_helper.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../../../core/util/network/network_info.dart';
import '../../domain/entities/currency_entity.dart';
import '../../domain/usecases/currencies_usecase.dart';

class CurrenciesViewModel {
  final CurrenciesUseCase useCase;
  final NetworkInfo networkInfo;

  CurrenciesViewModel({required this.useCase, required this.networkInfo});
  RefreshController scrollController = RefreshController(initialRefresh: false);
  GenericCubit<CurrenciesResponseEntity> currenciesDetails = GenericCubit(
    CurrenciesResponseEntity(),
  );

  Future<void> getAllCurrencies() async {
    currenciesDetails.onLoadingState();
    try {
      var response = await useCase.getAllCurrencies();
      await response.fold(
        (l) async {
          currenciesDetails.onErrorState(l);
          scrollController.refreshFailed();
        },
        (r) async {
          currenciesDetails.onUpdateData(r);
          scrollController.refreshCompleted();
        },
      );
    } on Failure catch (e) {
      currenciesDetails.onErrorState(Failure('$e', code: e.code));
      scrollController.refreshFailed();
    }
  }

  Future<void> getCurrenciesData({required BuildContext context}) async {
    currenciesDetails.onLoadingState();
    if (!await networkInfo.isConnected) {
      showNoInternetDialog(context);
      await _loadCachedData(context);
      return;
    }
    _fetchAndCacheData(context);
  }

  Future<void> _fetchAndCacheData(BuildContext context) async {
    try {
      await getAllCurrencies();
      await DBHelper.clearCurrencies();
      await DBHelper.upsertCurrencies(
        currenciesDetails.state.data.currencies ?? [],
      );
    } catch (e) {
      currenciesDetails.onErrorState(
        Failure(AppLocalizations.of(context)!.translate('fetch_error')),
      );
    }
  }

  Future<void> _loadCachedData(BuildContext context) async {
    try {
      final cached = await DBHelper.getAllCurrencies();
      if (cached.isEmpty) {
        currenciesDetails.onErrorState(
          Failure(
            AppLocalizations.of(
              context,
            )!.translate('no_connection_or_data_stored'),
          ),
        );
        scrollController.refreshFailed();

        return;
      }
      List<CurrencyEntity> temp = [];
      for (final c in cached) {
        temp.add(
          CurrencyEntity(code: c.code, imgSymbol: c.imgSymbol, name: c.name),
        );
      }
      currenciesDetails.onUpdateData(
        CurrenciesResponseEntity(currencies: temp),
      );
      scrollController.refreshCompleted();
    } catch (e) {
      currenciesDetails.onErrorState(
        Failure(AppLocalizations.of(context)!.translate('load_cache_failed')),
      );
      scrollController.refreshFailed();
    }
  }

  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate('no_internet_connection'),
          ),
          content: Text(
            AppLocalizations.of(context)!.translate('check_internet'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(AppLocalizations.of(context)!.translate('ok')),
            ),
          ],
        );
      },
    );
  }
}
