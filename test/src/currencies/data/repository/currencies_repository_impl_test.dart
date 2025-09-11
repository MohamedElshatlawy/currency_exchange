import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' show when, verify, verifyNever, provideDummy;
import 'package:fpdart/fpdart.dart';

import 'package:x_transfer/core/common/models/failure.dart';
import 'package:x_transfer/core/util/network/network_info.dart';

import 'package:x_transfer/scr/currencies/data/datasources/remote/currencies_remote_data_source.dart';
import 'package:x_transfer/scr/currencies/data/models/currency_model.dart';
import 'package:x_transfer/scr/currencies/data/repository/currencies_repository_impl.dart';

import 'package:x_transfer/scr/currencies/domain/entities/currency_entity.dart';

import 'currencies_repository_impl_test.mocks.dart';

@GenerateMocks([NetworkInfo, CurrenciesRemoteDataSource])
void main() {
  late MockNetworkInfo mockNetworkInfo;
  late MockCurrenciesRemoteDataSource mockDataSource;
  late CurrenciesRepositoryImp repository;

  String failureMsg(Failure f) {
    try {
      final msg = (f as dynamic).message;
      if (msg != null) return msg as String;
    } catch (_) {}
    try {
      final msg = (f as dynamic).error;
      if (msg != null) return msg as String;
    } catch (_) {}
    return f.toString();
  }

  setUpAll(() {
    provideDummy<Either<Failure, CurrenciesResponseModel>>(
      Left(Failure('dummy-model')),
    );
    provideDummy<Either<Failure, CurrenciesResponseEntity>>(
      Left(Failure('dummy-entity')),
    );
  });

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockDataSource = MockCurrenciesRemoteDataSource();
    repository = CurrenciesRepositoryImp(
      dataSource: mockDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getAllCurrencies', () {
    test('returns Right when network is connected and data source succeeds', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      final model = CurrenciesResponseModel(
        currencies: const [],
      );
      when(mockDataSource.getAllCurrencies())
          .thenAnswer((_) async => Right(model));
      // Act
      final result = await repository.getAllCurrencies();
      // Assert
      result.match(
            (l) => fail('Expected Right but got Left: ${failureMsg(l)}'),
            (r) {
          expect(r, isA<CurrenciesResponseEntity>());
        },
      );
      verify(mockNetworkInfo.isConnected);
      verify(mockDataSource.getAllCurrencies());
    });

    test('returns Left(Failure) when network is connected but data source throws', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockDataSource.getAllCurrencies()).thenThrow(Exception('boom'));
      // Act
      final result = await repository.getAllCurrencies();
      // Assert
      result.match(
            (l) => expect(failureMsg(l), contains('boom')),
            (r) => fail('Expected Left but got Right'),
      );
      verify(mockNetworkInfo.isConnected);
      verify(mockDataSource.getAllCurrencies());
    });

    test('returns Left(Failure("No Internet Connection")) when network is not connected', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      // Act
      final result = await repository.getAllCurrencies();
      // Assert
      result.match(
            (l) => expect(failureMsg(l), contains('No Internet Connection')),
            (r) => fail('Expected Left but got Right'),
      );
      verify(mockNetworkInfo.isConnected);
      verifyNever(mockDataSource.getAllCurrencies());
    });
  });
}
