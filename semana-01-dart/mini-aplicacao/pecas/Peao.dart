import 'Ipeca.dart';
import '../jogo/Board.dart';

class Peao extends Peca {

    Peao({
        required int x,
        required int y,
        required Cor cor
    }): super(x,y,cor);

    @override
    List<Movimento> mostrarPossibilidades(Board tabuleiro){
        List<Movimento> moves = [];
        // Temporario
        if(this.cor == Cor.branca){
            _adicionarMovimento(moves, x, y, (x) => x-1, (y) => y, (x, y) => (x>=0 && !tabuleiro.temPeca(x, y)));
        }
        else{
            _adicionarMovimento(moves, x, y, (x) => x+1, (y) => y, (x, y) => (x<=7 && !tabuleiro.temPeca(x, y)));
        }
        return moves;
    }

    @override
    String show(){
        if(this.cor == Cor.branca) return ' ♙ ';
        else return ' ♟ ';
    }

    void _adicionarMovimento(List<Movimento> lista, int x, int y, int Function(int) fx, int Function(int) fy, bool Function(int, int) cond){
        x = fx(x);
        y = fy(y);
        if(cond(x, y)){
            Movimento novo = Movimento(x, y);
            lista.add(novo);
        }
    }

}