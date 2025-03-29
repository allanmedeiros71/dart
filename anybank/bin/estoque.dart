// 01. Criando uma conta - Lista de Exercícios 
// Criando uma classe para itens de estoque
void main() {
  Estoque p1 = Estoque("Smatphone", 100, marca: "Nokia");
  Estoque p2 = Estoque("Notebook", 50, marca: "Dell", disponivel: false);

  print(p1.emTexto());
  print (p1.disponivel);
  print(p2.emTexto());
  print (p2.disponivel);

  p1.entrada(30);
  print(p1.emTexto());
  p2.saida(25);
  print(p2.emTexto());
}

class Estoque {
  String produto;
  double quantidade;
  String marca;
  bool? disponivel;

  Estoque(this.produto, this.quantidade, {required this.marca, this.disponivel = true});

  String emTexto(){
    return   "Produto: $produto ($marca), Quantidade em estoque: $quantidade";
  }

  void entrada(double quantidade){
    this.quantidade += quantidade;
  }

  void saida(double quantidade){
    this.quantidade -= quantidade;
  }

}