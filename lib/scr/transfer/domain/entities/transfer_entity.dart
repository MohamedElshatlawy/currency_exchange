import 'package:equatable/equatable.dart';

class TransferResponseEntity extends Equatable {
  final List<ExchangeRateEntity>? exchangeRates;

  const TransferResponseEntity({this.exchangeRates});

  @override
  List<Object?> get props => [exchangeRates];
}

class ExchangeRateEntity extends Equatable {
  final String? code;
  final double? rate;

  const ExchangeRateEntity({this.code, this.rate});

  @override
  List<Object?> get props => [code, rate];
}
