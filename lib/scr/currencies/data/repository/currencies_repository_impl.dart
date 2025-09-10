import 'package:fpdart/fpdart.dart';
import 'package:x_transfer/scr/currencies/domain/entities/currency_entity.dart';

import '../../../../../../core/util/network/network_info.dart';
import '../../../../core/common/models/failure.dart';
import '../../domain/repository/currencies_repository.dart';
import '../datasources/remote/currencies_remote_data_source.dart';

class CurrenciesRepositoryImp implements CurrenciesRepository {
  final CurrenciesRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  CurrenciesRepositoryImp({required this.dataSource, required this.networkInfo});
  @override
  Future<Either<Failure, CurrenciesResponseEntity>> getAllCurrencies() async {
    if (await networkInfo.isConnected) {
      return await dataSource.getAllCurrencies();
    } else {
      throw Exception('No Internet Connection');
    }
  }
}
