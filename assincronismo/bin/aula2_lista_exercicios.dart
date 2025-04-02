import 'dart:convert';
import 'package:http/http.dart';

// Lista de exercícios.
// Fonte: https://cursos.alura.com.br/course/dart-dominando-assincronismo-criando-comunicacao-apis/task/168798

main() {
  buscarLivrosPorAutor("Machado de Assis");
  getReceitasPorIngredientes(["ovo"]);
  getReceitasPorIngredientes(["ovo", "frango"]);
  organizarTimes();
  consultasPorVeterinario("Maria José");
  consultasPorVeterinario("Patrícia Gomes");
}

// Exercício 1: Buscando livros por autor em uma biblioteca digital
// {
//     "title": "O Alquimista",
//     "author": "Paulo Coelho",
//     "year_of_publication": 1988,
//     "number_of_pages": 208
// },
void buscarLivrosPorAutor(String autor) async {
  String url =
      "https://raw.githubusercontent.com/alura-cursos/dart_assincronismo_api/aula05/.json/books.json";

  Response response = await get(Uri.parse(url));
  List<dynamic> livros = json.decode(response.body);
  Iterable<dynamic> livrosAutor = livros.where(
    (livro) => livro['author'] == autor,
  );

  for (dynamic livro in livrosAutor) {
    print("Livro: ${livro["title"]}");
  }
}

// Exercício 2: Filtrando receitas por ingredientes disponíveis
// {
//     "name": "Bolo de Cenoura",
//     "preparation_time": "45 minutos",
//     "ingredients": [
//         "3 cenouras médias",
//         "4 ovos",
//         "1 xícara de óleo",
//         "2 xícaras de açúcar",
//         "2 e 1/2 xícaras de farinha de trigo",
//         "1 colher de sopa de fermento em pó"
//     ],
//     "instructions": "Bata no liquidificador as cenouras, os ovos e o óleo. Em uma tigela, misture o açúcar e a farinha. Adicione a mistura do liquidificador e mexa bem. Acrescente o fermento e misture novamente. Despeje em uma forma untada e asse em forno pré-aquecido a 180ºC por cerca de 40 minutos."
// },
void getReceitasPorIngredientes(List<String> ingredientes) async {
  String url =
      "https://raw.githubusercontent.com/alura-cursos/dart_assincronismo_api/aula05/.json/recipes.json";
  Response response = await get(Uri.parse(url));
  List<dynamic> receitas = json.decode(response.body);

  List<String> receitasPossiveis = [];

  for (dynamic receitaDyn in receitas) {
    Map<String, dynamic> receita = receitaDyn as Map<String, dynamic>;
    List<dynamic> ingredientesReceita = receita["ingredients"];

    bool contemTodosIngredientes = ingredientes.every((ingrediente) {
      bool temNaReceita = false;
      for (String ingredienteDaReceita in ingredientesReceita) {
        if (ingredienteDaReceita.toLowerCase().contains(
          ingrediente.toLowerCase(),
        )) {
          temNaReceita = true;
          break;
        }
      }
      return temNaReceita;
    });
    if (contemTodosIngredientes) {
      receitasPossiveis.add(receita["name"]);
    }
  }

  receitasPossiveis.forEach((receita) => print("Receita: $receita"));
}

// Exercício 3: Organizando times de vôlei por nível de habilidade
//{
//  "rules": {
//         "winnersRemains": true,
//         "winnerRemainsMax": 2,
//         "playersPerTeam": 4
//     },
// "players": [
//     {
//         "name": "Ricarth",
//         "position": "ponteiro",
//         "skillRate": 2,
//         "roundsWaiting": 0,
//         "isResting": false
//     },
//     ...
//  ]
//}

void organizarTimes() async {
  String url =
      "https://raw.githubusercontent.com/alura-cursos/dart_assincronismo_api/aula05/.json/players.json";
  Response response = await get(Uri.parse(url));
  Map<String, dynamic> players = json.decode(response.body);

  int qtdJogadoresPorTime = players["rules"]["playersPerTeam"];
  List<dynamic> jogadores = players["players"];

  jogadores.sort(
    (a, b) =>
        (b["roundsWaiting"] as int).compareTo((a["roundsWaiting"] as int)),
  );

  List<dynamic> time1 = jogadores.sublist(0, qtdJogadoresPorTime);
  List<dynamic> time2 = jogadores.sublist(
    qtdJogadoresPorTime,
    qtdJogadoresPorTime * 2,
  );

  print("Time 1:");
  for (Map<String, dynamic> jogador in time1) {
    print("Jogador: ${jogador["name"]}");
  }
  print("Time 2:");
  for (Map<String, dynamic> jogador in time2) {
    print("Jogador: ${jogador["name"]}");
  }
}

// Exercício 4: Agendando consultas para uma clínica veterinária
// {
//    "appointment": "2024-08-10 14:30",
//    "veterinarian": "Dra. Patrícia Gomes",
//    "pet_name": "Spike"
// },
void consultasPorVeterinario(String nomeVeterinario) async {
  // Url do json
  String url =
      "https://raw.githubusercontent.com/alura-cursos/dart_assincronismo_api/aula05/.json/vet.json";
  // Obtem o json
  Response response = await get(Uri.parse(url));
  // Convert o body do request em List
  List<dynamic> consultasAgendadas = json.decode(response.body);

  // Filtra as consultas do veterinário informado como parâmetro.
  // O resultado é um objeto do tipo Iterable
  // Converte o Iterable para List para poder usar o método Sort que só existe para List
  List<dynamic> consultasVet =
      consultasAgendadas
          .where(
            (consulta) => consulta["veterinarian"].contains(nomeVeterinario),
          )
          .toList();

  // Se a lista for vazia, retorna mensagem de aviso
  if (consultasVet.isEmpty) {
    print("Não foram encontrados registros para $nomeVeterinario");
  } else {
    // Ordena por Data e Hora do agendamento
    consultasVet.sort(
      (a, b) =>
          (a["appointment"] as String).compareTo((b["appointment"] as String)),
    );

    // Exibe o agendamento
    print("Consultas Agendadas para $nomeVeterinario");
    for (Map<String, dynamic> consulta in consultasVet) {
      print(
        "Pet: ${consulta["pet_name"]} - Horário: ${consulta["appointment"]}",
      );
    }
  }
}
