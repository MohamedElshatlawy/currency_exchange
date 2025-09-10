import 'package:equatable/equatable.dart';

class HistoricalResponseEntity extends Equatable {
  final List<HistoricalEntity>? historical;

  const HistoricalResponseEntity({this.historical});

  @override
  List<Object?> get props => [historical];
}

class HistoricalEntity extends Equatable {
  final String? date;
  final String? code;
  final double? rate;

  const HistoricalEntity({this.date, this.code, this.rate});

  @override
  List<Object?> get props => [date, code, rate];
}
