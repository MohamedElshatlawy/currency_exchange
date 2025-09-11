import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' show when, provideDummy;
import 'package:fpdart/fpdart.dart';
import 'package:x_transfer/core/common/models/failure.dart';
import 'package:x_transfer/scr/currencies/domain/entities/currency_entity.dart';
import 'package:x_transfer/scr/currencies/domain/repository/currencies_repository.dart';

import 'currencies_repository_test.mocks.dart';

@GenerateMocks([CurrenciesRepository])
void main() {
  late MockCurrenciesRepository mockCurrenciesRepository;

  setUpAll(() {
    provideDummy<Either<Failure, CurrenciesResponseEntity>>(
      Left(Failure('dummy')),
    );
  });

  setUp(() {
    mockCurrenciesRepository = MockCurrenciesRepository();
  });

  test(
    'getAllCurrencies returns Either<Failure, CurrenciesResponseEntity>',
        () async {
      final expected = Right<Failure, CurrenciesResponseEntity>(
        CurrenciesResponseEntity(currencies: const []),
      );

      when(mockCurrenciesRepository.getAllCurrencies())
          .thenAnswer((_) async => expected);

      final result = await mockCurrenciesRepository.getAllCurrencies();

      expect(result, isA<Either<Failure, CurrenciesResponseEntity>>());
      expect(result, expected);
    },
  );
}
