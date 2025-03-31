import 'package:anybank/cliente.dart';

void main(){
  Cliente allan = Cliente("Allan Medeiros");
  allan.reservar("201");
  allan.reservar("202");
  allan.reservar("1002");
  allan.cancelarReserva("210");
  allan.cancelarReserva("202");
}
