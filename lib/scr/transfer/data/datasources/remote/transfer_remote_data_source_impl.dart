import '../../../../../../core/util/network_service.dart';
import '../../../../../core/common/config.dart';
import '../../../../../core/common/error/error_handler.dart';
import '../../../../../core/util/api_routes.dart';
import 'transfer_remote_data_source.dart';
import '../../../../../core/common/models/failure.dart';
import '../../models/transfer_model.dart';
import 'package:fpdart/fpdart.dart';

class TransferRemoteDataSourceImpl implements TransferRemoteDataSource {
  final NetworkService networkService;

  TransferRemoteDataSourceImpl(this.networkService);
  @override
  Future<Either<Failure, TransferResponseModel>> getExchangeRate({
    required String baseCurrency,
    required String currencies,
  }) async {
    try {
      final response = await networkService.get(
        ApiRoutes.exchangeRate,
        queryParams: {
          "apikey": Config.apikey,
          "base_currency": baseCurrency,
          "currencies": currencies,
        },
      );

      if (response.statusCode == 200) {
        return Right(TransferResponseModel.fromJson(response.data));
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
