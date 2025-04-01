import 'dart:convert';
import 'package:http/http.dart';

// Lista de exercícios.
// Fonte: https://cursos.alura.com.br/course/dart-dominando-assincronismo-criando-comunicacao-apis/task/168798

main(){
  buscarLivrosPorAutor("Machado de Assis");
  getReceitasPorIngredientes(["ovo"]);
  getReceitasPorIngredientes(["ovo", "frango"]);
}


// Exercício 1: Buscando livros por autor em uma biblioteca digital
// {
//     "title": "O Alquimista",
//     "author": "Paulo Coelho",
//     "year_of_publication": 1988,
//     "number_of_pages": 208
// },
void buscarLivrosPorAutor(String autor) async {
  String url = "https://raw.githubusercontent.com/alura-cursos/dart_assincronismo_api/aula05/.json/books.json";

  Response response = await get(Uri.parse(url));
  List<dynamic> livros = json.decode(response.body);
  Iterable<dynamic> livrosAutor = livros.where((livro) => livro['author'] == autor);

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
  String url = "https://raw.githubusercontent.com/alura-cursos/dart_assincronismo_api/aula05/.json/recipes.json";
  Response response = await get(Uri.parse(url));
  List<dynamic> receitas = json.decode(response.body);

  List<String> receitasPossiveis = [];

  for (dynamic receitaDyn in receitas) {
    Map<String, dynamic> receita = receitaDyn as Map<String, dynamic>;
    List<dynamic> ingredientesReceita = receita["ingredients"];

    bool contemTodosIngredientes = ingredientes.every(
      (ingrediente) {
        bool temNaReceita = false;
        for (String ingredienteDaReceita in ingredientesReceita){
          if (ingredienteDaReceita.toLowerCase().contains(ingrediente.toLowerCase())){
            temNaReceita = true;
            break;
          }
        }
        return temNaReceita;
      },
    );
    if (contemTodosIngredientes) {
      receitasPossiveis.add(receita["name"]);
    }
  }

  receitasPossiveis.forEach((receita) => print("Receita: $receita"));
}