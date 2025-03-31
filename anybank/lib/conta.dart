class Conta {
  String titular;
  double _saldo; // Underline implica Variável privada

  Conta(this.titular, this._saldo);

  void creditar(double valor){
    _saldo += valor;
    imprimirSaldo();
  }

  void debitar(double valor){
    if (valor <= _saldo){
      _saldo -= valor;
      imprimirSaldo();
    }
  }

  void transferir(double valor, Conta conta){
    debitar(valor);
    conta.creditar(valor);
  }

  void imprimirSaldo(){
    print("O saldo atual de $titular é : R\$ $_saldo");
  }

  double getSaldo(){
    return _saldo;
  }

}

class ContaPoupanca extends Conta{
  double rendimento = 0.05;

  ContaPoupanca(super.titular, super._saldo);

  void calculaRendimento(){
    _saldo += _saldo * rendimento;
    imprimirSaldo();
  }
}

class ContaCorrente extends Conta {
  double emprestimo = 300;

  ContaCorrente(super.titular, super._saldo);

  @override
  void debitar(double valor) {
    if (_saldo + emprestimo >= valor) {
      _saldo -= valor;
      imprimirSaldo();
    }
  }
}

class ContaSalario extends Conta {
  String cnpj = "";
  String empresa = "";

  ContaSalario(super.titular, super._saldo, this.cnpj, this.empresa);

  void creditarSalario(double salario){
    _saldo += salario;
    print("O salário da $empresa, de CNPJ $cnpj no valor de R\$ $salario, foi depositado!");
  }

}