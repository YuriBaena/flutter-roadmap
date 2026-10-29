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

  void atualizarPosicao(int px, int py, int fx, int fy){
    if(px >= 8 || px < 0 || py >= 8 || py < 0) return;
    if(fx >= 8 || fx < 0 || fy >= 8 || fy < 0) return;
    Peca? peca_a_mover = tabuleiro[px][py].peca;
    if(peca_a_mover == null) return;
    tabuleiro[px][py].removerPeca();
    peca_a_mover.mover(fx, fy);
    tabuleiro[fx][fy].adicionarPeca(peca_a_mover);
  }

  void mostrarTabuleiro(List<Movimento> moves, bool ataque) {
    List<List<String>> toString = [];
    for (int i = 0; i < 8; i++) {
      toString.add([]);
      for (int j = 0; j < 8; j++) {
        if (temPeca(i, j)) {
          toString[i].add(tabuleiro[i][j].mostrarPeca() ?? ' . ');
        } else {
          toString[i].add(' . ');
        }
      }
    }
    for(var Movimento(x: x, y: y) in moves){
      if(!temPeca(x,y)) toString[x][y] = ' x ';
      else{
        if(!ataque) toString[x][y] = '\x1B[31m' + toString[x][y] + '\x1B[0m';
        else toString[x][y] = '\x1B[32m' + toString[x][y] + '\x1B[0m';
      }
    }
    for(int i = 0; i < 8; i++){
      for(int j = 0; j < 8; j++){
        stdout.write(toString[i][j]);
      }
      stdout.write('\n');
    }
  }
}

void main() {
  final xadrez = Board.start();
  xadrez.atualizarPosicao(0,3,4,5);
  Posicao bispo = xadrez.checarPosicao(4,5);
  xadrez.mostrarTabuleiro(bispo.verMovimentos(xadrez), false);
}