import '../../../../../../core/util/network_service.dart';
import '../../../../../core/common/config.dart';
import '../../../../../core/common/error/error_handler.dart';
import '../../../../../core/util/api_routes.dart';
import 'historical_remote_data_source.dart';
import '../../../../../core/common/models/failure.dart';
import '../../models/historical_model.dart';
import 'package:fpdart/fpdart.dart';

class HistoricalRemoteDataSourceImpl implements HistoricalRemoteDataSource {
  final NetworkService networkService;

  HistoricalRemoteDataSourceImpl(this.networkService);
  @override
  Future<Either<Failure, HistoricalResponseModel>> getHistorical({
    required String baseCurrency,
    required String currencies,
    required String date,
  }) async {
    try {
      final response = await networkService.get(
        ApiRoutes.historical,
        queryParams: {
          "apikey": Config.apikey,
          "base_currency": baseCurrency,
          "currencies": currencies,
          "date":date,
        },
      );

      if (response.statusCode == 200) {
        return Right(HistoricalResponseModel.fromJson(response.data));
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
