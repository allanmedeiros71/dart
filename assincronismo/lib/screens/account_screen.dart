import 'dart:io';

import 'package:http/http.dart';
import 'package:uuid/uuid.dart';
import 'package:assincronismo/models/account.dart';
import 'package:assincronismo/services/account_service.dart';
import 'package:assincronismo/services/transaction_service.dart';

/// Screen responsible for handling user interactions with accounts
class AccountScreen {
  final AccountService _accountService = AccountService();
  final TransactionService _transactionService = TransactionService();
  static const _menuOptions = {
    "1": "Ver todas as contas",
    "2": "Listar uma conta por ID",
    "3": "Adicionar uma conta",
    "4": "Atualizar uma conta",
    "5": "Remover uma conta",
    "6": "Ver todas as transações",
    "7": "Ver as transações de uma conta",
    "8": "Ver uma transação por ID",
    "9": "Criar uma transferência",
    "0": "Sair",
  };

  void initializeStream() {
    _accountService.streamInfos.listen(
      (info) => print(info),
      onError: (error) => print("Erro no stream: $error"),
    );
  }

  void runChatbot() async {
    _printWelcomeMessage();

    bool isRunning = true;
    while (isRunning) {
      _printMenu();
      final option = _readInput("").trim();

      try {
        switch (option) {
          case "1":
            await _printAllAccounts();
          case "2":
            await _printAccountById();
          case "3":
            await _addAccount();
          case "4":
            await _updateAccount();
          case "5":
            await _deleteAccount();
          case "6":
            await _printAllTransactions();
          case "7":
            await _printTransactionsByAccountId();
          case "8":
            await _printTransactionById();
          case "9":
            await _makeTransaction();
          case "0":
            isRunning = false;
            print("\nObrigado por usar o Allbot, até mais!");
          default:
            print("\nOpção inválida! Por favor, escolha uma opção válida.\n");
        }
      } catch (e) {
        print("\nOcorreu um erro inesperado: $e\n");
      }
    }
  }

  void _printWelcomeMessage() {
    print("\nBom dia, eu sou o Allbot, seu assistente virtual");
    print("Que bom ter você por aqui\n");
  }

  void _printMenu() {
    print("Como eu posso ajudar você hoje? (Digite o número desejado)");
    for (final entry in _menuOptions.entries) {
      print("${entry.key} - ${entry.value}");
    }
    print("");
  }

  String _readInput(String prompt, {bool required = true}) {
    if (prompt.isNotEmpty) {
      print(prompt);
    }
    final input = stdin.readLineSync()?.trim() ?? "";
    if (required && input.isEmpty) {
      throw FormatException("O campo não pode estar vazio");
    }
    return input;
  }

  double _parseBalance(String value) {
    try {
      final balance = double.parse(value);
      if (balance.isNegative) {
        throw FormatException("O saldo não pode ser negativo");
      }
      return balance;
    } on FormatException {
      throw FormatException("O saldo deve ser um número válido");
    }
  }

  AccountType _parseAccountType(String value) {
    try {
      final index = int.parse(value);
      if (index < 1 || index > AccountType.values.length) {
        throw FormatException(
          "Tipo de conta inválido. Escolha um número entre 1 e ${AccountType.values.length}",
        );
      }
      return AccountType.values[index - 1];
    } on FormatException {
      throw FormatException("O tipo de conta deve ser um número válido");
    }
  }

  Future<void> _printAllAccounts() async {
    try {
      final accounts = await _accountService.getAll();
      print("\nListagem de contas");
      print("==================");
      for (final account in accounts) {
        print(account.toPrintable());
      }
      print("");
    } on ClientException catch (e) {
      print("\nNão foi possível conectar ao servidor");
      print("Tente novamente mais tarde");
      print("Erro: ${e.message}");
      if (e.uri != null) print("URI: ${e.uri}");
    } on Exception catch (e) {
      print("\nNão foi possível listar as contas");
      print("Tente novamente mais tarde");
      print("Erro: $e");
    }
  }

  Future<void> _printAccountById() async {
    try {
      final id = _readInput("Informe o ID da conta:");
      final account = await _accountService.getAccountById(id);

      print("\nDetalhes da conta");
      print("================");
      print("${account.toPrintable()}\n");
    } on AccountNotFoundException catch (e) {
      print("\n$e\n");
    } catch (e) {
      print("\nNão foi possível buscar a conta");
      print("Erro: $e\n");
    }
  }

  Future<void> _addAccount() async {
    try {
      print("\nInforme os dados da conta:");
      final name = _readInput("Nome:");
      final lastName = _readInput("Sobrenome:");
      final balance = _parseBalance(_readInput("Saldo:"));

      print("\nTipo de conta:");
      print("1 - Ambrosia, 2 - Canjica, 3 - Pudim, 4 - Brigadeiro");
      final accountType = _parseAccountType(_readInput(""));

      final account = Account(
        id: Uuid().v4(),
        name: name,
        lastName: lastName,
        balance: balance,
        accountType: accountType,
      );

      await _accountService.addAccount(account);
      print("\nConta adicionada com sucesso!");
      print("Id: ${account.id}\n");
    } catch (e) {
      print("\nErro ao adicionar conta: $e\n");
    }
  }

  Future<void> _updateAccount() async {
    try {
      print("\nInforme os novos dados da conta:");
      print("Deixe em branco para manter o valor atual");

      final id = _readInput("ID:", required: true);
      final oldAccount = await _accountService.getAccountById(id);

      final name = _readInput("\nNome: (${oldAccount.name})", required: false);
      final lastName = _readInput(
        "Sobrenome: (${oldAccount.lastName})",
        required: false,
      );
      final balanceStr = _readInput(
        "Saldo: (${oldAccount.balance})",
        required: false,
      );

      print("\nTipo de conta atual: ${oldAccount.accountType?.name}");
      print("1 - Ambrosia, 2 - Canjica, 3 - Pudim, 4 - Brigadeiro");
      final accountTypeStr = _readInput("", required: false);

      final account = Account(
        id: id,
        name: name.isEmpty ? oldAccount.name : name,
        lastName: lastName.isEmpty ? oldAccount.lastName : lastName,
        balance:
            balanceStr.isEmpty ? oldAccount.balance : _parseBalance(balanceStr),
        accountType: accountTypeStr.isEmpty
            ? oldAccount.accountType
            : _parseAccountType(accountTypeStr),
      );

      await _accountService.updateAccount(account);
      print("\nConta atualizada com sucesso!\n");
    } on AccountNotFoundException catch (e) {
      print("\n$e\n");
    } catch (e) {
      print("\nNão foi possível atualizar a conta");
      print("Erro: $e\n");
    }
  }

  Future<void> _deleteAccount() async {
    try {
      final id = _readInput("Informe o ID da conta:");
      await _accountService.deleteAccount(id);
      print("\nConta deletada com sucesso!\n");
    } on AccountNotFoundException catch (e) {
      print("\nErro: $e\n");
    } catch (e) {
      print("\nErro ao deletar conta: $e\n");
    }
  }

  Future<void> _printAllTransactions() async {
    try {
      final transactions = await _transactionService.getAll();
      print("\nListagem de transações");
      print("==================");
      for (final transaction in transactions) {
        print(transaction.toPrintable());
        print("==================\n");
      }
    } on ClientException catch (e) {
      print("\nNão foi possível conectar ao servidor");
      print("Tente novamente mais tarde");
      print("Erro: ${e.message}");
      if (e.uri != null) print("URI: ${e.uri}");
    } on Exception catch (e) {
      print("\nNão foi possível listar as transações");
      print("Tente novamente mais tarde");
      print("Erro: $e\n");
    }
  }

  Future<void> _printTransactionsByAccountId() async {
    try {
      final id = _readInput("Informe o ID da conta:");
      final transactions =
          await _transactionService.getTransactionsByAccountId(id);
      print("\nTransações da conta $id");
      print("==================");
      for (final transaction in transactions) {
        print(transaction.toPrintable());
        print("==================\n");
      }
    } on ClientException catch (e) {
      print("\nNão foi possível conectar ao servidor");
      print("Tente novamente mais tarde");
      print("Erro: ${e.message}");
      if (e.uri != null) print("URI: ${e.uri}");
    } on Exception catch (e) {
      print("\nNão foi possível listar as transações");
      print("Tente novamente mais tarde");
      print("Erro: $e\n");
    }
  }

  Future<void> _printTransactionById() async {
    try {
      final id = _readInput("Informe o ID da transação:");
      final transaction = await _transactionService.getTransactionById(id);
      print("\nDetalhes da transação");
      print("================");
      print(await _transactionService.getTransactionDetails(transaction));
      print("\n");
    } on TransactionNotFoundException catch (e) {
      print("\n$e\n");
    } catch (e) {
      print("\nNão foi possível buscar a transação");
      print("Tente novamente mais tarde");
      print("Erro: $e\n");
    }
  }

  Future<void> _makeTransaction() async {
    try {
      print("\nInforme os dados da transação:");
      final senderAccountId = _readInput("ID da conta de remetente:");
      final receiverAccountId = _readInput("ID da conta de destinatário:");
      final amount = _parseBalance(_readInput("Valor:"));

      await _transactionService.makeTransaction(
        senderAccountId: senderAccountId,
        receiverAccountId: receiverAccountId,
        amount: amount,
      );
      print("\nTransação realizada com sucesso!\n");
    } on ClientException catch (e) {
      print("\nNão foi possível conectar ao servidor");
      print("Tente novamente mais tarde");
      print("Erro: ${e.message}");
      if (e.uri != null) print("URI: ${e.uri}");
    } on Exception catch (e) {
      print("\nNão foi possível realizar a transação");
      print("Tente novamente mais tarde");
      print("Erro: $e\n");
    }
  }
}
