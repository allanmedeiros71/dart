import 'package:anybank/cliente.dart';

void main(){
  Cliente allan = Cliente("Allan Medeiros");
  allan.reservar("201");
  allan.reservar("202");
  allan.reservar("1002");
  allan.cancelarReserva("210");
  allan.cancelarReserva("202");

  Funcionario nilvan = Funcionario("Nilvan", 2300);
  nilvan.trabalhar();
  Cozinheiro cezar = Cozinheiro("Cezar", 2000);
  cezar.trabalhar();
  Garcom cabecao = Garcom("Cabeção", 1000);
  cabecao.trabalhar();
  Gerente nonato = Gerente("Nonato Caboré", 5000);
  nonato.trabalhar();


  QuartoSimples quartoSimples = QuartoSimples(3);
  quartoSimples.reservar();
  quartoSimples.calcularValorTotal();
  QuartoMedio quartoMedio = QuartoMedio(5);
  quartoMedio.reservar();
  quartoMedio.servirCafeManha();
  quartoMedio.calcularValorTotal();
  QuartoLuxo quartoLuxo = QuartoLuxo(7);
  quartoLuxo.reservar();
  quartoLuxo.servirCafeManha();
  quartoLuxo.realizarServicoQuarto();
  quartoLuxo.calcularValorTotal();
}
