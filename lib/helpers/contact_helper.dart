import 'package:lista_contatos/domain/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactHelper {
  // singleton
  // construtor interno
  static final ContactHelper _instance = ContactHelper.internal();

  // Criação do factory para retornar a instância
  factory ContactHelper() => _instance;

  // contacthelp.instance
  ContactHelper.internal();

  Database _db;

  Future<Database> initDb() async {
    final databasesPath =
        await getDatabasesPath(); // Get the default databases location (iOS or Android).
    final path = join(databasesPath, "contacts.db");

    // preload you database when opened the first time
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE ${Contact.contactTable}(${Contact.idColumn} INTEGER PRIMARY KEY, "
          "                                 ${Contact.nameColumn} TEXT, "
          "                                 ${Contact.emailColumn} TEXT, "
          "                                 ${Contact.phoneColumn} TEXT, "
          "                                 ${Contact.imgColumn} TEXT) ");
    });
  }
}
