import 'package:projeto_iggdrazil/app/core/database/migration/migration_v2.dart';
import 'package:sqflite/sqflite.dart';
import 'migration/migration.dart';
import 'migration/migration_v1.dart';
import 'migration/migration_v3.dart';


class SqliteMigrationFactory {
  List<Migration> getCreateMigration() => [
    MigrationV1(),
    MigrationV2(),
    MigrationV3()
  ];
  List<Migration> getUpdateMigration(int version) {
    final migrations = <Migration>[];
    // atual = 3
    // version 1
    if (version == 1) {
      migrations.add(MigrationV2());
      migrations.add(MigrationV3());
    }

    // version 2
    if (version == 2) {
      migrations.add(MigrationV3());
    }
    return migrations;
  }

}
