import 'package:fpdart/fpdart.dart';
import '../../../../core/common/models/failure.dart';
import '../entities/historical_entity.dart';
import '../repository/historical_repository.dart';

class HistoricalUseCase {
  final HistoricalRepository _repository;

  HistoricalUseCase(this._repository);

  Future<Either<Failure, HistoricalResponseEntity>> getHistorical({
    required String baseCurrency,
    required String currencies,
    required String date,
  }) async {
    return await _repository.getHistorical(
      baseCurrency: baseCurrency,
      currencies: currencies,
      date: date,
    );
  }
}
