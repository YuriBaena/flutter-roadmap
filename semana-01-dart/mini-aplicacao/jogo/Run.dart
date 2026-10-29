import 'dart:io';
import 'Jogo.dart';

class Run{
    late Jogo partida;
    late bool main_loop = true;

    Run.executar(){
        partida = Jogo.iniciar();
        telaInicial();
        while(main_loop){
            String? resp = _lerEscolha();
            if(resp != null) _executarAcao(resp);
        }
    }

    void telaInicial(){
        print('-------------------------XADREZ-------------------------');
        print('Legenda de funções disponiveis');
        print('Digite:');
        print('1 - Para ver tabuleiro atual.');
        print('2 - Para ver pontuação.');
        print('3 - Para desistir.');
        print('Para jogar: ');
        print('Basta passar a posição atual e de destino da peça.');
        print('O formato é primeiro letra e depois número, ex: d1 e4');
        print('OBS: Brancas começam');
        _mostrarFomatado();
    }

    String? _lerEscolha(){
        String? resposta = stdin.readLineSync();
        return resposta;
    }

    void _executarAcao(String acao){
        switch(acao){
            case '1': 
                _mostrarFomatado();
                partida.mostrarTabuleiro();
                _mostrarFomatado();
                break;
            case '2':
                _mostrarFomatado();
                partida.mostrarCapturadas();
                _mostrarFomatado();
                break;
            case '3':
                main_loop = false;
            // Falta poder ver movimentos possiveis
            default:
                _mostrarFomatado();
                _movimentarOuListarMovimentos(acao);
                _mostrarFomatado();
        }
    }

    void _movimentarOuListarMovimentos(String acao){
        acao.trim();
        List<String> entrada = acao.split(' ');
        if(entrada.length > 1){
            _movimentarPeca(acao);
            partida.mostrarTabuleiro();
        }
        else{
            partida.mostrarPossibilidades(entrada[0]);
        }
    }

    void _movimentarPeca(String posicoes){
        var (p1, p2) = _separarPosicoes(posicoes);
        String lin = '12345678';
        String col = 'abcdefgh';
        if(col.contains(p1[0]) && col.contains(p2[0]) && lin.contains(p1[1]) && lin.contains(p2[1])){
            if(!partida.executarMovimento(p1, p2)){
                print('[ERRO] - Não tem peça na posição ou não existe ou a peça não é sua.');
                _mostrarFomatado();
            }
        }
    }

    (String, String) _separarPosicoes(String posicoes){
        posicoes = posicoes.trim();
        List<String> p = posicoes.split(' ');
        return (p[0], p[1]);
    }

    void _mostrarFomatado(){
        print('--------------------------------------------------------');
    }
}

void main(){
    Run manager = Run.executar();
}