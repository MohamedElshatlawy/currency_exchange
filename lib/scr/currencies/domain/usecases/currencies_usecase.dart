import 'package:fpdart/fpdart.dart';
import 'package:x_transfer/scr/currencies/domain/entities/currency_entity.dart';

import '../../../../core/common/models/failure.dart';
import '../repository/currencies_repository.dart';

class CurrenciesUseCase {
  final CurrenciesRepository _repository;

  CurrenciesUseCase(this._repository);

  Future<Either<Failure, CurrenciesResponseEntity>> getAllCurrencies() async {
    return await _repository.getAllCurrencies();
  }
}
