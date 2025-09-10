import 'package:flutter/cupertino.dart';
import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/common/models/failure.dart';
import '../../../../core/util/network/network_info.dart';
import '../../../currencies/domain/entities/currency_entity.dart';
import '../../domain/entities/transfer_entity.dart';
import '../../domain/usecases/transfer_usecase.dart';

class TransferViewModel {
  final TransferUseCase useCase;
  final NetworkInfo networkInfo;

  TransferViewModel({required this.useCase, required this.networkInfo});
  TextEditingController amountController = TextEditingController();
  TextEditingController transferredAmountController = TextEditingController();
  CurrencyEntity? selectedCurrency;
  CurrencyEntity? selectedTransferredCurrency;
  GenericCubit<TransferResponseEntity> exchangeRates = GenericCubit(
    TransferResponseEntity(),
  );

  Future<void> getExchangeRate() async {
    if (selectedCurrency != null && selectedTransferredCurrency != null) {
      exchangeRates.onLoadingState();
      try {
        var response = await useCase.getExchangeRate(
          baseCurrency: selectedCurrency!.code ?? '',
          currencies: selectedTransferredCurrency!.code ?? "",
        );
        await response.fold(
          (l) async {
            exchangeRates.onErrorState(l);
          },
          (r) async {
            exchangeRates.onUpdateData(r);
          },
        );
      } on Failure catch (e) {
        exchangeRates.onErrorState(Failure('$e', code: e.code));
      }
    }
  }

  String calculate({required String value}) {
    if (selectedCurrency != null &&
        selectedTransferredCurrency != null &&
        exchangeRates.state.data.exchangeRates != null&&value.isNotEmpty) {
      return (double.parse(value) *
              double.parse(
                exchangeRates.state.data.exchangeRates!.first.rate.toString(),
              ))
          .toStringAsFixed(4);
    }
    return '';
  }
}
