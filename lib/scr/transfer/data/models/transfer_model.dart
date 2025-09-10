import '../../domain/entities/transfer_entity.dart';

class TransferResponseModel extends TransferResponseEntity {
  const TransferResponseModel({super.exchangeRates});

  factory TransferResponseModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] ?? {}) as Map<String, dynamic>;
    final list =
        data.entries.map((e) => ExchangeRateModel.fromMapEntry(e)).toList();
    return TransferResponseModel(exchangeRates: list);
  }
}

class ExchangeRateModel extends ExchangeRateEntity {
  const ExchangeRateModel({super.code, super.rate});
  factory ExchangeRateModel.fromMapEntry(MapEntry<String, dynamic> entry) {
    return ExchangeRateModel(
      code: entry.key,
      rate: double.parse((entry.value as num).toDouble().toStringAsFixed(4)),
    );
  }
}
