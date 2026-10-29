import 'dart:io';
import '../pecas/modelos.dart';

class Posicao {
  bool _ocupada = false;
  Peca? _peca;

  Posicao(this._peca) : _ocupada = _peca != null;

  Posicao.vazia() : _peca = null, _ocupada = false;
  
  String? mostrarPeca() {
    return _peca?.show();
  }

  void adicionarPeca(Peca p){
    _ocupada = true;
    _peca = p;
  }

  void removerPeca(){
    _peca = null;
    _ocupada = false;
  }

  List<Movimento> verMovimentos(Board tabuleiro){
    if(_peca == null) return [];
    else return _peca!.mostrarPossibilidades(tabuleiro);
  }

  bool get isEmpty => !_ocupada;
  Peca? get peca => _peca;
  Cor? get cor => _peca?.cor;
}

class Board {
  List<List<Posicao>> tabuleiro = [];

  Board.start() {
    tabuleiro = List.generate(
      8,
      (_) => List.generate(8, (_) => Posicao.vazia()),
    );
    _inicializar();
  }

  void _inicializar() {
    _inicializarPecas(Cor.branca);
    _inicializarPecas(Cor.preta);
  }

  void _inicializarPecas(Cor cor) {
    if (cor == Cor.branca) {
      final pecas = [
        Torre   (x: 7, y: 0, cor: Cor.branca),
        Cavalo  (x: 7, y: 1, cor: Cor.branca),
        Bispo   (x: 7, y: 2, cor: Cor.branca),
        Rainha  (x: 7, y: 3, cor: Cor.branca),
        Rei     (x: 7, y: 4, cor: Cor.branca),
        Bispo   (x: 7, y: 5, cor: Cor.branca),
        Cavalo  (x: 7, y: 6, cor: Cor.branca),
        Torre   (x: 7, y: 7, cor: Cor.branca),
      ];

      for (int i = 0; i < pecas.length; i++) {
        tabuleiro[7][i] = Posicao(pecas[i]);
      }

      for (int i = 0; i < 8; i++) {
        tabuleiro[6][i] = Posicao(Peao(x: 6, y: i, cor: Cor.branca));
      }
    } else {
      final pecas = [
        Torre   (x: 0, y: 0, cor: Cor.preta),
        Cavalo  (x: 0, y: 1, cor: Cor.preta),
        Bispo   (x: 0, y: 2, cor: Cor.preta),
        Rainha  (x: 0, y: 3, cor: Cor.preta),
        Rei     (x: 0, y: 4, cor: Cor.preta),
        Bispo   (x: 0, y: 5, cor: Cor.preta),
        Cavalo  (x: 0, y: 6, cor: Cor.preta),
        Torre   (x: 0, y: 7, cor: Cor.preta),
      ];

      for (int i = 0; i < pecas.length; i++) {
        tabuleiro[0][i] = Posicao(pecas[i]);
      }

      for (int i = 0; i < 8; i++) {
        tabuleiro[1][i] = Posicao(Peao(x: 1, y: i, cor: Cor.preta));
      }
    }
  }

  bool temPeca(int x, int y) {
    return !tabuleiro[x][y].isEmpty;
  }

  Cor? corPeca(int x, int y){
    return tabuleiro[x][y].cor;
  }

  Posicao checarPosicao(int x, int y){
    return tabuleiro[x][y];
  }

  Peca? atualizarPosicao(int px, int py, int fx, int fy){
    if(px >= 8 || px < 0 || py >= 8 || py < 0) return null;
    if(fx >= 8 || fx < 0 || fy >= 8 || fy < 0) return null;
    Peca? peca_a_mover = tabuleiro[px][py].peca;
    Peca? antiga = tabuleiro[fx][fy].peca;
    if(peca_a_mover == null) return null;
    tabuleiro[px][py].removerPeca();
    peca_a_mover.mover(fx, fy);
    tabuleiro[fx][fy].adicionarPeca(peca_a_mover);
    return antiga;
  }

  void mostrarTabuleiro(List<Movimento> moves, bool ataque) {
    final casas = List.generate(
      8,
      (linha) => List.generate(
        8,
        (coluna) => tabuleiro[linha][coluna].mostrarPeca() ?? ' . ',
      ),
    );

    for (final movimento in moves) {
      final linha = movimento.x;
      final coluna = movimento.y;
      final casa = casas[linha][coluna];

      if (!temPeca(linha, coluna)) {
        casas[linha][coluna] = '\x1B[33m x \x1B[0m';
      } else {
        final cor = ataque ? '32' : '31';
        casas[linha][coluna] = '\x1B[${cor}m$casa\x1B[0m';
      }
    }

    for (int i = 0; i < 8; i++) {
      stdout.write('${8 - i}  ');
      for (int j = 0; j < 8; j++) {
        stdout.write(casas[i][j]);
      }
      stdout.write('\n');
    }

    stdout.write('   ');
    for (int coluna = 0; coluna < 8; coluna++) {
      stdout.write(' ${String.fromCharCode(97 + coluna)} ');
    }
    stdout.write('\n');
  }
}

void main() {
  final xadrez = Board.start();
  xadrez.atualizarPosicao(0,3,4,5);
  Posicao bispo = xadrez.checarPosicao(4,5);
  xadrez.mostrarTabuleiro(bispo.verMovimentos(xadrez), false);
}