import '../../../../../core/common/models/failure.dart';
import '../../models/currency_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class CurrenciesRemoteDataSource {
  Future<Either<Failure, CurrenciesResponseModel>> getAllCurrencies();
}
