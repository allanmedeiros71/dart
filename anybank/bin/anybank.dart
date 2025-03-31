
import 'package:anybank/conta.dart';

void main() {
  Conta contaAllan = Conta("Allan", 1200);
  Conta contaIza = Conta("Izayana", 3000);

  List<Conta> contas = [contaAllan, contaIza];
  for (Conta conta in contas) {
    conta.imprimirSaldo();
  }

  contaAllan.creditar(10000);
  contaAllan.creditar(300);
  contaAllan.debitar(1500);
  contaAllan.transferir(5000, contaIza);
}
