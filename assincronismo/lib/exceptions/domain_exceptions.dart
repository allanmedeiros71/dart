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
  const InsufficientBalanceException([String? message])
      : super(message ?? 'Saldo insuficiente');
}

class AccountAlreadyExistsException extends AppException {
  const AccountAlreadyExistsException([String? message])
      : super(message ?? 'Conta já existe');
}

class InvalidTransactionException extends AppException {
  const InvalidTransactionException([String? message])
      : super(message ?? 'Transação inválida');
}
