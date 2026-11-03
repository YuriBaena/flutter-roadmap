import 'peca.dart';
import '../jogo/board.dart';

class Bispo extends Peca {
  Bispo({required int x, required int y, required Cor cor}) : super(x, y, cor);

  @override
  List<Movimento> mostrarPossibilidades(Board tabuleiro) {
    return movimentosNasDirecoes(
      tabuleiro,
      x,
      y,
      cor,
      [(1, 1), (-1, -1), (1, -1), (-1, 1)],
    );
  }

  @override
  String show() => cor == Cor.branca ? ' ♗ ' : ' ♝ ';
}
