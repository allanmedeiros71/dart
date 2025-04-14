import 'package:flutter_banco_douro/models/account.dart';

double calculateTaxesByAccount(
    {required Account sender, required double amount}) {
  if (amount < 5000) {
    return 0;
  }
  // Ambrosia: 0.5% para transações acima de R$5000.
  // Canjica: 0.33% para transações acima de R$5000.
  // Pudim: 0.25% para transações acima de R$5000.
  // Brigadeiro: 0.01% para transações acima de R$5000.
  if (sender.accountType != null) {
    if (sender.accountType == AccountType.ambrosia) {
      return amount * 0.005;
    } else if (sender.accountType == AccountType.canjica) {
      return amount * 0.0033;
    } else if (sender.accountType == AccountType.pudim) {
      return amount * 0.0025;
    } else {
      // Brigadeiro
      return amount * 0.0001;
    }
  } else {
    return 0.1;
  }
}
