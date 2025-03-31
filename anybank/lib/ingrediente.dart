class Ingrediente{
  String nome;
  String tipo;

  Ingrediente(this.nome, this.tipo);

  void exibirDetalhes(){
    print("Ingrediente: $nome\nTipo: $tipo");
  }
}

class Fruta extends Ingrediente {
  Fruta(String nome) : super(nome, "Fruta");

  @override
  void exibirDetalhes(){
    super.exibirDetalhes();
    print("Detalhe: As frutas geralmente não são cozidas nas receitas. ");
  }
}

class Legume extends Ingrediente {
  Legume(String nome) : super(nome, "Legume");

  @override
  void exibirDetalhes(){
    super.exibirDetalhes();
    print("Detalhe: Os legumes geralmente precisam ser cozidos nas receitas.");
  }
}

class Tempero extends Ingrediente {
  Tempero(String nome) : super(nome, "Tempero");

  @override
  void exibirDetalhes(){
    super.exibirDetalhes();
    print("Detalhe: Os temperos são usados para condimentar os alimentos.");
  }
}