import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../scr/currencies/data/models/currency_model.dart';
import '../../scr/currencies/domain/entities/currency_entity.dart';

class DBHelper {
  static Database? _db;

  static const _dbName = 'currencies.db';
  static const _dbVersion = 1;

  static const table = 'currencies';
  static const colCode = 'code';
  static const colImgSymbol = 'img_symbol';
  static const colName = 'name';

  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $table (
            $colCode TEXT PRIMARY KEY,
            $colImgSymbol TEXT,
            $colName TEXT
          )
        ''');
        await db.execute('CREATE INDEX IF NOT EXISTS idx_${table}_name ON $table($colName)');
      },
    );
    return _db!;
  }

  static Future<void> upsertCurrency(CurrencyEntity model) async {
    final db = await getDatabase();
    final currencyModel = CurrencyModel(
      code: model.code,
      imgSymbol: model.imgSymbol,
      name: model.name,
    );
    await db.insert(
      table,
      currencyModel.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> upsertCurrencies(List<CurrencyEntity> list) async {
    if (list.isEmpty) return;
    final db = await getDatabase();
    final batch = db.batch();
    for (final e in list) {
      final m = CurrencyModel(code: e.code, imgSymbol: e.imgSymbol, name: e.name);
      batch.insert(
        table,
        m.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
  static Future<void> clearCurrencies() async {
    final db = await getDatabase();
    await db.delete(table);
  }
  static Future<List<CurrencyModel>> getAllCurrencies() async {
    final db = await getDatabase();
    final rows = await db.query(table, orderBy: '$colCode ASC');
    return rows.map((r) => CurrencyModel.fromDbMap(r)).toList();
  }

  static Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
