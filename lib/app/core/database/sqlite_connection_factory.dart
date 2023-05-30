import 'package:projeto_iggdrazil/app/core/database/sqlite_migration_factory.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart';


class SqliteConnectionFactory {

  static const _VERSION = 1;
  static const _DATABASE_NAME = 'TODO_LIST_PROVIDER';

  static SqliteConnectionFactory? _instance;

  Database? _db; // Controla o banco de dados (se esta aberto, fechado..)
  final _lock = Lock(); // ajuda a manter apenas 1 conexao com o bd por instancia

  SqliteConnectionFactory._(); // construtor privado

  factory SqliteConnectionFactory() {
    if (_instance == null) {
      _instance = SqliteConnectionFactory._();
    }
    return _instance!;
  }

  Future<Database> openConnection() async {
    var databasePath = await getDatabasesPath();
    var databasePathFinal = join(databasePath, _DATABASE_NAME);
      if (_db == null) {
        await _lock.synchronized(() async {
          if (_db == null) {
            _db = await openDatabase(
              databasePathFinal,
              version: _VERSION,
              onConfigure: _onConfigure,
              onCreate: _onCreate,
              onUpgrade: _onUpgrade,
              onDowngrade: _onDowngrade
            );
          }
        });
      }
    return _db!;
  }

  void closeConnection() {
    _db?.close();
    _db = null;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    final migrations = SqliteMigrationFactory().getCreateMigration();
    for (var migration in migrations) {
      migration.create(batch);
    }
    batch.commit();
  }
  Future<void> _onUpgrade(Database db, int oldversion, int version) async {
    final batch = db.batch();
    final migrations = SqliteMigrationFactory().getUpdateMigration(oldversion);
    for (var migration in migrations) {
      migration.update(batch);
    }
    batch.commit();
  }
  Future<void> _onDowngrade(Database db, int oldversion, int version) async {}

}