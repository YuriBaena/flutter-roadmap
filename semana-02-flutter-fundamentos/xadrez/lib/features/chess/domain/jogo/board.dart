import '../pecas/pecas.dart';

class Posicao {
  Peca? _peca;

  Posicao(this._peca);
  Posicao.vazia() : _peca = null;

  String? mostrarPeca() => _peca?.show();

  void adicionarPeca(Peca p) {
    _peca = p;
  }

  void removerPeca() {
    _peca = null;
  }

  List<Movimento> verMovimentos(Board tabuleiro) {
    return _peca?.mostrarPossibilidades(tabuleiro) ?? [];
  }

  bool get isEmpty => _peca == null;
  Peca? get peca => _peca;
  Cor? get cor => _peca?.cor;
}

class Board {
  final List<List<Posicao>> tabuleiro;

  Board.start()
    : tabuleiro = List.generate(
        8,
        (_) => List.generate(8, (_) => Posicao.vazia()),
      ) {
    _inicializar();
  }

  void _inicializar() {
    _inicializarPecas(Cor.branca);
    _inicializarPecas(Cor.preta);
  }

  void _inicializarPecas(Cor cor) {
    final linhaPrincipal = cor == Cor.branca ? 7 : 0;
    final linhaPeoes = cor == Cor.branca ? 6 : 1;
    final pecas = [
      Torre(x: linhaPrincipal, y: 0, cor: cor),
      Cavalo(x: linhaPrincipal, y: 1, cor: cor),
      Bispo(x: linhaPrincipal, y: 2, cor: cor),
      Rainha(x: linhaPrincipal, y: 3, cor: cor),
      Rei(x: linhaPrincipal, y: 4, cor: cor),
      Bispo(x: linhaPrincipal, y: 5, cor: cor),
      Cavalo(x: linhaPrincipal, y: 6, cor: cor),
      Torre(x: linhaPrincipal, y: 7, cor: cor),
    ];

    for (var coluna = 0; coluna < 8; coluna++) {
      tabuleiro[linhaPrincipal][coluna] = Posicao(pecas[coluna]);
      tabuleiro[linhaPeoes][coluna] = Posicao(
        Peao(x: linhaPeoes, y: coluna, cor: cor),
      );
    }
  }

  bool _dentroDoTabuleiro(int x, int y) {
    return x >= 0 && x < 8 && y >= 0 && y < 8;
  }

  bool temPeca(int x, int y) {
    return _dentroDoTabuleiro(x, y) && !tabuleiro[x][y].isEmpty;
  }

  Cor? corPeca(int x, int y) {
    if (!_dentroDoTabuleiro(x, y)) return null;
    return tabuleiro[x][y].cor;
  }

  Posicao checarPosicao(int x, int y) {
    return tabuleiro[x][y];
  }

  Peca? atualizarPosicao(int px, int py, int fx, int fy) {
    if (!_dentroDoTabuleiro(px, py) || !_dentroDoTabuleiro(fx, fy)) {
      return null;
    }
    final pecaAMover = tabuleiro[px][py].peca;
    final alvo = tabuleiro[fx][fy].peca;
    if (pecaAMover == null || alvo?.cor == pecaAMover.cor) return null;

    tabuleiro[px][py].removerPeca();
    pecaAMover.mover(fx, fy);
    tabuleiro[fx][fy].adicionarPeca(pecaAMover);
    return alvo;
  }
}
