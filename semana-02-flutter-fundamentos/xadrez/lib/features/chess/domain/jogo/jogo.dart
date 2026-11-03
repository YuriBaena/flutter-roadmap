import 'board.dart';
import '../pecas/pecas.dart';

class Jogo {
  late final Board xadrez;
  late final List<Peca> capturadasPeloBranco;
  late final List<Peca> capturadasPeloPreto;
  late Cor vez;
  int movimento = 0;

  Jogo.iniciar() {
    xadrez = Board.start();
    capturadasPeloBranco = [];
    capturadasPeloPreto = [];
    vez = Cor.branca;
  }

  List<Movimento> movimentosPossiveis(int x, int y) {
    if (x < 0 ||
        x >= 8 ||
        y < 0 ||
        y >= 8 ||
        xadrez.corPeca(x, y) != vez) {
      return [];
    }
    return xadrez.checarPosicao(x, y).verMovimentos(xadrez);
  }

  bool executarMovimento(String posicaoInicial, String posicaoFinal) {
    if (posicaoInicial.length != 2 || posicaoFinal.length != 2) return false;
    final (xi, yi) = traduzir(posicaoInicial);
    final (xf, yf) = traduzir(posicaoFinal);
    if (!_dentroDoTabuleiro(xi, yi) || !_dentroDoTabuleiro(xf, yf)) {
      return false;
    }

    final peca = xadrez.checarPosicao(xi, yi).peca;
    if (peca == null || peca.cor != vez) return false;

    final movimentos = peca.mostrarPossibilidades(xadrez);
    if (!movimentos.any((movimento) => movimento.x == xf && movimento.y == yf)) {
      return false;
    }

    final capturada = xadrez.atualizarPosicao(xi, yi, xf, yf);
    if (capturada != null) {
      if (vez == Cor.branca) {
        capturadasPeloBranco.add(capturada);
      } else {
        capturadasPeloPreto.add(capturada);
      }
    }
    vez = vez == Cor.branca ? Cor.preta : Cor.branca;
    movimento++;
    return true;
  }

  (int, int) traduzir(String posicao) {
    if (posicao.length != 2) return (8, 8);
    final linha = int.tryParse(posicao[1]);
    final coluna = posicao[0];
    if (linha == null || linha < 1 || linha > 8) return (8, 8);
    final y = coluna.codeUnitAt(0) - 'a'.codeUnitAt(0);
    if (y < 0 || y > 7) return (8, 8);
    return (8 - linha, y);
  }

  bool _dentroDoTabuleiro(int x, int y) {
    return x >= 0 && x < 8 && y >= 0 && y < 8;
  }
}
