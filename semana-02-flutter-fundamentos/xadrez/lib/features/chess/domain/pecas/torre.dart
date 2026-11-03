import 'peca.dart';
import '../jogo/board.dart';

class Torre extends Peca {
  Torre({required int x, required int y, required Cor cor}) : super(x, y, cor);

  @override
  List<Movimento> mostrarPossibilidades(Board tabuleiro) {
    return movimentosNasDirecoes(
      tabuleiro,
      x,
      y,
      cor,
      [(0, 1), (0, -1), (1, 0), (-1, 0)],
    );
  }

  @override
  String show() => cor == Cor.branca ? ' ♖ ' : ' ♜ ';
}
