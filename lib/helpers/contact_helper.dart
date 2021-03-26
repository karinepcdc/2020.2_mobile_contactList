import 'package:lista_contatos/domain/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactHelper {
  // instancia do construtor padrão
  static final ContactHelper _instance = ContactHelper.internal();

  // construtor singleton utilizando um construtor factory
  // construtor factory: cria uma nova instancia ou retorna a existente,
  // caso já tenha sido inicializada (recupera essa instancia de um cache)
  // Note que a pessoa que instancia essa classe nem fica sabendo que é um
  // singleton, pois chama apenas ContactHelper()
  factory ContactHelper() => _instance;

  // construtor interno
  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    // garante que o database existe antes de retorná-lo
    if (_db == null) await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath =
        await getDatabasesPath(); // Get the default databases location (iOS or Android).
    final path = join(databasesPath, "contacts.db");

    // preload you database when opened the first time
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE ${Contact.contactTable} (${Contact.idColumn}    INTEGER PRIMARY KEY, "
          "                                      ${Contact.nameColumn}  TEXT, "
          "                                      ${Contact.emailColumn} TEXT, "
          "                                      ${Contact.phoneColumn} TEXT, "
          "                                      ${Contact.imgColumn}   TEXT) ");
    });
  }

  Future<Contact> saveContact(Contact c) async {
    Database dbContact = await db;
    c.id = await dbContact.insert(Contact.contactTable, c.toMap());
    return c;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(Contact.contactTable,
        columns: [
          Contact.idColumn,
          Contact.nameColumn,
          Contact.emailColumn,
          Contact.phoneColumn,
          Contact.imgColumn
        ],
        where: "${Contact.idColumn} = ?",
        whereArgs: [id]);

    if (maps.length > 0)
      return Contact.fromMap(maps.first);
    else
      return null;
  }

  // return the number of changes made
  Future<int> updateContact(Contact c) async {
    Database dbContact = await db;
    return await dbContact.update(Contact.contactTable, c.toMap(),
        where: "${Contact.idColumn} = ?", whereArgs: [c.id]);
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(Contact.contactTable,
        where: '{Contact.idColumn} = ?', whereArgs: [id]);
  }

  Future<List> getAllContact() async {
    Database dbContact = await db;
    List<Contact> listContact = [];
    List listMap = await dbContact.query(Contact.contactTable);

    for (Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  // Return number of contacts registered???
  Future<int> getNumber() async {
    Database dbContact = await db;
    int count = Sqflite.firstIntValue(await dbContact
        .rawQuery('SELECT COUNT(*) FROM ${Contact.contactTable}'));
    return count;
  }

  Future close() async {
    Database dbContact = await db;
    await dbContact.close();
  }
}
