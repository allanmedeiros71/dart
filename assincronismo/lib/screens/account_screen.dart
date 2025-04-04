import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:assincronismo/models/account.dart';
import 'package:assincronismo/services/account_service.dart';
import 'package:meta/meta.dart';

class AccountScreen {
  final AccountService accountService;

  AccountScreen({AccountService? accountService})
    : accountService = accountService ?? AccountService();

  void initializeStream() {
    accountService.streamInfos.listen((info) {
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
          await getAllAccounts();
          break;
        case "2":
          await getAccountById();
          break;
        case "3":
          await addAccount();
          break;
        case "4":
          await updateAccount();
          break;
        case "5":
          await deleteAccount();
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

  @visibleForTesting
  Future<void> getAllAccounts() async {
    List<Account> listAccounts = await accountService.getAll();
    for (Account account in listAccounts) {
      print(
        "${account.id} - ${account.name} ${account.lastName} ${account.balance}",
      );
    }
  }

  @visibleForTesting
  Future<void> getAccountById() async {
    print("Informe o ID da conta: ");
    String id = stdin.readLineSync()!;
    Account account = await accountService.getAccountById(id);
    print(
      "${account.id} - ${account.name} ${account.lastName} ${account.balance}",
    );
  }

  @visibleForTesting
  Future<void> addAccount() async {
    print("Informe os dados da conta:");
    print("Nome: ");
    String name = stdin.readLineSync()!;
    print("Sobrenome: ");
    String lastName = stdin.readLineSync()!;
    print("Saldo: ");
    double balance = double.parse(stdin.readLineSync()!);

    Account account = Account(
      id: const Uuid().v4(),
      name: name,
      lastName: lastName,
      balance: balance,
    );
    await accountService.addAccount(account);
  }

  @visibleForTesting
  Future<void> updateAccount() async {
    print("Informe os dados da conta:");
    print("ID: ");
    String id = stdin.readLineSync()!;
    Account oldAccount = await accountService.getAccountById(id);

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
    await accountService.updateAccount(account);
  }

  @visibleForTesting
  Future<void> deleteAccount() async {
    print("Informe o ID da conta: ");
    String id = stdin.readLineSync()!;
    await accountService.deleteAccount(id);
  }
}
