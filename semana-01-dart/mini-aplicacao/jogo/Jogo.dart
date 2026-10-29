import 'dart:io';
import 'Board.dart';
import '../pecas/modelos.dart';

class Jogo{
    late Board xadrez;
    late List<Peca> capturadas_pelo_branco;
    late List<Peca> capturadas_pelo_preto;
    late Cor vez;
    late int movimento;

    Jogo.iniciar(){
        xadrez = Board.start();
        capturadas_pelo_branco = [];
        capturadas_pelo_preto = [];
        vez = Cor.branca;
        movimento = 0;
    }

    void mostrarPossibilidades(String posicao){
        var (x, y) = traduzir(posicao);
        mostrarMovimentos(x, y);
    }

    void mostrarMovimentos(int x, int y){
        if(!xadrez.temPeca(x,y)) return;
        Posicao escolhida = xadrez.checarPosicao(x, y);
        xadrez.mostrarTabuleiro(escolhida.verMovimentos(xadrez), xadrez.corPeca(x,y) != vez);
    }

    void mostrarTabuleiro(){
        xadrez.mostrarTabuleiro([], false);
    }

    bool executarMovimento(String posicao_inicial, String posicao_final){
        var (xi, yi) = traduzir(posicao_inicial);
        var (xf, yf) = traduzir(posicao_final);
        if(xadrez.corPeca(xi,yi) != vez || !xadrez.temPeca(xi,yi) || xi == 8 || yi == 8 || xf == 8 || yf == 8) return false;
        Peca? alvo = xadrez.atualizarPosicao(xi,yi,xf,yf);
        if(alvo != null) _adicionarPecaCapturada(alvo);
        _atualizarVez();
        return true;
    }

    void _adicionarPecaCapturada(Peca capturado){
        if(vez == Cor.branca) capturadas_pelo_branco.add(capturado);
        else capturadas_pelo_preto.add(capturado); 
    }

    _atualizarVez(){
        if(vez == Cor.branca) vez = Cor.preta;
        else vez = Cor.branca;
        movimento++;
    }

    (int, int) traduzir(String posicao){
        String coluna = posicao[0];
        String linha = posicao[1];
        int x, y;
        x = _traduzirX(linha);
        y = _traduzirY(coluna);
        return (x, y);
    }

    int _traduzirX(String x){
        switch(x){
            case '1': return 7;
            case '2': return 6;
            case '3': return 5;
            case '4': return 4;
            case '5': return 3;
            case '6': return 2;
            case '7': return 1;
            case '8': return 0;
            default: return 8;
        }
    }

    int _traduzirY(String y){
        switch(y){
            case 'a': return 0;
            case 'b': return 1;
            case 'c': return 2;
            case 'd': return 3;
            case 'e': return 4;
            case 'f': return 5;
            case 'g': return 6;
            case 'h': return 7;
            default: return 8;
        }
    }

    void mostrarCapturadas(){
        print('Branco: ');
        for(Peca p in capturadas_pelo_branco) stdout.write(p.show());
        print('');
        print('Preto : ');
        for(Peca p in capturadas_pelo_preto) stdout.write(p.show());
        print('');
    }

}

void main(){
    Jogo novo_jogo = Jogo.iniciar();
    novo_jogo.mostrarMovimentos(7, 6);
    novo_jogo.executarMovimento('g1', 'f3');
    novo_jogo.mostrarTabuleiro();
}