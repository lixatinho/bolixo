import 'package:bolixo/flow/sweepstakes/dtoBolao.dart';

class SweepsViewController {
  // construir lista sem acesso ao banco
  List<Bolao> getSweeps() {
    Bolao bolao = new Bolao();
    List<Bolao> lista = [];
    bolao.setIdBolao(1);
    bolao.setName('teste');
    lista.add(bolao);
    bolao.setIdBolao(2);
    bolao.setName('teste 2');
    return lista;
  }
}
