import '../jogo/board.dart';

class Movimento {
  final int _x;
  final int _y;

  Movimento(this._x, this._y);

  int get x => _x;
  int get y => _y;
}

enum Cor {
  preta('Preta'),
  branca('Branca');

  final String descricao;

  const Cor(this.descricao);
}

abstract class Peca {
  int _x;
  int _y;
  final Cor corPeca;

  Peca(this._x, this._y, this.corPeca);

  void mover(int fx, int fy) {
    _x = fx;
    _y = fy;
  }

  List<Movimento> mostrarPossibilidades(Board tabuleiro);
  String show();

  (int, int) get posicao => (_x, _y);
  int get x => _x;
  int get y => _y;
  set x(int fx) => _x = fx;
  set y(int fy) => _y = fy;
  Cor get cor => corPeca;
}

List<Movimento> movimentosNasDirecoes(
  Board tabuleiro,
  int x,
  int y,
  Cor cor,
  List<(int, int)> direcoes, {
  bool percorreCaminho = true,
}) {
  final movimentos = <Movimento>[];
  for (final (dx, dy) in direcoes) {
    var linha = x + dx;
    var coluna = y + dy;
    while (linha >= 0 && linha < 8 && coluna >= 0 && coluna < 8) {
      if (!tabuleiro.temPeca(linha, coluna)) {
        movimentos.add(Movimento(linha, coluna));
      } else {
        if (tabuleiro.corPeca(linha, coluna) != cor) {
          movimentos.add(Movimento(linha, coluna));
        }
        break;
      }
      if (!percorreCaminho) break;
      linha += dx;
      coluna += dy;
    }
  }
  return movimentos;
}
