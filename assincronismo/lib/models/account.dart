import 'dart:convert';

class Account {
  String id;
  String name;
  String lastName;
  double balance;

  // Construtor
  Account({
    required this.id,
    required this.name,
    required this.lastName,
    required this.balance,
  });

  // Construtor especial que recebe um map ao invés dos parâmetros individualmente
  // O uso do factoru permite criar um construtor baseado em outro. No caso, Account()
  // Recebe um map e...
  factory Account.fromMap(Map<String, dynamic> map) {
    // Chama o construtor principal 'desmenmbrando' o map
    return Account(
      id: map["id"],
      name: map["name"],
      lastName: map["lastName"],
      balance: map["balance"],
    );
  }

  // Neste caso temos um construtor especial que
  // recebe um json, converte para Map e chama o costrutor fromMap
  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  // Método que converte o objeto Account em um map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "lastName": lastName,
      "balance": balance,
    };
  }

  // Método toJson que usa o método toMap para converter o Map em Json e retornar
  String toJson() => json.encode(toMap());
}
