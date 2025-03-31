// 01. Criando uma conta - Lista de Exercícios 
// Criando uma classe para itens de estoque
void main() {
  ItemEstoque p1 = ItemEstoque("Smatphone", quantidade: 100, marca: "Nokia", preco: 250);
  ItemEstoque p2 = ItemEstoque("Notebook", quantidade: 50, marca: "Dell", preco: 3000, disponivel: false);

  print(p1.emTexto());
  print (p1.disponivel);
  print(p2.emTexto());
  print (p2.disponivel);

  p1.entrada(30);
  print(p1.emTexto());
  p2.saida(25);
  print(p2.emTexto());

  List<ItemEstoque> loja = [];
  loja.add(ItemEstoque("Smartphone", quantidade: 25, marca: "Nokia", preco: 230));
  loja.add(ItemEstoque("TV LED", quantidade: 100, marca: "Samsung", preco: 2800));
  loja.add(ItemEstoque("Notebook", quantidade: 13, marca: "Dell", preco: 3200));
  loja.add(ItemEstoque("Teclado", quantidade: 44, marca: "Warrior", preco: 125));
  print("Itens da loja:");
  for (ItemEstoque item in loja){
    item.exibir();
  }

  loja[2].alterarPreco(4200);
  print("Itens da loja com preço reajustado:");
  for (ItemEstoque item in loja){
    item.exibir();
  }

}

class ItemEstoque {
  String produto;
  String marca;
  double quantidade;
  double preco;
  bool? disponivel;

  ItemEstoque(this.produto, {required this.quantidade, required this.marca, required this.preco, this.disponivel = true});

  String emTexto(){
    return   "Produto: $produto ($marca), Preço: R\$ $preco. Quantidade em estoque: $quantidade";
  }

  void exibir(){
    print("Produto: $produto ($marca), Preço: R\$ $preco. Quantidade em estoque: $quantidade");
  }

  void entrada(double quantidade){
    this.quantidade += quantidade;
  }

  void saida(double quantidade){
    this.quantidade -= quantidade;
  }

  void alterarPreco(double novoPreco){
    preco = novoPreco;
  }

}