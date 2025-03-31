
import 'package:anybank/ingrediente.dart';

void main(){
  // Criando instâncias de frutas, legumes e temperos
  var banana = Fruta('Banana');
  var cenoura = Legume('Cenoura');
  var sal = Tempero('Sal');

  // Exibindo os detalhes
  banana.exibirDetalhes();
  print('');
  cenoura.exibirDetalhes();
  print('');
  sal.exibirDetalhes();}
