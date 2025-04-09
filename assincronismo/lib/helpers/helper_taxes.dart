import 'package:assincronismo/models/account.dart';

double calculateTaxesByAccount(Account account, double amount) {
  if (amount < 5000) {
    return 0;
  }
  // Ambrosia: 0.5% para transações acima de R$5000.
  // Canjica: 0.33% para transações acima de R$5000.
  // Pudim: 0.25% para transações acima de R$5000.
  // Brigadeiro: 0.01% para transações acima de R$5000.
  if (account.accountType == "Ambrosia") {
    return amount * 0.005;
  } else if (account.accountType == "Canjica") {
    return amount * 0.0033;
  } else if (account.accountType == "Pudim") {
    return amount * 0.0025;
  } else if (account.accountType == "Brigadeiro") {
    return amount * 0.0001;
  } else {
    return 0;
  }
}
