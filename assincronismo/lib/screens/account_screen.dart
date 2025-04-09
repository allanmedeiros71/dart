import 'dart:io';

import 'package:http/http.dart';
import 'package:uuid/uuid.dart';
import 'package:assincronismo/models/account.dart';
import 'package:assincronismo/services/account_service.dart';

class AccountScreen {
  final AccountService _accountService = AccountService();

  void initializeStream() {
    _accountService.streamInfos.listen((info) {
      print(info);
    });
  }

  void runChatbot() async {
    print("Bom dia, eu sou o Allbot, seu assistente virtual");
    print("Que bom ter você por aqui\n");

    bool isRunning = true;
    while (isRunning) {
      print("Como eu posso ajudar você hoje? (Digite o número desejado)");
      print("1 - Ver todas as contas");
      print("2 - Listar uma conta por ID");
      print("3 - Adicionar uma conta");
      print("4 - Atualizar uma conta");
      print("5 - Remover uma conta");
      print("6 - Sair\n");

      String leitura = stdin.readLineSync()!;
      switch (leitura) {
        case "1":
          await _getAllAccounts();
          break;
        case "2":
          await _getAccountById();
          break;
        case "3":
          await _addAccount();
          break;
        case "4":
          await _updateAccount();
          break;
        case "5":
          await _deleteAccount();
          break;
        case "6":
          isRunning = false;
          print("Obrigado por usar o Allbot, até mais!");
          break;
        default:
          print("Opção inválida");
      }
    }
  }

  _getAllAccounts() async {
    try {
      List<Account> listAccounts = await _accountService.getAll();
      print("Listagem de contas");
      print("==================");
      for (Account account in listAccounts) {
        print(account.toPrintable());
      }
    } on ClientException catch (e) {
      print("Não foi possível conectar ao servidor");
      print("Tente novamente mais tarde");
      print(e.toString());
      print(e.uri);
    } on Exception catch (e) {
      print("Não foi possível listar as contas");
      print("Tente novamente mais tarde");
      print(e.toString());
    } finally {
      print("${DateTime.now()} | Ocorreu uma tentativa de consulta");
    }
  }

  _getAccountById() async {
    print("Informe o ID da conta: ");
    String id = stdin.readLineSync()!;
    if (id.isEmpty) {
      print("ID é obrigatório");
      return;
    }
    try {
      Account account = await _accountService.getAccountById(id);
      print("Detalhes da conta");
      print("================");
      print(account.toPrintable());
    } on AccountNotFoundException catch (e) {
      print(e.toString());
    } catch (e) {
      print("Não foi possível buscar a conta");
      print(e.toString());
    } finally {
      print("${DateTime.now()} | Ocorreu uma tentativa de busca");
    }
  }

  _addAccount() async {
    try {
      print("Informe os dados da conta:");
      print("Nome: ");
      String? name = stdin.readLineSync();
      if (name == null || name.trim().isEmpty) {
        throw FormatException("Nome não pode estar em branco");
      }

      print("Sobrenome: ");
      String? lastName = stdin.readLineSync();
      if (lastName == null || lastName.trim().isEmpty) {
        throw FormatException("Sobrenome não pode estar em branco");
      }

      print("Saldo: ");
      String? balanceStr = stdin.readLineSync();
      if (balanceStr == null || balanceStr.trim().isEmpty) {
        throw FormatException("Saldo não pode estar em branco");
      }

      double balance;
      try {
        balance = double.parse(balanceStr);
      } catch (e) {
        throw FormatException("Saldo deve ser um número válido");
      }

      print(
        "Tipo de conta: (1 - ambrosia, 2 - canjica, 3 - pudim, 4 - brigadeiro",
      );
      String? accountType = stdin.readLineSync();
      if (accountType == null || accountType.trim().isEmpty) {
        throw FormatException("Tipo de conta não pode estar em branco");
      }
      int accountTypeIndex = int.parse(accountType);
      if (accountTypeIndex < 1 || accountTypeIndex > 4) {
        throw FormatException("Tipo de conta deve ser entre 1 e 4");
      }
      AccountType accountTypeEnum = AccountType.values[accountTypeIndex - 1];

      // Generate ID as uuid using uuid package
      String id = Uuid().v4();

      Account account = Account(
        id: id,
        name: name,
        lastName: lastName,
        balance: balance,
        accountType: accountTypeEnum,
      );
      await _accountService.addAccount(account);
      print("Conta adicionada com sucesso");
      print("Id: ${account.id}");
    } catch (e) {
      print("Erro ao adicionar conta: ${e.toString()}");
    }
  }

  _updateAccount() async {
    print("Informe os novos dados da conta:");
    print("Deixe em branco para manter o valor atual");
    print("ID: ");
    String id = stdin.readLineSync()!.trim();
    if (id.isEmpty) {
      print("ID é obrigatório");
      return;
    }
    try {
      Account oldAccount = await _accountService.getAccountById(id);

      print("Nome: (${oldAccount.name}) ");
      String name = stdin.readLineSync()!.trim();
      if (name.isEmpty) {
        name = oldAccount.name;
      }

      print("Sobrenome: (${oldAccount.lastName})");
      String lastName = stdin.readLineSync()!.trim();
      if (lastName.isEmpty) {
        lastName = oldAccount.lastName;
      }

      print("Saldo: (${oldAccount.balance})");
      String balanceStr = stdin.readLineSync()!.trim();
      double balance;
      if (balanceStr.isEmpty) {
        balance = oldAccount.balance;
      } else {
        try {
          balance = double.parse(balanceStr);
          if (balance.isNegative) {
            print("O saldo não pode ser negativo");
            return;
          }
        } catch (e) {
          print("Erro: O saldo deve ser um número válido");
          return;
        }
      }

      print("Tipo de conta: (${oldAccount.accountType.name}) ");
      print("(1 - Ambrosia, 2 - Canjica, 3 - Pudim, 4 - Brigadeiro)");
      String accountTypeIndex = stdin.readLineSync()!.trim();
      AccountType accountTypeEnum;

      if (accountTypeIndex.isEmpty) {
        accountTypeEnum = oldAccount.accountType;
      } else {
        try {
          int typeIndex = int.parse(accountTypeIndex);
          if (typeIndex < 1 || typeIndex > AccountType.values.length) {
            print(
              "Erro: Tipo de conta inválido. Escolha um número entre 1 e ${AccountType.values.length}",
            );
            return;
          }
          accountTypeEnum = AccountType.values[typeIndex - 1];
        } catch (e) {
          print("Erro: O tipo de conta deve ser um número válido");
          return;
        }
      }

      Account account = Account(
        id: id,
        name: name,
        lastName: lastName,
        balance: balance,
        accountType: accountTypeEnum,
      );
      await _accountService.updateAccount(account);
      print("Conta atualizada com sucesso!");
    } on AccountNotFoundException catch (e) {
      print(e.toString());
    } catch (e) {
      print("Não foi possível atualizar a conta");
      print(e.toString());
    } finally {
      print("${DateTime.now()} | Ocorreu uma tentativa de atualização");
    }
  }

  _deleteAccount() async {
    print("Informe o ID da conta: ");
    String id = stdin.readLineSync()!;
    if (id.isEmpty) {
      print("ID é obrigatório");
      return;
    }

    try {
      // Verify if account exists before deletion
      List<Account> accounts = await _accountService.getAll();
      bool accountExists = accounts.any((account) => account.id == id);

      if (!accountExists) {
        throw AccountNotFoundException("Conta não encontrada com o ID: $id");
      }

      await _accountService.deleteAccount(id);
      print("Conta deletada com sucesso!");
    } on AccountNotFoundException catch (e) {
      print("Erro: ${e.toString()}");
    } catch (e) {
      print("Erro ao deletar conta: $e");
    }
  }
}
