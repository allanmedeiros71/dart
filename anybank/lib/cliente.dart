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

abstract class Quarto{
  String tipo;
  double valorDiaria;
  int diarias;

  Quarto(this.tipo, this.valorDiaria, this.diarias);

  void reservar(){
    print("Reserva realizada para $diarias diarias no quarto $tipo.");
  }

  void calcularValorTotal() {
    print("Total a pagar: R\$${diarias * valorDiaria}");
  }
}

class QuartoSimples extends Quarto {
  QuartoSimples(int diarias) : super("Simples", 80, diarias);
}

class QuartoMedio extends Quarto {
  QuartoMedio(int diarias) : super("Médio", 250, diarias);

  void servirCafeManha(){
    print("Servindo café da manhã no quarto do $tipo");
  }
}

class QuartoLuxo extends Quarto {
  QuartoLuxo(int diarias) : super("Luxo", 1000, diarias);

  void servirCafeManha(){
    print("Servindo café da manhã no quarto do $tipo");
  }

  void realizarServicoQuarto(){
    print("Limpando o quarto $tipo.");
  }
}