import '../../domain/entities/currency_entity.dart';

class CurrenciesResponseModel extends CurrenciesResponseEntity {
  const CurrenciesResponseModel({super.currencies});

  factory CurrenciesResponseModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] ?? {}) as Map<String, dynamic>;
    final list =
        data.entries.map((e) {
          final value = Map<String, dynamic>.from(e.value as Map);
          return CurrencyModel.fromMap(value, codeOverride: e.key);
        }).toList();
    return CurrenciesResponseModel(currencies: list);
  }
}

class CurrencyModel extends CurrencyEntity {
  const CurrencyModel({super.code, super.imgSymbol, super.name});

  factory CurrencyModel.fromMap(
    Map<String, dynamic> map, {
    required String codeOverride,
  }) {
    return CurrencyModel(
      code:
          (codeOverride.isNotEmpty ? codeOverride : (map['code'] ?? ''))
              .toString(),
      imgSymbol:
          getImgSymbol(
            codeOverride.isNotEmpty ? codeOverride : (map['code'] ?? ''),
          ).toString(),
      name: (map['name'] ?? '').toString(),
    );
  }
  factory CurrencyModel.fromDbMap(Map<String, dynamic> map) {
    return CurrencyModel(
      code: map['code'] as String?,
      imgSymbol: map['img_symbol'] as String?,
      name: map['name'] as String?,
    );
  }

  Map<String, dynamic> toDbMap() {
    return {'code': code, 'img_symbol': imgSymbol, 'name': name};
  }
}

String getImgSymbol(String input) {
  if (input.length >= 2) {
    return input.substring(0, 2).toLowerCase();
  } else {
    return input.toLowerCase();
  }
}
