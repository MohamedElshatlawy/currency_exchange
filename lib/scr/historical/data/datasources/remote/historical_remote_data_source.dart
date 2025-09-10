import '../../../../../core/common/models/failure.dart';
import '../../models/historical_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class HistoricalRemoteDataSource {
  Future<Either<Failure, HistoricalResponseModel>> getHistorical({
    required String baseCurrency,
    required String currencies,
    required String date,
  });
}
