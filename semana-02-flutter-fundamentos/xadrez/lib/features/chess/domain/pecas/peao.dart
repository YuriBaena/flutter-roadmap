import 'peca.dart';
import '../jogo/board.dart';

class Peao extends Peca {
  bool primeiroMovimento = true;

  Peao({required int x, required int y, required Cor cor}) : super(x, y, cor);

  @override
  void mover(int fx, int fy) {
    super.mover(fx, fy);
    primeiroMovimento = false;
  }

  @override
  List<Movimento> mostrarPossibilidades(Board tabuleiro) {
    final moves = <Movimento>[];
    final direcao = cor == Cor.branca ? -1 : 1;
    final proximaLinha = x + direcao;

    if (proximaLinha >= 0 &&
        proximaLinha < 8 &&
        !tabuleiro.temPeca(proximaLinha, y)) {
      moves.add(Movimento(proximaLinha, y));
      final linhaDupla = x + 2 * direcao;
      if (primeiroMovimento &&
          linhaDupla >= 0 &&
          linhaDupla < 8 &&
          !tabuleiro.temPeca(linhaDupla, y)) {
        moves.add(Movimento(linhaDupla, y));
      }
    }

    for (final coluna in [y - 1, y + 1]) {
      if (proximaLinha >= 0 &&
          proximaLinha < 8 &&
          coluna >= 0 &&
          coluna < 8 &&
          tabuleiro.temPeca(proximaLinha, coluna) &&
          tabuleiro.corPeca(proximaLinha, coluna) != cor) {
        moves.add(Movimento(proximaLinha, coluna));
      }
    }
    return moves;
  }

  @override
  String show() => cor == Cor.branca ? ' ♙ ' : ' ♟ ';
}
