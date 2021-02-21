import 'package:sqflite/sqflite.dart';

import '../../models/contact.dart';
import '../app_database.dart';

class ContactDao {
  static const String _tableName = 'contacts';
  static const String _idField = 'id';
  static const String _nameField = 'name';
  static const String _accountNumberField = 'account_number';

  static const String CREATE_SQL = 'CREATE TABLE $_tableName ( '
      ' $_idField PRIMARY KEY, '
      ' $_nameField TEXT, '
      ' $_accountNumberField INTEGER )';

  Future<int> save(Contact contact) async {
    Database db = await getDatabase();
    return db.insert(_tableName, _toMap(contact));
  }

  Future<List<Contact>> findAll() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result = await db.query(_tableName);

    return result.map<Contact>((contact) => _toList(contact)).toList();
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> result = Map();
    result[_nameField] = contact.name;
    result[_accountNumberField] = contact.accountNumber;

    return result;
  }

  Contact _toList(Map<String, dynamic> contact) {
    return Contact(
      id: 0,
      name: contact[_nameField],
      accountNumber: contact[_accountNumberField],
    );
  }
}
