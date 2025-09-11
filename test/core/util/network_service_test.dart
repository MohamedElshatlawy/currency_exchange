import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:x_transfer/core/util/network_service.dart';
import 'package:x_transfer/core/common/enums/response_type_enum.dart';

import 'network_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late GetIt sl;
  late MockDio mockDio;
  late NetworkServiceImpl service;

  setUp(() {
    sl = GetIt.instance;
    sl.reset();
    mockDio = MockDio();

    sl.registerSingleton<Dio>(mockDio);

    service = NetworkServiceImpl();

    when(mockDio.options).thenReturn(BaseOptions());
  });

  tearDown(() async {
    await sl.reset();
  });

  group('GET', () {
    test('returns success response', () async {
      const base = 'https://api.example.com';
      const path = '/users';
      final url = '$base$path';

      when(
        mockDio.get(
          url,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: url),
          data: {'ok': true},
          statusCode: 200,
        ),
      );

      final res = await service.get(
        path,
        queryParams: {'q': 'a'},
        headers: {'h': 'v'},
        responseType: ResponseTypeEnum.json,
        baseUrl: base,
      );

      expect(res.statusCode, 200);
      expect(res.data, {'ok': true});

      verify(
        mockDio.get(
          url,
          queryParameters: {'q': 'a'},
          options: argThat(
            isA<Options>()
                .having((o) => o.headers?['h'], 'headers[h]', 'v')
                .having(
                  (o) => o.responseType,
                  'responseType',
                  ResponseType.json,
                ),
            named: 'options',
          ),
        ),
      ).called(1);
    });

    test('returns response from DioException with response', () async {
      const base = 'https://api.example.com';
      const path = '/fail';
      final url = '$base$path';

      final dioResponse = Response(
        requestOptions: RequestOptions(path: url),
        statusCode: 404,
        data: {'message': 'not found'},
      );

      when(
        mockDio.get(
          url,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: url),
          response: dioResponse,
          message: 'Not Found',
          type: DioExceptionType.badResponse,
        ),
      );

      final res = await service.get(path, baseUrl: base);

      expect(res.statusCode, 404);
      expect(res.data, {'message': 'not found'});
    });

    test('returns 500 response when DioException has no response', () async {
      const base = 'https://api.example.com';
      const path = '/crash';
      final url = '$base$path';

      when(
        mockDio.get(
          url,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: url),
          message: 'Network error',
          type: DioExceptionType.connectionError,
        ),
      );

      final res = await service.get(path, baseUrl: base);

      expect(res.statusCode, 500);
      expect(res.statusMessage, 'Network error');
    });
  });

  group('POST', () {
    test('posts data and returns success', () async {
      const base = 'https://api.example.com';
      const path = '/posts';
      final url = '$base$path';
      final body = {'title': 'hello'};

      when(
        mockDio.post(
          url,
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 201,
          data: {'id': 1},
        ),
      );

      final res = await service.post(
        path,
        body,
        queryParams: {'draft': '0'},
        headers: {'auth': 't'},
        responseType: ResponseTypeEnum.json,
        baseUrl: base,
      );

      expect(res.statusCode, 201);
      expect(res.data, {'id': 1});

      verify(
        mockDio.post(
          url,
          queryParameters: {'draft': '0'},
          data: body,
          options: argThat(
            isA<Options>()
                .having((o) => o.headers?['auth'], 'headers[auth]', 't')
                .having(
                  (o) => o.responseType,
                  'responseType',
                  ResponseType.json,
                ),
            named: 'options',
          ),
        ),
      ).called(1);
    });
  });

  group('PUT', () {
    test('puts data successfully', () async {
      const base = 'https://api.example.com';
      const path = '/posts/1';
      final url = '$base$path';
      final body = {'title': 'updated'};

      when(
        mockDio.put(url, data: anyNamed('data'), options: anyNamed('options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 200,
          data: {'ok': true},
        ),
      );

      final res = await service.put(
        path,
        body,
        headers: {'auth': 't'},
        baseUrl: base,
      );

      expect(res.statusCode, 200);
      expect(res.data, {'ok': true});

      verify(
        mockDio.put(
          url,
          data: body,
          options: argThat(
            isA<Options>().having(
              (o) => o.headers?['auth'],
              'headers[auth]',
              't',
            ),
            named: 'options',
          ),
        ),
      ).called(1);
    });
  });

  group('DELETE', () {
    test('deletes with query & body', () async {
      const base = 'https://api.example.com';
      const path = '/posts/1';
      final url = '$base$path';
      final body = {'soft': true};

      when(
        mockDio.delete(
          url,
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 204,
        ),
      );

      final res = await service.delete(
        path,
        queryParams: {'force': '0'},
        data: body,
        headers: {'auth': 't'},
        baseUrl: base,
      );

      expect(res.statusCode, 204);

      verify(
        mockDio.delete(
          url,
          queryParameters: {'force': '0'},
          data: body,
          options: argThat(
            isA<Options>().having(
              (o) => o.headers?['auth'],
              'headers[auth]',
              't',
            ),
            named: 'options',
          ),
        ),
      ).called(1);
    });
  });

  group('DOWNLOAD', () {
    test('downloads successfully', () async {
      const base = 'https://api.example.com';
      const path = '/file.zip';
      final url = '$base$path';
      final savePath = '/tmp/file.zip';

      when(
        mockDio.download(
          url,
          any, // savePath matcher
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 200,
        ),
      );

      final res = await service.download(
        path,
        savePath,
        headers: {'auth': 't'},
        data: {'mirror': 1},
        baseUrl: base,
      );

      expect(res.statusCode, 200);

      verify(
        mockDio.download(
          url,
          savePath,
          data: {'mirror': 1},
          options: argThat(
            isA<Options>().having(
              (o) => o.headers?['auth'],
              'headers[auth]',
              't',
            ),
            named: 'options',
          ),
        ),
      ).called(1);
    });
  });

  group('Headers helpers', () {
    test('setValueToHeader adds/updates header', () {
      final opts = BaseOptions();
      when(mockDio.options).thenReturn(opts);

      service.setValueToHeader(key: 'Authorization', value: 'Bearer x');
      expect(mockDio.options.headers['Authorization'], 'Bearer x');

      service.setValueToHeader(key: 'Authorization', value: 'Bearer y');
      expect(mockDio.options.headers['Authorization'], 'Bearer y');
    });

    test('removeValueFromHeader removes header', () {
      final opts = BaseOptions()..headers = {'k': 'v'};
      when(mockDio.options).thenReturn(opts);

      service.removeValueFromHeader(key: 'k');
      expect(mockDio.options.headers.containsKey('k'), isFalse);
    });
  });
}
