import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:assincronismo/config/env.dart';
import 'package:assincronismo/models/account.dart';
import 'package:http/http.dart';
import 'dart:convert';

/// Service responsible for managing account operations through the GitHub Gist API
class AccountService {
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;

  /// Retrieves all accounts from the API
  Future<List<Account>> getAll() async {
    try {
      final response = await get(
        Uri.parse(Env.githubGistUrl),
        headers: {"Authorization": "Bearer ${Env.githubAuthToken}"},
      );
      _logInfo("Requisição de leitura");

      if (response.statusCode != 200) {
        throw HttpException('Failed to fetch accounts: ${response.statusCode}');
      }

      final mapResponse = json.decode(response.body);
      final listDynamic = json.decode(
        mapResponse["files"]["account.json"]['content'],
      );

      return [
        for (final item in listDynamic)
          Account.fromMap(item as Map<String, dynamic>),
      ];
    } catch (e) {
      _logError("Falha ao carregar contas: $e");
      rethrow;
    }
  }

  /// Retrieves a specific account by its ID
  Future<Account> getAccountById(String id) async {
    try {
      final listAccounts = await getAll();
      final account = listAccounts.firstWhere(
        (account) => account.id == id,
        orElse: () => throw AccountNotFoundException(
          'Conta com id $id não encontrada',
        ),
      );

      _logInfo("Encontrada conta com o Id: $id (${account.name})");
      return account;
    } catch (e) {
      if (e is AccountNotFoundException) {
        _logError("Não foi encontrada nenhuma conta com Id: $id");
      }
      rethrow;
    }
  }

  /// Saves the list of accounts to the API
  Future<void> _save(List<Account> accounts) async {
    try {
      final content = json.encode([
        for (final account in accounts) account.toMap(),
      ]);

      final response = await post(
        Uri.parse(Env.githubGistUrl),
        headers: {"Authorization": "Bearer ${Env.githubAuthToken}"},
        body: json.encode({
          "description": "Alteração de accounts.json via API com Dart",
          "public": true,
          "files": {
            "account.json": {"content": content},
          },
        }),
      );

      if (response.statusCode < 200 || response.statusCode > 299) {
        throw HttpException('Failed to save accounts: ${response.statusCode}');
      }

      _logInfo("Gravação bem sucedida");
    } catch (e) {
      _logError("Gravação falhou: $e");
      rethrow;
    }
  }

  /// Adds a new account
  Future<void> addAccount(Account newAccount) async {
    try {
      final listAccounts = await getAll();
      if (listAccounts.any((account) => account.id == newAccount.id)) {
        throw StateError('Conta já existente');
      }

      listAccounts.add(newAccount);
      await _save(listAccounts);
      _logInfo("Requisição de adição bem sucedida (${newAccount.name})");
    } catch (e) {
      _logError("Falha ao adicionar conta ${newAccount.name}: $e");
      rethrow;
    }
  }

  /// Updates an existing account
  Future<void> updateAccount(Account newAccount) async {
    try {
      final listAccounts = await getAll();
      final index = listAccounts.indexWhere(
        (account) => account.id == newAccount.id,
      );

      if (index < 0) {
        throw AccountNotFoundException('Conta não encontrada');
      }

      listAccounts[index] = newAccount;
      await _save(listAccounts);
      _logInfo("Requisição de alteração bem sucedida (${newAccount.name})");
    } catch (e) {
      _logError("Falha ao atualizar conta ${newAccount.name}: $e");
      rethrow;
    }
  }

  /// Deletes an account by its ID
  Future<void> deleteAccount(String id) async {
    try {
      final listAccounts = await getAll();
      final index = listAccounts.indexWhere((account) => account.id == id);

      if (index < 0) {
        throw AccountNotFoundException('Conta não encontrada');
      }

      final accountName = listAccounts[index].name;
      listAccounts.removeAt(index);
      await _save(listAccounts);
      _logInfo("Requisição de exclusão bem sucedida ($accountName)");
    } catch (e) {
      _logError("Falha ao excluir conta $id: $e");
      rethrow;
    }
  }

  void _logInfo(String message) {
    _streamController.add("${DateTime.now()} | $message");
  }

  void _logError(String message) {
    _streamController.add("${DateTime.now()} | $message");
  }
}

class AccountNotFoundException implements Exception {
  final String message;
  AccountNotFoundException(this.message);

  @override
  String toString() => message;
}
