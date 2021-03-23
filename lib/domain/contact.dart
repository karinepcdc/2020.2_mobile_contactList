Class Contact {
  /// define uma tabela no banco de dados sql para armazernar contatos
  static final String contactTable = "contactTable";
  static final String idColumn = "idColumn";
  static final String nameColumn = "nameColumn";
  static final String phoneColumn = "phoneColumn";
  static final String emailColumn = "emailColumn";
  static final String imgColumn = "imgColumn";

  
  int id; // id unico para registro no banco de dados
  String name;
  String email;
  String phone;
  String img;

  // Default constructor
  Contact();

  // Construtor que instacia classe a partir de um mapa
  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  };

  // Gera um mapa apartir do objeto contact
  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if(id != null) map[idColumn] = id;

    return map;
  }

  @override
  String toString() {
    return "Contact(id: ${id}, name: ${name}, email: ${email}, phone: ${phone}, img: ${img})";
  }
}