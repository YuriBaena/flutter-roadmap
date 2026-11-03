import 'peca.dart';
import '../jogo/board.dart';

class Rainha extends Peca {
  Rainha({required int x, required int y, required Cor cor}) : super(x, y, cor);

  @override
  List<Movimento> mostrarPossibilidades(Board tabuleiro) {
    return movimentosNasDirecoes(
      tabuleiro,
      x,
      y,
      cor,
      [
        (0, 1),
        (0, -1),
        (1, 0),
        (-1, 0),
        (1, 1),
        (-1, -1),
        (1, -1),
        (-1, 1),
      ],
    );
  }

  @override
  String show() => cor == Cor.branca ? ' ♕ ' : ' ♛ ';
}
