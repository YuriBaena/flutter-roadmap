import 'Ipeca.dart';
import '../jogo/Board.dart';

class Peao extends Peca {

    bool primeiro_movimento = true;

    Peao({
        required int x,
        required int y,
        required Cor cor
    }): super(x,y,cor);

    @override
    void mover(int fx, int fy){
        this.x = fx;
        this.y = fy;
        if(primeiro_movimento) primeiro_movimento = false;
    }

    @override
    List<Movimento> mostrarPossibilidades(Board tabuleiro){
        List<Movimento> moves = [];
        _avancoDuplo(moves, x, y, tabuleiro);
        if(this.cor == Cor.branca){
            _adicionarMovimento(moves, x, y, (x) => x-1, (y) => y, (x, y) => (x>=0 && !tabuleiro.temPeca(x, y)));
            _adicionarMovimento(moves, x, y, (x) => x-1, (y) => y+1, (x, y) => (x>=0 && y<=7 && tabuleiro.temPeca(x, y)));
            _adicionarMovimento(moves, x, y, (x) => x-1, (y) => y-1, (x, y) => (x>=0 && y>=0 && tabuleiro.temPeca(x, y)));
        }
        else{
            _adicionarMovimento(moves, x, y, (x) => x+1, (y) => y, (x, y)   => (x<=7 && !tabuleiro.temPeca(x, y)));
            _adicionarMovimento(moves, x, y, (x) => x+1, (y) => y+1, (x, y) => (x<=7 && y<=7 && tabuleiro.temPeca(x, y)));
            _adicionarMovimento(moves, x, y, (x) => x+1, (y) => y-1, (x, y) => (x<=7 && y>=0 && tabuleiro.temPeca(x, y)));
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

    void _avancoDuplo(List<Movimento> lista, int x, int y, Board tabuleiro){
        if(!primeiro_movimento) return;
        if(this.cor == Cor.branca){
            _adicionarMovimento(lista, x, y, (x) => x-2, (y) => y, (x, y) => (x>=0 && !tabuleiro.temPeca(x, y) && !tabuleiro.temPeca(x+1, y)));
        }
        else{
            _adicionarMovimento(lista, x, y, (x) => x+2, (y) => y, (x, y) => (x>=0 && !tabuleiro.temPeca(x, y) && !tabuleiro.temPeca(x-1, y)));
        }
    }

}