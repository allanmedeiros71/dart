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
