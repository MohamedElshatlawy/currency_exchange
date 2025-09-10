import 'package:fpdart/fpdart.dart';
import '../../../../core/common/models/failure.dart';
import '../entities/transfer_entity.dart';

abstract class TransferRepository {
  Future<Either<Failure, TransferResponseEntity>> getExchangeRate({
    required String baseCurrency,
    required String currencies,
  });
}
