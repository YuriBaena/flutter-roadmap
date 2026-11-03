import 'peca.dart';
import '../jogo/board.dart';

class Cavalo extends Peca {
  Cavalo({required int x, required int y, required Cor cor}) : super(x, y, cor);

  @override
  List<Movimento> mostrarPossibilidades(Board tabuleiro) {
    return movimentosNasDirecoes(
      tabuleiro,
      x,
      y,
      cor,
      [
        (1, 2),
        (1, -2),
        (-1, 2),
        (-1, -2),
        (2, 1),
        (2, -1),
        (-2, 1),
        (-2, -1),
      ],
      percorreCaminho: false,
    );
  }

  @override
  String show() => cor == Cor.branca ? ' ♘ ' : ' ♞ ';
}
