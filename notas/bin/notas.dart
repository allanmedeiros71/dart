import 'dart:io';
import 'package:dart_console/dart_console.dart';

void main() {
  List<String> notas = [];

  // Clear the console
  print("\x1B[2J\x1B[0;0H");
  menu(notas);
}

String getComando() {
  List<String> comandos = ['1', '2', '3', 'q'];
  String? comando = "";

  comando = stdin.readLineSync();

  if (comando == null || !comandos.contains(comando)) {
    print('Comando inválido!');
    getComando();
  }

  return comando!;
}

List<String> adicionarNota(List<String> notas) {
  print('Digite a nota:');
  String? nota = "";
  nota = stdin.readLineSync();

  if (nota == null || nota.isEmpty) {
    print('Não é possível adicionar uma nota vazia!');
    adicionarNota(notas);
  } else {
    notas.add(nota);
    print('Nota adicionada com sucesso!');
  }

  return notas;
}

void listarNotas(List<String> notas) {
  if (notas.isEmpty) {
    print('Não há notas para listar!');
  } else {
    print('Notas:');
    for (int i = 0; i < notas.length; i++) {
      print('${i + 1}. ${notas[i]}');
    }
  }
}

List<String> removerNota(List<String> notas) {
  if (notas.isEmpty) {
    print('Não há notas para remover!');
  } else {
    print('Digite o número da nota que deseja remover:');
    listarNotas(notas);
    String? numero = stdin.readLineSync();
    int index = int.parse(numero!) - 1;

    if (index < 0 || index >= notas.length) {
      print('Número inválido!');
      removerNota(notas);
    } else {
      notas.removeAt(index);
      print('Nota removida com sucesso!');
    }
  }

  return notas;
}

void menu(List<String> notas) {
  final console = Console();
  console.setBackgroundColor(ConsoleColor.blue);
  console.setForegroundColor(ConsoleColor.white);
  console.writeLine('Bem-vindo ao sistema de gerenciamento de notas!', TextAlignment.center);
  console.resetColorAttributes();

  console.writeLine();

    console.writeLine('This console window has ${console.windowWidth} cols and '
      '${console.windowHeight} rows.');
  console.writeLine();

  console.writeLine('Source: https://pub.dev/packages/dart_console/example');
  console.writeLine('Source: https://pub.dev/documentation/dart_console/latest/dart_console/Console/readKey.html');

  Key key = console.readKey();
  if (key.isControl) {
    console.writeLine('You pressed a control key: ${key.controlChar}');
  } else {
    console.writeLine('You pressed a regular key: ${key.char}');
  }

  console.writeLine('This text is left aligned.', TextAlignment.left);
  console.writeLine('This text is center aligned.', TextAlignment.center);
  console.writeLine('This text is right aligned.', TextAlignment.right);

  for (final color in ConsoleColor.values) {
    console.setForegroundColor(color);
    console.writeLine(color.toString().split('.').last);
  }
  console.resetColorAttributes();

  cacecalho();
  print("");
  print ('Digite o comando:');
  print ('               1 - Adicionar nota');
  print ('                   2 - Listar notas');
  print ('                       3 - Remover nota');
  print ('                           q - Sair');
  print ('Comando:');

  String comando = getComando();
  print("");
  switch (comando) {
    case '1':
      adicionarNota(notas);
      menu(notas);
      break;
    case '2':
      listarNotas(notas);
      menu(notas);
      break;
    case '3':
      removerNota(notas);
      menu(notas);
      break;
    case '4':
      sair();
      break;
    default:
      print('Comando inválido!');
  }
}

void cacecalho() {
print("██████╗  █████╗ ██████╗ ████████╗    ███╗   ██╗ ██████╗ ████████╗███████╗███████╗");
print("██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝    ████╗  ██║██╔═══██╗╚══██╔══╝██╔════╝██╔════╝");
print("██║  ██║███████║██████╔╝   ██║       ██╔██╗ ██║██║   ██║   ██║   █████╗  ███████╗");
print("██║  ██║██╔══██║██╔══██╗   ██║       ██║╚██╗██║██║   ██║   ██║   ██╔══╝  ╚════██║");
print("██████╔╝██║  ██║██║  ██║   ██║       ██║ ╚████║╚██████╔╝   ██║   ███████╗███████║");
print("╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚══════╝╚══════╝");
print("                                                                                 ");

// print("                                                                                                    ");
// print("    _/_/_/                          _/          _/      _/              _/                          ");
// print("   _/    _/    _/_/_/  _/  _/_/  _/_/_/_/      _/_/    _/    _/_/    _/_/_/_/    _/_/      _/_/_/   ");
// print("  _/    _/  _/    _/  _/_/        _/          _/  _/  _/  _/    _/    _/      _/_/_/_/  _/_/        ");
// print(" _/    _/  _/    _/  _/          _/          _/    _/_/  _/    _/    _/      _/            _/_/     ");
// print("_/_/_/      _/_/_/  _/            _/_/      _/      _/    _/_/        _/_/    _/_/_/  _/_/_/        ");
// print("                                                                                                    ");
// print("                                                                                                    ");
}

void sair() {
  print('Saindo...');
  exit(0);
}
