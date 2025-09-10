import 'package:fpdart/fpdart.dart';
import '../../../../../../core/util/network/network_info.dart';
import '../../../../core/common/models/failure.dart';
import '../../domain/entities/transfer_entity.dart';
import '../../domain/repository/transfer_repository.dart';
import '../datasources/remote/transfer_remote_data_source.dart';

class TransferRepositoryImp implements TransferRepository {
  final TransferRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  TransferRepositoryImp({required this.dataSource, required this.networkInfo});
  @override
  Future<Either<Failure, TransferResponseEntity>> getExchangeRate({
    required String baseCurrency,
    required String currencies,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        return await dataSource.getExchangeRate(
          baseCurrency: baseCurrency,
          currencies: currencies,
        );
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    } else {
      return Left(Failure('No Internet Connection'));
    }
  }
}
