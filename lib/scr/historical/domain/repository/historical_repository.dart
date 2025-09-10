import 'package:fpdart/fpdart.dart';
import '../../../../core/common/models/failure.dart';
import '../entities/historical_entity.dart';

abstract class HistoricalRepository {
  Future<Either<Failure, HistoricalResponseEntity>> getHistorical({
    required String baseCurrency,
    required String currencies,
    required String date,
  });
}
