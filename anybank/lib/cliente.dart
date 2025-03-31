class Cliente{
  String nome;
  // ignore: prefer_final_fields
  List<String> _reservas = [];

  Cliente(this.nome);

  void reservar(String quarto){
    _reservas.add(quarto);
    print("Reserva realizada com sucesso para o quarto $quarto");
    listarReservas();
  }

  void cancelarReserva(String quarto){
    if (_reservas.contains(quarto)){
      _reservas.remove(quarto);
      print("O  quarto $quarto foi removido da lista de reservas de $nome");
    } else {
      print("O quarto $quarto não está reservado para o cliente $nome");
    }
    listarReservas();
  }

  void listarReservas(){
    print("Reservas do cliente $nome:");
    for (String reserva in _reservas){
      print("Reserva: $reserva");
    }
  }

}

class Funcionario {
  String nome;
  double salario;

  Funcionario(this.nome, this.salario);

  void trabalhar(){
    print("Olá, eu sou $nome");
  }
}

class Cozinheiro extends Funcionario {
  Cozinheiro(super.nome, super.salario);

  @override
  void trabalhar(){
    print("Olá, eu sou $nome e sou cozinheiro");

  }
}

class Garcom extends Funcionario {
  Garcom(super.nome, super.salario);

  @override
  void trabalhar(){
    print("Olá, eu sou $nome e sou garçom");
  }
}

class Gerente extends Funcionario {
  Gerente(super.nome, super.salario);

  @override
  void trabalhar(){
    print("Olá, eu sou $nome e sou gerente");

  }

}