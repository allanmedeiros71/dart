import 'dart:async';

import 'package:assincronismo/env.dart';
import 'package:assincronismo/models/account.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;
  String url = "https://api.github.com/gists/65e7a2458fa78fee036c9129af64548b";

  Future<List<Account>> getAll() async {
    Response response = await get(Uri.parse(url));
    _streamController.add("${DateTime.now()} | Requisição de leitura");

    Map<String, dynamic> mapResponse = json.decode(response.body);
    List<dynamic> listDynamic = json.decode(
      mapResponse["files"]["account.json"]['content'],
    );

    List<Account> listAccount = [];
    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapAccount = dyn as Map<String, dynamic>;
      Account account = Account.fromMap(mapAccount);
      listAccount.add(account);
    }

    return listAccount;
  }

  addAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.add(account);

    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    }

    String content = json.encode(listContent);

    Response response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $githubApiKey"},
      body: json.encode({
        "descrption": "Alteração de accounts.json via API com Dart",
        "public": true,
        "files": {
          "account.json": {"content": content},
        },
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
        "${DateTime.now()} | Requisição de adição bem sucedida (${account.name})",
      );
    } else {
      _streamController.add(
        "${DateTime.now()} | Requisição falhou (${account.name})",
      );
    }
  }

  Future<Account> getAccountById(String id) async {
    List<Account> listAccounts = await getAll();
    final index = listAccounts.indexWhere((account) => account.id == id);

    if (index >= 0){
      _streamController.add(
        "${DateTime.now()} | Encontrada conta com o Id: $id (${listAccounts[index].name})",
      );
      return listAccounts[index];
    } else {
      _streamController.add(
        "${DateTime.now()} | Não foi encontrada nenhuma conta com Id: $id",
      );
      Account emptyAccount = Account(id: "0", name: "", lastName: "", balance: 0);
      return emptyAccount;
    }

  }

  Future<bool> updateAccount(Account newAccount) async {
    List<Account> listAccounts = await getAll();
    final index = listAccounts.indexWhere((account) => account.id == newAccount.id);
    if (index >= 0){
      // Achou
      listAccounts[index] = newAccount;
      // Salva listAccounts
      _streamController.add(
        "${DateTime.now()} | Requisição de alteração bem sucedida (${newAccount.name})",
      );
      return true;
    } else {
      _streamController.add(
        "${DateTime.now()} | Não foi possível realizar a alteração. Conta não encontrada (${newAccount.name})",
      );
      return false;
    }
  }

  Future<bool> deleteAccount(String id) async {
    List<Account> listAccounts = await getAll();

    // listAccounts.removeWhere((account) => account.id == id);
    final index = listAccounts.indexWhere((account) => account.id == id);
    if (index >= 0){
      // Achou
      listAccounts.removeAt(index);
      // Salva listAccounts
      _streamController.add(
        "${DateTime.now()} | Requisição de exclusão bem sucedida",
      );
      return true;
    } else {
      _streamController.add(
        "${DateTime.now()} | Não foi possível realizar a alteração. Conta não encontrada ($id)",
      );
      return false;
    }
  }



}
