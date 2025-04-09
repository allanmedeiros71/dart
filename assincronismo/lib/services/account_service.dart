import 'dart:async';
import 'dart:core';

import 'package:assincronismo/env.dart';
import 'package:assincronismo/models/account.dart';
import 'package:http/http.dart';
import 'dart:convert';

// TODO: Validar com try catch quando o ID fornecido não for encontrado em todos os métodos de pesquisa

class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;
  String url = "https://api.github.com/gists/65e7a2458fa78fee036c9129af64548b";

  Future<List<Account>> getAll() async {
    Response response = await get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $gitHupAuthToken"},
    );
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

  Future<Account> getAccountById(String id) async {
    List<Account> listAccounts = await getAll();
    final index = listAccounts.indexWhere((account) => account.id == id);

    if (index >= 0) {
      _streamController.add(
        "${DateTime.now()} | Encontrada conta com o Id: $id (${listAccounts[index].name})",
      );
      return listAccounts[index];
    } else {
      _streamController.add(
        "${DateTime.now()} | Não foi encontrada nenhuma conta com Id: $id",
      );
      throw AccountNotFoundException('Conta com id $id não encontrada');
    }
  }

  Future<bool> _saveAccounts(List<Account> listAccounts) async {
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
      _streamController.add("${DateTime.now()} | Gravação bem sucedida");
      return true;
    } else {
      _streamController.add("${DateTime.now()} | Gravação falhou");
      return false;
    }
  }

  addAccount(Account newAccount) async {
    List<Account> listAccounts = await getAll();
    int index = listAccounts.indexWhere(
      (account) => account.id == newAccount.id,
    );
    if (index >= 0) {
      _streamController.add(
        "${DateTime.now()} | Requisição falhou (Conta já existente - ${newAccount.name})",
      );
      return;
    }
    listAccounts.add(newAccount);

    bool result = await _saveAccounts(listAccounts);
    if (result) {
      _streamController.add(
        "${DateTime.now()} | Requisição de adição bem sucedida (${newAccount.name})",
      );
    } else {
      _streamController.add(
        "${DateTime.now()} | Requisição falhou (${newAccount.name})",
      );
    }

    // List<Map<String, dynamic>> listContent = [];
    // for (Account account in listAccounts) {
    //   listContent.add(account.toMap());
    // }

    // String content = json.encode(listContent);

    // Response response = await post(
    //   Uri.parse(url),
    //   headers: {"Authorization": "Bearer $githubApiKey"},
    //   body: json.encode({
    //     "descrption": "Alteração de accounts.json via API com Dart",
    //     "public": true,
    //     "files": {
    //       "account.json": {"content": content},
    //     },
    //   }),
    // );

    // if (response.statusCode.toString()[0] == "2") {
    //   _streamController.add(
    //     "${DateTime.now()} | Requisição de adição bem sucedida (${account.name})",
    //   );
    // } else {
    //   _streamController.add(
    //     "${DateTime.now()} | Requisição falhou (${account.name})",
    //   );
    // }
  }

  Future<bool> updateAccount(Account newAccount) async {
    List<Account> listAccounts = await getAll();
    final index = listAccounts.indexWhere(
      (account) => account.id == newAccount.id,
    );
    if (index >= 0) {
      // Achou
      listAccounts[index] = newAccount;
      bool result = await _saveAccounts(listAccounts);
      if (result) {
        _streamController.add(
          "${DateTime.now()} | Requisição de alteração bem sucedida (${listAccounts[index].name})",
        );
        return true;
      } else {
        _streamController.add(
          "${DateTime.now()} | Não foi possível realizar a alteração (${listAccounts[index].name})",
        );
        return false;
      }
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
    if (index >= 0) {
      // Achou
      listAccounts.removeAt(index);
      bool result = await _saveAccounts(listAccounts);
      if (result) {
        _streamController.add(
          "${DateTime.now()} | Requisição de exclusão bem sucedida (Id: $id)",
        );
        return true;
      } else {
        _streamController.add(
          "${DateTime.now()} | Não foi possível realizar a exclusão (Id: )",
        );
        return true;
      }
    } else {
      _streamController.add(
        "${DateTime.now()} | Não foi possível realizar a alteração. Conta não encontrada ($id)",
      );
      return false;
    }
  }
}

class AccountNotFoundException implements Exception {
  final String message;
  AccountNotFoundException(this.message);

  @override
  String toString() => message;
}
