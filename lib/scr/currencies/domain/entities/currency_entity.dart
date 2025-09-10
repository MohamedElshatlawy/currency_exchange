import 'package:equatable/equatable.dart';

class CurrenciesResponseEntity extends Equatable {
  final List<CurrencyEntity>? currencies;

  const CurrenciesResponseEntity({this.currencies});

  @override
  List<Object?> get props => [currencies];
}

class CurrencyEntity extends Equatable {
  final String? code;
  final String? imgSymbol;
  final String? name;

  const CurrencyEntity({
    this.code,
    this.imgSymbol,
    this.name,
  });

  @override
  List<Object?> get props => [
    code,
    imgSymbol,
    name,
  ];
}
