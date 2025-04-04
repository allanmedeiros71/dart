import 'dart:io';

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
      print("2 - Adicionar uma conta");
      print("3 - Sair\n");

      String leitura = stdin.readLineSync()!;
      switch (leitura) {
        case "1":
          await _getAllAccounts();
          break;
        case "2":
          await _addExampleAccount();
          break;
        case "3":
          isRunning = false;
          print("Obrigado por usar o Allbot, até mais!");
          break;
        default:
          print("Opção inválida");
      }
    }
  }

  _getAllAccounts() async {
    List<Account> listAccounts = await _accountService.getAll();
    for (Account account in listAccounts) {
      print(
        "${account.id} - ${account.name} ${account.lastName} ${account.balance}",
      );
    }
  }

  _addExampleAccount() async {
    Account account = Account(
      id: "ID666",
      name: "Halley",
      lastName: "Commet",
      balance: 1000,
    );
    await _accountService.addAccount(account);
  }
}
