void main() {
  Conta contaAllan = Conta("Allan", 1200);
  Conta contaIza = Conta("Izayana", 3000);

  List<Conta> contas = [contaAllan, contaIza];

  print(contaAllan.titular);
  print(contaAllan.saldo);

  contaAllan.saldo = 10000;
  print(contaAllan.saldo);
}

class Conta {
  String titular;
  double saldo;

  Conta(this.titular, this.saldo);

}
