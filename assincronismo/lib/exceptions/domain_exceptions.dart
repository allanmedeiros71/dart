import 'package:assincronismo/models/account.dart';

import 'base_exception.dart';

class AccountNotFoundException extends AppException {
  const AccountNotFoundException([String? message])
      : super(message ?? 'Conta não encontrada');
}

class TransactionNotFoundException extends AppException {
  const TransactionNotFoundException([String? message])
      : super(message ?? 'Transação não encontrada');
}

class InsufficientBalanceException extends AppException {
  final Account? account;
  final double? amount;
  final double? taxes;
  final double? requiredBalance;

  InsufficientBalanceException({
    String? message,
    required this.account,
    required this.amount,
    required this.taxes,
  })  : requiredBalance = amount! + taxes!,
        super(message ?? 'Saldo insuficiente');

  @override
  String toString() {
    return '''
InsufficientBalanceException: $message
Detalhes:
  Conta: ${account?.id}
  Cliente:  ${account?.lastName.toUpperCase()}, ${account?.name}
  Saldo atual: R\$ ${account?.balance}
  Valor da transação: R\$ $amount
  Taxa: R\$ $taxes
  Saldo necessário: R\$ $requiredBalance
''';
  }
}

class AccountAlreadyExistsException extends AppException {
  const AccountAlreadyExistsException([String? message])
      : super(message ?? 'Conta já existe');
}

class InvalidTransactionException extends AppException {
  const InvalidTransactionException([String? message])
      : super(message ?? 'Transação inválida');
}
