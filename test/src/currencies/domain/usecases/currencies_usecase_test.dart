import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' show when, provideDummy, verify;
import 'package:fpdart/fpdart.dart';

import 'package:x_transfer/core/common/models/failure.dart';
import 'package:x_transfer/scr/currencies/domain/entities/currency_entity.dart';
import 'package:x_transfer/scr/currencies/domain/repository/currencies_repository.dart';
import 'package:x_transfer/scr/currencies/domain/usecases/currencies_usecase.dart';

import 'currencies_usecase_test.mocks.dart';

@GenerateMocks([CurrenciesRepository])
void main() {
  late MockCurrenciesRepository mockRepository;
  late CurrenciesUseCase useCase;

  String failureMsg(Failure f) {
    try {
      final m = (f as dynamic).message;
      if (m != null) return m as String;
    } catch (_) {}
    return f.toString();
  }

  setUpAll(() {
    provideDummy<Either<Failure, CurrenciesResponseEntity>>(
      Left(Failure('dummy')),
    );
  });

  setUp(() {
    mockRepository = MockCurrenciesRepository();
    useCase = CurrenciesUseCase(mockRepository);
  });

  test(
    'returns Right<Failure, CurrenciesResponseEntity> from repository',
    () async {
      // Arrange
      final expected = Right<Failure, CurrenciesResponseEntity>(
        CurrenciesResponseEntity(currencies: const []),
      );
      when(mockRepository.getAllCurrencies()).thenAnswer((_) async => expected);
      // Act
      final result = await useCase.getAllCurrencies();
      // Assert
      expect(result, isA<Either<Failure, CurrenciesResponseEntity>>());
      expect(result, expected);
      verify(mockRepository.getAllCurrencies());
    },
  );

  test(
    'returns Left<Failure, CurrenciesResponseEntity> when repository fails',
    () async {
      // Arrange
      final expectedLeft = Left<Failure, CurrenciesResponseEntity>(
        Failure('something went wrong'),
      );
      when(
        mockRepository.getAllCurrencies(),
      ).thenAnswer((_) async => expectedLeft);
      // Act
      final result = await useCase.getAllCurrencies();
      // Assert
      expect(result.isLeft(), true);
      result.match(
        (l) => expect(failureMsg(l), contains('something went wrong')),
        (_) => fail('Expected Left but got Right'),
      );
      verify(mockRepository.getAllCurrencies());
    },
  );
}
