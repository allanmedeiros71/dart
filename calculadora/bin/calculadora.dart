import 'dart:io';

void main() {
  double numeroUm = 0;
  double numeroDois = 0;
  String operacao = "";
  String? entrada = "";
  List<String> operacoes = ['+', '-', '*', '/'];
  
  void soma() {
    print('O resultado da soma é de $numeroUm + $numeroDois é:');
    print(numeroUm + numeroDois);
  }

  void subtracao() {
    print('O resultado da subtração é de $numeroUm - $numeroDois é:');
    print(numeroUm - numeroDois);
  }

  void multiplicacao() {
    print('O resultado da multiplicação é de $numeroUm * $numeroDois é:');
    print(numeroUm * numeroDois);
  }

  void divisao() {
    if (numeroDois == 0) {
      print('Divisão por zero não é permitida.');
      return;
    }
    print('O resultado da divisão é de $numeroUm / $numeroDois é:');
    print(numeroUm / numeroDois);
  }

  void calcular() {
    // O mesmo com switch case
    switch (operacao) {
      case '+':
        soma();
        break;
      case '-':
        subtracao();
        break;
      case '*':
        multiplicacao();
        break;
      case '/':
        divisao();
        break;
      default:
        print('Operação inválida');
    }
  }

  void getOperacao() {
    print('Digite a operação ${operacoes.toString()}:');
    entrada = stdin.readLineSync();
    if (entrada != null) {
      if (operacoes.contains(entrada)) {
        operacao = entrada!;
      } else {
        print('Operação inválida. Tente novamente.');
        getOperacao(); // Chama a função novamente para obter uma operação válida
      }
    }
  }

  // if (operacao == '+') {
  //   soma();
  // } else if (operacao == '-') {
  //   subtracao();
  // } else if (operacao == '*') {
  //   multiplicacao();
  // } else if (operacao == '/') {
  //   divisao();
  // } else {
  //   print('Operação inválida');
  // }

  print('Calculadora');
  print('Digite o primeiro número:');
  entrada = stdin.readLineSync();
  // Verifica se a entrada não é nula e não é vazia
  if (entrada != null) {
    if (entrada != '') {
      numeroUm = double.parse(entrada!);
    }
  }

  // Chama a função getOperacao
  getOperacao();

  print('Digite o segundo número:');
  entrada = stdin.readLineSync();
  if (entrada != null) {
    if (entrada != '') {
      numeroDois = double.parse(entrada!);
    }
  }

  // Chama a função calcular
  calcular();
}
