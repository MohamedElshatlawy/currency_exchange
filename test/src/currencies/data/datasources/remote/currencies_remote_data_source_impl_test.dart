import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:x_transfer/core/common/models/failure.dart';
import 'package:x_transfer/core/util/api_routes.dart';
import 'package:x_transfer/core/util/network_service.dart';
import 'package:x_transfer/scr/currencies/data/datasources/remote/currencies_remote_data_source_impl.dart';
import 'package:x_transfer/scr/currencies/data/models/currency_model.dart';

import 'currencies_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([NetworkService])
void main() {
  late CurrenciesRemoteDataSourceImpl dataSource;
  late MockNetworkService mockNetworkService;

  setUp(() {
    mockNetworkService = MockNetworkService();
    dataSource = CurrenciesRemoteDataSourceImpl(mockNetworkService);
  });

  group('getAllCurrencies', () {
    test('returns Right(CurrenciesResponseModel) when statusCode == 200', () async {
      final Map<String, dynamic> json = <String, dynamic>{
        'data': <String, dynamic>{
          'USD': <String, dynamic>{'name': 'US Dollar'},
          'EGP': <String, dynamic>{'code': 'EGP', 'name': 'Egyptian Pound'},
        },
      };

      when(mockNetworkService.get(
        ApiRoutes.currencies,
        queryParams: anyNamed('queryParams'),
      )).thenAnswer(
            (_) async => Response(
          statusCode: 200,
          data: json,
          requestOptions: RequestOptions(path: ApiRoutes.currencies),
        ),
      );

      final result = await dataSource.getAllCurrencies();

      expect(result.isRight(), isTrue);
      result.match(
            (l) => fail('Expected Right but got Left($l)'),
            (r) {
          expect(r, isA<CurrenciesResponseModel>());
          expect(r.currencies, isNotNull);
          expect(r.currencies!.length, 2);

          final usd = r.currencies![0] as CurrencyModel;
          final egp = r.currencies![1] as CurrencyModel;

          expect(usd.code, 'USD');
          expect(usd.imgSymbol, 'us');
          expect(usd.name, 'US Dollar');

          expect(egp.code, 'EGP');
          expect(egp.imgSymbol, 'eg');
          expect(egp.name, 'Egyptian Pound');
        },
      );

      verify(mockNetworkService.get(
        ApiRoutes.currencies,
        queryParams: anyNamed('queryParams'),
      )).called(1);
      verifyNoMoreInteractions(mockNetworkService);
    });

    test('returns Left(Failure) when statusCode != 200', () async {
      final Map<String, dynamic> errorBody = <String, dynamic>{'message': 'Bad request'};

      when(mockNetworkService.get(
        ApiRoutes.currencies,
        queryParams: anyNamed('queryParams'),
      )).thenAnswer(
            (_) async => Response(
          statusCode: 400,
          data: errorBody,
          requestOptions: RequestOptions(path: ApiRoutes.currencies),
        ),
      );

      final result = await dataSource.getAllCurrencies();

      expect(result.isLeft(), isTrue);
      result.match(
            (l) {
          expect(l, isA<Failure>());
          expect(l.errorMessage, isA<String>());
          expect(l.errorMessage.isNotEmpty, isTrue);
        },
            (_) => fail('Expected Left(Failure) but got Right'),
      );

      verify(mockNetworkService.get(
        ApiRoutes.currencies,
        queryParams: anyNamed('queryParams'),
      )).called(1);
      verifyNoMoreInteractions(mockNetworkService);
    });

    test('returns Left(Failure) when NetworkService throws Failure', () async {
      when(mockNetworkService.get(
        any,
        queryParams: anyNamed('queryParams'),
      )).thenThrow(Failure('Network error'));

      final result = await dataSource.getAllCurrencies();

      expect(result.isLeft(), isTrue);
      result.match(
            (l) => expect(l.errorMessage, 'Network error'),
            (_) => fail('Expected Left(Failure) but got Right'),
      );

      verify(mockNetworkService.get(
        any,
        queryParams: anyNamed('queryParams'),
      )).called(1);
      verifyNoMoreInteractions(mockNetworkService);
    });
  });
}
