import "dart:io";

// void main() {
//   print("Olá, me chamo Dart. Qual é o seu nome?");
//   var entrada = stdin.readLineSync();
//   print("Olá, $entrada! Prazer em te conhecer.");
// }

// Exercício 3
void main() {
  print("Olá, me chamo Dart. Qual o seu nome?");
  String? nome = stdin.readLineSync();
  print("Muito prazer, $nome. Vamos fazer vários programas juntos.");
}