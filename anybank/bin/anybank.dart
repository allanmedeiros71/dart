
import 'package:anybank/conta.dart';

void main() {
  Conta contaAllan = Conta("Allan", 1200);
  Conta contaIza = Conta("Izayana", 3000);
  ContaPoupanca contaJulia = ContaPoupanca("Júlia", 4000);
  ContaCorrente contaDenise = ContaCorrente("Denise", 4000);

  List<Conta> contas = [contaAllan, contaIza];
  for (Conta conta in contas) {
    conta.imprimirSaldo();
  }

  contaAllan.creditar(10000);
  contaAllan.creditar(300);
  contaAllan.debitar(1500);
  contaAllan.transferir(5000, contaIza);

  contaDenise.imprimirSaldo();
  contaDenise.debitar(4300);

  contaJulia.imprimirSaldo();
  contaJulia.calculaRendimento();
  contaJulia.debitar(4300);

  ContaSalario contaCatarina = ContaSalario("Galega", 100, "098098089809", "Venec Engenharia");
  contaCatarina.imprimirSaldo();
  contaCatarina.creditarSalario(1100);
  contaCatarina.imprimirSaldo();

}
