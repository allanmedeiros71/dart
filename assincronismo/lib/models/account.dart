import 'dart:convert';

// Create enum for account types
enum AccountType {
  ambrosia("Ambrosia", 0.5),
  canjica("Canjica", 0.33),
  pudim("Pudim", 0.25),
  brigadeiro("Brigadeiro", 0.01);

  const AccountType(this.name, this.tax);
  final String name;
  final double tax;
}

class Account {
  String id;
  String name;
  String lastName;
  double balance;
  AccountType accountType;

  // Construtor
  Account({
    required this.id,
    required this.name,
    required this.lastName,
    required this.balance,
    required this.accountType,
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
      accountType: AccountType.values.firstWhere(
        (type) => type.name == map["accountType"],
      ),
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
      "accountType": accountType.name,
    };
  }

  // Método toJson que usa o método toMap para converter o Map em Json e retornar
  String toJson() => json.encode(toMap());

  // Método toString() que retorna uma String que representa o objeto
  @override
  String toString() {
    return 'Account(id: $id, name: $name, lastName: $lastName, balance: $balance, accountType: ${accountType.name} (Taxa: ${accountType.tax}%)';
  }

  String toPrintable() {
    return 'Account id: $id, Cliente: ${lastName.toUpperCase()}, $name. Detalhes da Conta: Saldo: R\$ $balance, Tipo: ${accountType.name} (Taxa: ${accountType.tax}%)';
  }

  // Método equals() que compara dois objetos Account
  @override
  bool operator ==(Object other) {
    if (identical(other, other)) return true;

    return other is Account &&
        other.id == id &&
        other.name == name &&
        other.lastName == lastName &&
        other.balance == balance &&
        other.accountType == accountType;
  }

  // Método hashCode() que retorna um int que representa o objeto
  @override
  int get hashCode {
    return id.hashCode;
  }

  // Método copyWith() que retorna uma nova instância de Account
  Account copyWith({
    String? id,
    String? name,
    String? lastName,
    double? balance,
    AccountType? accountType,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      balance: balance ?? this.balance,
      accountType: accountType ?? this.accountType,
    );
  }
}
