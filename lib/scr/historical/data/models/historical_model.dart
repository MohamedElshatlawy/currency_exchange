import '../../domain/entities/historical_entity.dart';

class HistoricalResponseModel extends HistoricalResponseEntity {
  const HistoricalResponseModel({super.historical});

  factory HistoricalResponseModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] ?? {}) as Map<String, dynamic>;
    final list = <HistoricalModel>[];

    data.forEach((dateKey, currenciesMap) {
      final map = Map<String, dynamic>.from(currenciesMap as Map);
      map.forEach((code, rate) {
        list.add(
          HistoricalModel.fromTriplet(date: dateKey, code: code, rate: rate),
        );
      });
    });

    return HistoricalResponseModel(historical: list);
  }
}

class HistoricalModel extends HistoricalEntity {
  const HistoricalModel({super.date, super.code, super.rate});
  factory HistoricalModel.fromTriplet({
    required String date,
    required String code,
    required dynamic rate,
  }) {
    return HistoricalModel(
      date: date,
      code: code,
      rate: double.parse((rate as num).toDouble().toStringAsFixed(4)),
    );
  }
}
