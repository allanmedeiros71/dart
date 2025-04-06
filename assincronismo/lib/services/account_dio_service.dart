import 'dart:convert' show json;

import 'package:assincronismo/env.dart';
import 'package:assincronismo/models/account.dart';
import 'package:dio/dio.dart';

class AccountDioService {
  String url = "https://api.github.com/gists/65e7a2458fa78fee036c9129af64548b";

  final _dio = Dio();

  Future<List<Account>> getAll() async {
    Response response = await _dio.get(url);

    List<dynamic> listDynamic = json.decode(response.data["files"]["account.json"]['content']);

    List<Account> listAccount = [];
    for (dynamic dyn in listDynamic) {
      Map<String, dynamic> mapAccount = dyn as Map<String, dynamic>;
      Account account = Account.fromMap(mapAccount);
      listAccount.add(account);
    }

    return listAccount;
  }

    Future<bool> _saveAccounts(List<Account> listAccounts) async {
    List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    }

    String content = json.encode(listContent);

    _dio.options.headers["Authorization"] = "Bearer $githubApiKey";
    Response response = await _dio.post(
      url,
      data: json.encode({
        "descrption": "Alteração de accounts.json via API com Dart",
        "public": true,
        "files": {
          "account.json": {"content": content},
        },
      }),
    );

    if (response.statusCode.toString()[0] == "2") {
      return true;
    } else {
      return false;
    }
  }

  Future<Account> getAccountById(String id) async {
    List<Account> listAccounts = await getAll();
    final index = listAccounts.indexWhere((account) => account.id == id);

    if (index >= 0) {
      return listAccounts[index];
    } else {
      Account emptyAccount = Account(
        id: "0",
        name: "",
        lastName: "",
        balance: 0,
      );
      return emptyAccount;
    }
  }

  Future<void> addAccount(Account newAccount) async {
    List<Account> listAccounts = await getAll();
    int index = listAccounts.indexWhere(
      (account) => account.id == newAccount.id,
    );
    if (index >= 0) {
      return;
    }
    listAccounts.add(newAccount);

    bool result = await _saveAccounts(listAccounts);
    if (result) {
      return;
    } else {
      return;
    }
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
      return result;
    } else {
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
      return result;
    } else {
      return false;
    }
  }

}