import '../../../../../../core/util/network_service.dart';
import '../../../../../core/common/config.dart';
import '../../../../../core/common/error/error_handler.dart';
import '../../../../../core/util/api_routes.dart';
import 'currencies_remote_data_source.dart';
import '../../../../../core/common/models/failure.dart';
import '../../models/currency_model.dart';
import 'package:fpdart/fpdart.dart';

class CurrenciesRemoteDataSourceImpl implements CurrenciesRemoteDataSource {
  final NetworkService networkService;

  CurrenciesRemoteDataSourceImpl(this.networkService);
  @override
  Future<Either<Failure, CurrenciesResponseModel>> getAllCurrencies() async {
    try {
      final response = await networkService.get(
        ApiRoutes.currencies,
        queryParams: {"apikey": Config.apikey},
      );

      if (response.statusCode == 200) {
        return Right(CurrenciesResponseModel.fromJson(response.data));
      } else {
        final errorMessage = ResponseError.getErrorMessage(
          response.statusCode!,
          response.data,
        );
        return Left(Failure(errorMessage));
      }
    } on Failure catch (e) {
      return left(Failure(e.errorMessage));
    }
  }
}
