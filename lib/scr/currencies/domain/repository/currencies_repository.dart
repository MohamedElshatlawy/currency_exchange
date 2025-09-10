import 'package:fpdart/fpdart.dart';
import 'package:x_transfer/scr/currencies/domain/entities/currency_entity.dart';

import '../../../../core/common/models/failure.dart';

abstract class CurrenciesRepository {
  Future<Either<Failure, CurrenciesResponseEntity>> getAllCurrencies();
}
