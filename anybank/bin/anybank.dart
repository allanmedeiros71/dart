import 'package:anybank/conta.dart';

void main() {
  ContaPoupanca contaJulia = ContaPoupanca("Júlia", 4000);
  ContaCorrente contaDenise = ContaCorrente("Denise", 4000);

  contaDenise.imprimirSaldo();
  contaDenise.debitar(4300);

  contaJulia.imprimirSaldo();
  contaJulia.calculaRendimento();
  contaJulia.debitar(4300);

  ContaSalario contaCatarina = ContaSalario(
    "Galega",
    100,
    "098098089809",
    "Venec Engenharia",
  );
  contaCatarina.imprimirSaldo();
  contaCatarina.creditarSalario(1100);
  contaCatarina.imprimirSaldo();

  ContaEmpresa contaCR = ContaEmpresa("Esola Carl Rogers", 125000);
  contaCR.imprimirSaldo();
  ContaInvestimento contaNubank = ContaInvestimento("Allan Medeiros", 1300);
  contaNubank.imprimirSaldo();
  contaCR.debitar(10000);
  contaNubank.creditar(10000);
}
