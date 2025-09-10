import 'package:dio/dio.dart';

import '../base/depindancy_injection.dart';
import '../common/config.dart';
import '../common/enums/response_type_enum.dart';

abstract class NetworkService {
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    ResponseTypeEnum? responseType,
    String? baseUrl,
  });
  Future<Response> post(
    String url,
    dynamic data, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    ResponseTypeEnum? responseType,
    String? baseUrl,
  });
  Future<Response> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    String? baseUrl,
  });

  Future<Response> put(
    String url,
    dynamic data, {
    Map<String, dynamic>? headers,
    String? baseUrl,
  });
  Future<Response> download(
    String url,
    dynamic savePath, {
    Map<String, dynamic>? headers,
    dynamic data,
    String? baseUrl,
  });
  removeValueFromHeader({required String key});
  setValueToHeader({required String key, required String value});
}

class NetworkServiceImpl implements NetworkService {
  final dio = sl<Dio>();
  @override
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    ResponseTypeEnum? responseType,
    String? baseUrl,
  }) async {
    try {
      final Response response = await dio.get(
        "${baseUrl ?? Config.baseUrl}$url",
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          responseType:
              responseType == ResponseTypeEnum.bytes
                  ? ResponseType.bytes
                  : ResponseType.json,
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        return Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 500,
          statusMessage: e.message ?? "Unknown Dio Error",
        );
      }
    }
  }

  @override
  Future<Response> post(
    String url,
    dynamic data, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    ResponseTypeEnum? responseType,
    String? baseUrl,
  }) async {
    final response = await dio.post(
      "${baseUrl ?? Config.baseUrl}$url",
      queryParameters: queryParams,
      data: data,
      options: Options(
        headers: headers,
        responseType:
            (responseType == ResponseTypeEnum.bytes)
                ? ResponseType.bytes
                : ResponseType.json,
      ),
    );
    return response;
  }

  @override
  Future<Response> put(
    String url,
    dynamic data, {
    Map<String, dynamic>? headers,
    String? baseUrl,
  }) async {
    final response = await dio.put(
      "${baseUrl ?? Config.baseUrl}$url",
      data: data,
      options: Options(headers: headers),
    );
    return response;
  }

  @override
  Future<Response> download(
    String url,
    savePath, {
    Map<String, dynamic>? headers,
    data,
    String? baseUrl,
  }) async {
    final response = await dio.download(
      "${baseUrl ?? Config.baseUrl}$url",
      savePath,
      data: data,
      options: Options(headers: headers),
    );
    return response;
  }

  @override
  Future<Response> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    String? baseUrl,
  }) async {
    final response = await dio.delete(
      "${baseUrl ?? Config.baseUrl}$url",
      queryParameters: queryParams,
      data: data,
      options: Options(headers: headers),
    );
    return response;
  }

  @override
  removeValueFromHeader({required String key}) =>
      dio.options.headers.remove(key);

  @override
  setValueToHeader({required String key, required String value}) =>
      dio.options.headers[key] = value;
}
