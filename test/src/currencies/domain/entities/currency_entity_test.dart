import 'package:flutter_test/flutter_test.dart';
import 'package:x_transfer/scr/currencies/domain/entities/currency_entity.dart';

void main() {
  const usd = CurrencyEntity(
    code: 'USD',
    imgSymbol: 'usd.png',
    name: 'US Dollar',
  );
  const eur = CurrencyEntity(code: 'EUR', imgSymbol: 'eur.png', name: 'Euro');

  group('CurrencyEntity', () {
    test('should create a CurrencyEntity instance', () {
      expect(usd, isA<CurrencyEntity>());
    });

    test('equality: two entities with same values are equal', () {
      const anotherUsd = CurrencyEntity(
        code: 'USD',
        imgSymbol: 'usd.png',
        name: 'US Dollar',
      );
      expect(usd, equals(anotherUsd));
      expect(usd.hashCode, equals(anotherUsd.hashCode));
    });

    test('inequality: entities differ if one field is different', () {
      const usdDifferentName = CurrencyEntity(
        code: 'USD',
        imgSymbol: 'usd.png',
        name: 'Dollar',
      );
      expect(usd == usdDifferentName, isFalse);
    });

    test('props should contain [code, imgSymbol, name] in order', () {
      expect(usd.props, ['USD', 'usd.png', 'US Dollar']);
    });
  });

  group('CurrenciesResponseEntity', () {
    test('should create a CurrenciesResponseEntity instance', () {
      const res = CurrenciesResponseEntity(currencies: [usd, eur]);
      expect(res, isA<CurrenciesResponseEntity>());
    });

    test('equality: two responses with same list values are equal', () {
      const res1 = CurrenciesResponseEntity(currencies: [usd, eur]);
      const res2 = CurrenciesResponseEntity(currencies: [usd, eur]);
      expect(res1, equals(res2));
      expect(res1.hashCode, equals(res2.hashCode));
    });

    test('inequality: order or values change leads to inequality', () {
      const res1 = CurrenciesResponseEntity(currencies: [usd, eur]);
      const res2 = CurrenciesResponseEntity(currencies: [eur, usd]);
      const res3 = CurrenciesResponseEntity(currencies: [usd]);
      expect(res1 == res2, isFalse);
      expect(res1 == res3, isFalse);
    });

    test('props should contain [currencies] list', () {
      const res = CurrenciesResponseEntity(currencies: [usd, eur]);
      expect(res.props.length, 1);
      expect(res.props.first, [usd, eur]);
    });

    test('null safety: currencies can be null', () {
      const res = CurrenciesResponseEntity();
      expect(res.currencies, isNull);
      expect(res.props, [null]);
    });
  });
}
