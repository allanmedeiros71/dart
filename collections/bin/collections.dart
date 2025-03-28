import 'dart:ffi';

void listaTarefas(List<String> tarefas) {
  for (String tarefa in tarefas) {
    print(tarefa);
  }
}

void idsPares(List<int> idsFuncionarios) {
  for (int id in idsFuncionarios) {
    if (id % 2 == 0) {
      print(id);
    }
  }
}

void itensVisitados(List<String> produtosCarrinho, List<String> produtosVisitados) {
  for(String produto in produtosVisitados){
    if (!produtosCarrinho.contains(produto)) {
      print('Produto $produto não está no carrinho.');
    }
  }
}

int contarOcorrencias(List<String> produtos, String produto) {
  int contador = 0;
  for (String item in produtos) {
    if (item == produto) {
      contador++;
    }
  }
  return contador;
}

bool verificaCodigo(Set<int> codigosDisponiveis, int codigo){
  return codigosDisponiveis.contains(codigo);
}
void promocao(Set<int> semanal, Set<int> mensal){
  Set<int> promocoes = semanal.union(mensal);
  for (int item in  promocoes){
    print("Item n# $item em promoção");
  }
}

void produtosNaoVendidos(Set<String> produtosVendidos, Set<String> produtosEstoque){
  for (String produto in produtosEstoque){
    if (!produtosVendidos.contains(produto)) {
      print("$produto: Produto ainda não vendido!");
    }
  }
}

double calculaTotal(Map<String, double> precosProdutos){
  double valorTotal = 0;
  precosProdutos.forEach((chave, valor){
    valorTotal += valor;
  });
  return valorTotal;
}

void atualizaPreco(Map<String, double> inventarioProdutos, String produto, double preco){
  if (!inventarioProdutos.containsKey(produto)){
    print("Produto não cadastrado: $produto");
  } else {
    inventarioProdutos[produto] = preco;
    print("Preço do produto $produto alterado para R\$ $preco");
  }
  inventarioProdutos.forEach((produto, preco){
    print("$produto : $preco");
  });
}

void listaClientes(List<Map<String, dynamic>> clientes, double pontuacao){
  for (Map cliente in clientes){
    if (cliente['pontuacao']>pontuacao){
      print("${cliente['nome']} tem pontuacao superior a $pontuacao");
    }
  }
}

void main() {

  List<String> tarefas = ["Estudar", "Comprar mantimentos"]; 
  listaTarefas(tarefas);
  tarefas.add("Fazer exercícios");
  listaTarefas(tarefas);
  tarefas.remove("Comprar mantimentos");
  listaTarefas(tarefas);
  tarefas[0] = "Estudar Dart";
  listaTarefas(tarefas);
  tarefas.sort();
  listaTarefas(tarefas);

  List<int> idsFuncionarios = [1, 2, 3, 4, 5, 6, 7, 8, 9]; 
  idsPares(idsFuncionarios);

  List<String> produtos = ["maçã", "banana", "maçã", "laranja", "maçã"]; 
  String produto = "maçã";
  int ocorrencias = contarOcorrencias(produtos, produto);
  print("O produto $produto aparece $ocorrencias vezes na lista.");

  List<String> produtosCarrinho = ["arroz", "macarrão", "leite", ]; 
  List<String> produtosVisitados = ["arroz", "feijão", "macarrão", "leite", "açúcar"]; 
  itensVisitados(produtosCarrinho, produtosVisitados);

  Set<int> codigosDisponiveis = {1, 2, 3, 4, 5}; 
  if (verificaCodigo(codigosDisponiveis, 1)) {
    print("Código 1 disponível");
  } else {
    print("Código 1 indisponível");
  }

  if (verificaCodigo(codigosDisponiveis, 99)) {
    print("Código 99 disponível");
  } else {
    print("Código 99 indisponível");
  }

  Set<int> produtosSemana = {1, 2, 3, 4};   
  Set<int> produtosMes = {3, 4, 5, 6}; 
  promocao(produtosMes, produtosSemana);

  Set<String> produtosVendidos = {"maçã", "banana", "laranja"};   
  Set<String> produtosEstoque = {"banana", "kiwi", "laranja", "uva"}; 
  produtosNaoVendidos(produtosVendidos, produtosEstoque);


  Map<String, double> precosProdutos = { 
    "Camiseta": 30.0, 
    "Calça": 50.0, 
    "Boné": 15.0, 
    "Tênis": 120.0 
  }; 
  double valorTotal = calculaTotal(precosProdutos); 
  print("Valor total dos produtos: $valorTotal");


  Map<String, double> inventarioProdutos = { 
    "Camiseta": 30.0, 
    "Calça": 50.0, 
    "Boné": 15.0 
  }; 
  atualizaPreco(inventarioProdutos, "Bone", 50);
  atualizaPreco(inventarioProdutos, "Boné", 100);


  List<Map<String, dynamic>> clientes = [ 
    {"nome": "João", "pontuacao": 6.5}, 
    {"nome": "Maria", "pontuacao": 8.7}, 
    {"nome": "Pedro", "pontuacao": 9.2}, 
    {"nome": "Ana", "pontuacao": 5.4} 
  ];
  listaClientes(clientes, 7);
  listaClientes(clientes, 9);
}
