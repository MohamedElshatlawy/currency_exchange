import 'package:fpdart/fpdart.dart';
import '../../../../../../core/util/network/network_info.dart';
import '../../../../core/common/models/failure.dart';
import '../../domain/entities/historical_entity.dart';
import '../../domain/repository/historical_repository.dart';
import '../datasources/remote/historical_remote_data_source.dart';

class HistoricalRepositoryImp implements HistoricalRepository {
  final HistoricalRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  HistoricalRepositoryImp({
    required this.dataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, HistoricalResponseEntity>> getHistorical({
    required String baseCurrency,
    required String currencies,
    required String date,
  }) async {
    if (await networkInfo.isConnected) {
      return await dataSource.getHistorical(
        baseCurrency: baseCurrency,
        currencies: currencies,
        date: date,
      );
    } else {
      throw Exception('No Internet Connection');
    }
  }
}
