import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dao/contact_dao.dart';

Future<Database> getDatabase() async {
  String dbPath = await getDatabasesPath();
  String path = join(dbPath, 'bytebank.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(ContactDao.CREATE_SQL);
    },
    version: 1,
  );
}
