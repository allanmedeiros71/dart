import 'dart:async';
import 'dart:convert';

import 'package:assincronismo/config/env.dart';
import 'package:assincronismo/helpers/helper_taxes.dart';
import 'package:assincronismo/models/account.dart';
import 'package:assincronismo/models/transaction.dart';
import 'package:assincronismo/services/account_service.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';
import 'package:assincronismo/exceptions/index.dart';

class TransactionService {
  final AccountService _accountService = AccountService();
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;

  void _logInfo(String message) {
    _streamController.add("${DateTime.now()} | $message");
  }

  void _logError(String message) {
    _streamController.add("${DateTime.now()} | ERROR: $message");
  }

  Future<List<Transaction>> getAll() async {
    try {
      final response = await get(
        Uri.parse(Env.githubGistUrl),
        headers: {"Authorization": "Bearer ${Env.githubAuthToken}"},
      );

      if (response.statusCode != 200) {
        throw HttpException(
          'Failed to fetch transactions: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final mapResponse = json.decode(response.body);
      final listDynamic = json.decode(
        mapResponse["files"]["transactions.json"]['content'],
      );
      return [
        for (final item in listDynamic)
          Transaction.fromMap(item as Map<String, dynamic>),
      ];
    } catch (e) {
      _logError("Falha ao buscar transações: $e");
      rethrow;
    }
  }

  Future<Transaction> getTransactionById(String id) async {
    try {
      final transactions = await getAll();
      final transaction = transactions.firstWhere(
        (transaction) => transaction.id == id,
        orElse: () => throw TransactionNotFoundException(id),
      );
      return transaction;
    } catch (e) {
      _logError("Falha ao buscar transação: $e");
      rethrow;
    }
  }

  Future<List<Transaction>> getTransactionsByAccountId(String accountId) async {
    try {
      final transactions = await getAll();
      return transactions
          .where((transaction) =>
              transaction.senderAccountId == accountId ||
              transaction.receiverAccountId == accountId)
          .toList();
    } catch (e) {
      _logError("Falha ao buscar transações: $e");
      rethrow;
    }
  }

  Future<void> _save(List<Transaction> transactions) async {
    try {
      final content = json.encode([
        for (final transaction in transactions) transaction.toMap(),
      ]);

      final response = await post(
        Uri.parse(Env.githubGistUrl),
        headers: {"Authorization": "Bearer ${Env.githubAuthToken}"},
        body: json.encode({
          "description": "Alteração de transactions.json via API com Dart",
          "public": true,
          "files": {
            "transactions.json": {"content": content},
          },
        }),
      );

      if (response.statusCode < 200 || response.statusCode > 299) {
        throw HttpException(
            'Failed to save transactions: ${response.statusCode}',
            statusCode: response.statusCode);
      }

      _logInfo("Gravação bem sucedida");
    } catch (e) {
      _logError("Gravação falhou: $e");
      rethrow;
    }
  }

  Future<void> addTransaction(Transaction newTransaction) async {
    try {
      final listTransactions = await getAll();
      if (listTransactions
          .any((transaction) => transaction.id == newTransaction.id)) {
        throw StateError('Transação já existente');
      }

      listTransactions.add(newTransaction);
      await _save(listTransactions);
      _logInfo("Requisição de adição bem sucedida (${newTransaction.id})");
    } catch (e) {
      _logError("Falha ao adicionar transação ${newTransaction.id}: $e");
      rethrow;
    }
  }

  Future<void> makeTransaction(
      {required String senderAccountId,
      required String receiverAccountId,
      required double amount}) async {
    try {
      final newTransaction = Transaction(
        id: Uuid().v4(),
        senderAccountId: senderAccountId,
        receiverAccountId: receiverAccountId,
        amount: amount,
        date: DateTime.now(),
        taxes: 0,
      );

      // verify if sender and receiver accounts exist
      List<Account> listAccounts = await _accountService.getAll();

      final senderAccount = listAccounts.firstWhere(
        (account) => account.id == senderAccountId,
        orElse: () =>
            throw AccountNotFoundException('Conta de remetente não encontrada'),
      );
      final receiverAccount = listAccounts.firstWhere(
        (account) => account.id == receiverAccountId,
        orElse: () => throw AccountNotFoundException(
            'Conta de destinatário não encontrada'),
      );

      // Calculate taxes
      double tax =
          calculateTaxesByAccount(sender: senderAccount, amount: amount);
      newTransaction.taxes = tax;

      // verify if sender has enough balance
      if (senderAccount.balance < amount + tax) {
        throw InsufficientBalanceException(
          account: senderAccount,
          amount: amount,
          taxes: tax,
        );
      }

      // Create new account instances with updated balances
      final updatedSenderAccount = Account(
        id: senderAccount.id,
        name: senderAccount.name,
        lastName: senderAccount.lastName,
        balance: senderAccount.balance - (amount + tax),
        accountType: senderAccount.accountType,
      );

      final updatedReceiverAccount = Account(
        id: receiverAccount.id,
        name: receiverAccount.name,
        lastName: receiverAccount.lastName,
        balance: receiverAccount.balance + amount,
        accountType: receiverAccount.accountType,
      );

      await _accountService.updateAccount(updatedSenderAccount);
      await _accountService.updateAccount(updatedReceiverAccount);
      await addTransaction(newTransaction);
      _logInfo("Requisição de transação bem sucedida (${newTransaction.id})");
    } on ClientException catch (e) {
      _logError("Falha ao realizar transação: $e");
      rethrow;
    } on AppException catch (e) {
      _logError("Falha ao realizar transação: $e");
      rethrow;
    } catch (e) {
      _logError("Falha ao realizar transação: $e");
      rethrow;
    }
  }

  Future<String> getTransactionDetails(Transaction transaction) async {
    try {
      final listAccounts = await _accountService.getAll();

      final senderAccount = listAccounts.firstWhere(
        (account) => account.id == transaction.senderAccountId,
        orElse: () =>
            throw AccountNotFoundException('Conta de remetente não encontrada'),
      );
      final receiverAccount = listAccounts.firstWhere(
        (account) => account.id == transaction.receiverAccountId,
        orElse: () => throw AccountNotFoundException(
            'Conta de destinatário não encontrada'),
      );

      return '''
Detalhes da Transação
====================
ID: ${transaction.id}
Data: ${transaction.date.toIso8601String()}
Valor: R\$ ${transaction.amount}
Taxa: R\$ ${transaction.taxes}

Remetente:
${senderAccount.toPrintable()}

Destinatário:
${receiverAccount.toPrintable()}
''';
    } catch (e) {
      _logError("Falha ao buscar detalhes da transação: $e");
      rethrow;
    }
  }
}
