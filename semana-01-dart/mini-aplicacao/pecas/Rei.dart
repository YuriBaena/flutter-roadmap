import 'Ipeca.dart';
import '../jogo/Board.dart';

class Rei extends Peca{
    Rei({
        required int x,
        required int y,
        required Cor cor
    }) : super(x, y, cor);

    @override
    List<Movimento> mostrarPossibilidades(Board tabuleiro){
        List<Movimento> possibilidades = [];
        // Horizontal + Vertical
        _adicionarMovimento(possibilidades, x, y, (x) => x, (y) => y+1, (x, y) => (y <= 7 && (!tabuleiro.temPeca(x, y) || tabuleiro.corPeca(x,y) != cor)));
        _adicionarMovimento(possibilidades, x, y, (x) => x, (y) => y-1, (x, y) => (y >= 0 && (!tabuleiro.temPeca(x, y) || tabuleiro.corPeca(x,y) != cor)));
        _adicionarMovimento(possibilidades, x, y, (x) => x+1, (y) => y, (x, y) => (x <= 7 && (!tabuleiro.temPeca(x, y) || tabuleiro.corPeca(x,y) != cor)));
        _adicionarMovimento(possibilidades, x, y, (x) => x-1, (y) => y, (x, y) => (x >= 0 && (!tabuleiro.temPeca(x, y) || tabuleiro.corPeca(x,y) != cor)));

        // Diagonais
        _adicionarMovimento(possibilidades, x, y, (x) => x+1, (y) => y+1, (x, y) => (x <= 7 && y <= 7 && (!tabuleiro.temPeca(x, y) || tabuleiro.corPeca(x,y) != cor)));
        _adicionarMovimento(possibilidades, x, y, (x) => x-1, (y) => y-1, (x, y) => (x >= 0 && y >= 0 && (!tabuleiro.temPeca(x, y) || tabuleiro.corPeca(x,y) != cor)));
        _adicionarMovimento(possibilidades, x, y, (x) => x+1, (y) => y-1, (x, y) => (x <= 7 && y >= 0 && (!tabuleiro.temPeca(x, y) || tabuleiro.corPeca(x,y) != cor)));
        _adicionarMovimento(possibilidades, x, y, (x) => x-1, (y) => y+1, (x, y) => (x >= 0 && y <= 7 && (!tabuleiro.temPeca(x, y) || tabuleiro.corPeca(x,y) != cor)));
        return possibilidades;
    }

    void _adicionarMovimento(List<Movimento> lista, int x, int y, int Function(int) fx, int Function(int) fy, bool Function(int, int) cond){
        x = fx(x);
        y = fy(y);
        if(cond(x, y)){
            Movimento novo = Movimento(x, y);
            lista.add(novo);
        }
    }
    
    @override
    String show(){
        if(this.cor == Cor.branca) return ' ♔ ';
        else return ' ♚ ';
    }
}