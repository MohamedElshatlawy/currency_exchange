import 'package:dio/dio.dart';

class Failure extends DioException {
  final String errorMessage;
  final int? code;
  Failure(this.errorMessage, {this.code})
      : super(requestOptions: RequestOptions(path: ''));

  @override
  String toString() {
    return errorMessage;
  }
}
