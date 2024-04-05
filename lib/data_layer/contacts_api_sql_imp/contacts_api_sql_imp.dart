import 'dart:async';

import 'package:agenda_de_contatos/data_layer/contacts_api/contacts_api.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../contacts_api/models/contact_model.dart';
import '../contacts_api/models/contants.dart';

class ContactsApiSqlImp implements ContactsApi {
  static final ContactsApiSqlImp _instance = ContactsApiSqlImp.internal();

  factory ContactsApiSqlImp() => _instance;

  ContactsApiSqlImp.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await _initDb();
      return _db!;
    }
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'contactsnew.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY,'
        ' $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)');
  }

  @override
  Future<Contact> saveContact(Contact contact) async {
    final Database dbContact = await db;
    int id = await dbContact.insert(contactTable, contact.toMap());
    return contact.copyWith(id: id);
  }

  @override
  Future<Contact?> getContact(int id) async {
    final Database dbContact = await db;
    final List<Map> maps = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  @override
  Future<int> deleteContact(int id) async {
    final Database dbContact = await db;
    return await dbContact.delete(
      contactTable,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> updateContact(Contact contact) async {
    final Database dbContact = await db;
    return await dbContact.update(
      contactTable,
      contact.toMap(),
      where: '$idColumn = ?',
      whereArgs: [contact.id],
    );
  }

  @override
  Future<List<Contact>> getAllContacts() async {
    final Database dbContact = await db;
    final List listmap =
        await dbContact.rawQuery('SELECT * FROM $contactTable');
    List<Contact> listContact = [];
    for (Map m in listmap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  @override
  Future<int?> getNumber() async {
    final Database dbContact = await db;
    return Sqflite.firstIntValue(
      await dbContact.rawQuery('SELECT COUNT(*) FROM $contactTable'),
    );
  }

  @override
  Future<void> close() async {
    final Database dbContact = await db;
    dbContact.close();
  }
}
