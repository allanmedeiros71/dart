import 'package:anybank/agenda.dart';

void main() {
  Medico medico = Medico();
  Dentista dentista = Dentista();

  GerenciadorDeAgendamentos gerenciador = GerenciadorDeAgendamentos();
  gerenciador.adicionarProfissional(medico);
  gerenciador.adicionarProfissional(dentista);

  gerenciador.exibirDuracaoDisponibilidade();
}