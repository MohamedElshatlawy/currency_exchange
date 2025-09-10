import '../../../../../core/common/models/failure.dart';
import '../../models/transfer_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class TransferRemoteDataSource {
  Future<Either<Failure, TransferResponseModel>> getExchangeRate({
    required String baseCurrency,
    required String currencies,
  });
}
