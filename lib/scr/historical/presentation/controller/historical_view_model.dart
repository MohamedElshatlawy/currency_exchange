import 'package:intl/intl.dart';

import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/common/models/failure.dart';
import '../../../../core/util/network/network_info.dart';
import '../../../currencies/domain/entities/currency_entity.dart';
import '../../domain/entities/historical_entity.dart';
import '../../domain/usecases/historical_usecase.dart';

class HistoricalViewModel {
  final HistoricalUseCase useCase;
  final NetworkInfo networkInfo;

  HistoricalViewModel({required this.useCase, required this.networkInfo});
  CurrencyEntity? selectedFirstCurrency;
  CurrencyEntity? selectedSecondCurrency;
  GenericCubit<HistoricalResponseEntity> historicalRates = GenericCubit(
    HistoricalResponseEntity(),
  );
  GenericCubit<List<HistoricalEntity>> historicalList = GenericCubit([]);
  GenericCubit<bool> loading = GenericCubit(false);

  Future<void> getHistoricalRate({required String date}) async {
    historicalRates.onLoadingState();
    try {
      var response = await useCase.getHistorical(
        baseCurrency: selectedFirstCurrency!.code ?? '',
        currencies: selectedSecondCurrency!.code ?? "",
        date: date,
      );
      await response.fold(
        (l) async {
          historicalRates.onErrorState(l);
        },
        (r) async {
          historicalRates.onUpdateData(r);
          if (historicalRates.state.data.historical != null) {
            List<HistoricalEntity> temp = historicalList.state.data;
            temp.add(historicalRates.state.data.historical!.first);
            historicalList.onLoadingState();
            historicalList.onUpdateData(temp);
          }
        },
      );
    } on Failure catch (e) {
      historicalRates.onErrorState(Failure('$e', code: e.code));
    }
  }

  getAllHistoricalRates() async {
    if (selectedFirstCurrency != null && selectedSecondCurrency != null) {
      loading.onLoadingState();
      historicalList.onLoadingState();
      historicalList.onUpdateData([]);
      historicalRates.onLoadingState();
      historicalRates.onUpdateData(HistoricalResponseEntity());
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final fmt = DateFormat('yyyy-MM-dd');
      for (int i = 6; i >= 0; i--) {
        final d = yesterday.subtract(Duration(days: i));
        await getHistoricalRate(date: fmt.format(d));
      }
      loading.onUpdateData(true);
    }
  }
}
