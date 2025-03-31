abstract class Agendamento{
  void calculaDuracaoConsulta();
  void verificaDisponibilidade();
}

class Medico implements Agendamento{
  @override
  void calculaDuracaoConsulta() {
    print("Duração de 30 minutos");
  }

  @override
  void verificaDisponibilidade() {
    print("verificar disponibilidade no calendário");
  }

}

class Dentista implements Agendamento{
  @override
  void calculaDuracaoConsulta() {
    print("Duração de 45 minutos");
  }

  @override
  void verificaDisponibilidade() {
    print("verificar disponibilidade considerando intervalos de 15 minutos");
  }

}

class GerenciadorDeAgendamentos{
  List<Agendamento> profissionais = [];

  void adicionarProfissional(Agendamento profissional){
    profissionais.add(profissional);
  }

  void exibirDuracaoDisponibilidade(){
    for (Agendamento profissional in profissionais) {
      profissional.calculaDuracaoConsulta();
      profissional.verificaDisponibilidade();
    }
  }
  
}