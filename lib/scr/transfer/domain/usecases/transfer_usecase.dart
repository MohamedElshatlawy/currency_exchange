import 'package:fpdart/fpdart.dart';
import '../../../../core/common/models/failure.dart';
import '../entities/transfer_entity.dart';
import '../repository/transfer_repository.dart';

class TransferUseCase {
  final TransferRepository _repository;

  TransferUseCase(this._repository);

  Future<Either<Failure, TransferResponseEntity>> getExchangeRate({
    required String baseCurrency,
    required String currencies,
  }) async {
    return await _repository.getExchangeRate(
      baseCurrency: baseCurrency,
      currencies: currencies,
    );
  }
}
