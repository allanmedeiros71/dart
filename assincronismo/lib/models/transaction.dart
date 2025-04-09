import 'dart:convert';

class Transaction {
  String id;
  String senderAccountId;
  String receiverAccountId;
  DateTime date;
  double amount;
  double taxes;

  Transaction({
    required this.id,
    required this.senderAccountId,
    required this.receiverAccountId,
    required this.date,
    required this.amount,
    required this.taxes,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map["id"],
      senderAccountId: map["senderAccountId"],
      receiverAccountId: map["receiverAccountId"],
      date: DateTime.parse(map["date"]),
      amount: map["amount"],
      taxes: map["taxes"],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "senderAccountId": senderAccountId,
      "receiverAccountId": receiverAccountId,
      "date": date.toIso8601String(),
      "amount": amount,
      "taxes": taxes,
    };
  }

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Transaction(id: $id, senderAccountId: $senderAccountId, receiverAccountId: $receiverAccountId, date: $date, amount: $amount, taxes: $taxes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, other)) return true;

    return other is Transaction &&
        other.id == id &&
        other.senderAccountId == senderAccountId &&
        other.receiverAccountId == receiverAccountId &&
        other.date == date &&
        other.amount == amount &&
        other.taxes == taxes;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  Transaction copyWith({
    String? id,
    String? senderAccountId,
    String? receiverAccountId,
    DateTime? date,
    double? amount,
    double? taxes,
  }) {
    return Transaction(
      id: id ?? this.id,
      senderAccountId: senderAccountId ?? this.senderAccountId,
      receiverAccountId: receiverAccountId ?? this.receiverAccountId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      taxes: taxes ?? this.taxes,
    );
  }
}
