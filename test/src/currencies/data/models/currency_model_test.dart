import 'package:flutter_test/flutter_test.dart';
import 'package:x_transfer/scr/currencies/data/models/currency_model.dart';
import 'package:x_transfer/scr/currencies/domain/entities/currency_entity.dart';

void main() {
  group('getImgSymbol', () {
    test('returns first two letters lowercased when length >= 2', () {
      expect(getImgSymbol('USD'), 'us');
      expect(getImgSymbol('EgP'), 'eg');
    });

    test('returns whole string lowercased when length < 2', () {
      expect(getImgSymbol('J'), 'j');
      expect(getImgSymbol(''), '');
    });
  });

  group('CurrencyModel.fromMap', () {
    test('uses codeOverride when provided (non-empty)', () {
      final Map<String, dynamic> map = <String, dynamic>{
        'code': 'USD',
        'name': 'US Dollar',
      };
      final model = CurrencyModel.fromMap(map, codeOverride: 'EGP');

      expect(model, isA<CurrencyModel>());
      expect(model.code, 'EGP');
      expect(model.imgSymbol, 'eg');
      expect(model.name, 'US Dollar');
    });

    test('falls back to map["code"] when codeOverride is empty', () {
      final Map<String, dynamic> map = <String, dynamic>{
        'code': 'USD',
        'name': 'US Dollar',
      };
      final model = CurrencyModel.fromMap(map, codeOverride: '');

      expect(model.code, 'USD');
      expect(model.imgSymbol, 'us');
      expect(model.name, 'US Dollar');
    });

    test('toString returns a String', () {
      const model =
      CurrencyModel(code: 'USD', imgSymbol: 'us', name: 'US Dollar');
      expect(model.toString(), isA<String>());
    });

    test('equatable: two models with same values are equal', () {
      const a =
      CurrencyModel(code: 'USD', imgSymbol: 'us', name: 'US Dollar');
      const b =
      CurrencyModel(code: 'USD', imgSymbol: 'us', name: 'US Dollar');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equatable: different field -> not equal', () {
      const a =
      CurrencyModel(code: 'USD', imgSymbol: 'us', name: 'US Dollar');
      const b =
      CurrencyModel(code: 'USD', imgSymbol: 'us', name: 'Dollar');
      expect(a == b, isFalse);
    });
  });

  group('CurrencyModel DB mapping', () {
    test('toDbMap produces expected map', () {
      const model =
      CurrencyModel(code: 'USD', imgSymbol: 'us', name: 'US Dollar');
      expect(model.toDbMap(), {
        'code': 'USD',
        'img_symbol': 'us',
        'name': 'US Dollar',
      });
    });

    test('fromDbMap parses DB map correctly', () {
      final Map<String, dynamic> db = <String, dynamic>{
        'code': 'EUR',
        'img_symbol': 'eu',
        'name': 'Euro',
      };
      final model = CurrencyModel.fromDbMap(db);
      expect(model.code, 'EUR');
      expect(model.imgSymbol, 'eu');
      expect(model.name, 'Euro');
    });

    test('round-trip toDbMap -> fromDbMap preserves values', () {
      const original =
      CurrencyModel(code: 'EGP', imgSymbol: 'eg', name: 'Egyptian Pound');
      final roundTripped = CurrencyModel.fromDbMap(original.toDbMap());
      expect(roundTripped, equals(original));
    });
  });

  group('CurrenciesResponseModel.fromJson', () {
    test('maps JSON data using map keys as currency codes', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'data': <String, dynamic>{
          'USD': <String, dynamic>{'name': 'US Dollar'},
          'EGP': <String, dynamic>{'code': 'EGP', 'name': 'Egyptian Pound'},
        },
      };

      final result = CurrenciesResponseModel.fromJson(json);

      expect(result, isA<CurrenciesResponseModel>());
      expect(result.currencies, isNotNull);
      expect(result.currencies!.length, 2);

      final usd = result.currencies![0] as CurrencyModel;
      final egp = result.currencies![1] as CurrencyModel;

      expect(usd.code, 'USD');
      expect(usd.imgSymbol, 'us');
      expect(usd.name, 'US Dollar');

      expect(egp.code, 'EGP');
      expect(egp.imgSymbol, 'eg');
      expect(egp.name, 'Egyptian Pound');
    });

    test('handles empty "data" map', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'data': <String, dynamic>{},
      };
      final result = CurrenciesResponseModel.fromJson(json);

      expect(result.currencies, isA<List<CurrencyEntity>>());
      expect(result.currencies, isEmpty);
    });

    test('equatable: responses with same currencies are equal', () {
      const a = CurrenciesResponseModel(
        currencies: [
          CurrencyModel(code: 'USD', imgSymbol: 'us', name: 'US Dollar')
        ],
      );
      const b = CurrenciesResponseModel(
        currencies: [
          CurrencyModel(code: 'USD', imgSymbol: 'us', name: 'US Dollar')
        ],
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('props contains the currencies list', () {
      const res = CurrenciesResponseModel(
        currencies: [
          CurrencyModel(code: 'USD', imgSymbol: 'us', name: 'US Dollar')
        ],
      );
      expect(res.props.length, 1);
      expect(res.props.first, isA<List<CurrencyEntity>>());
    });
  });
}
