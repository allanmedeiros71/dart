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
      for (Account account in listAccounts) {
        print(
          "${account.id} - ${account.name} ${account.lastName} ${account.balance}",
        );
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
    Account account = await _accountService.getAccountById(id);
    print(
      "${account.id} - ${account.name} ${account.lastName} ${account.balance}",
    );
  }

  _addAccount() async {
    print("Informe os dados da conta:");
    print("Nome: ");
    String name = stdin.readLineSync()!;
    print("Sobrenome: ");
    String lastName = stdin.readLineSync()!;
    print("Saldo: ");
    double balance = double.parse(stdin.readLineSync()!);

    // Generate ID as uuid using uuid package
    String id = Uuid().v4();

    Account account = Account(
      id: id,
      name: name,
      lastName: lastName,
      balance: balance,
    );
    await _accountService.addAccount(account);
  }

  _updateAccount() async {
    print("Informe os dados da conta:");
    print("ID: ");
    String id = stdin.readLineSync()!;
    Account oldAccount = await _accountService.getAccountById(id);

    print("Nome: (${oldAccount.name}) ");
    String name = stdin.readLineSync()!;
    print("Sobrenome: (${oldAccount.lastName}) ");
    String lastName = stdin.readLineSync()!;
    print("Saldo: (${oldAccount.balance}) ");
    double balance = double.parse(stdin.readLineSync()!);

    Account account = Account(
      id: id,
      name: name,
      lastName: lastName,
      balance: balance,
    );
    await _accountService.updateAccount(account);
  }

  _deleteAccount() async {
    print("Informe o ID da conta: ");
    String id = stdin.readLineSync()!;
    await _accountService.deleteAccount(id);
  }
}
