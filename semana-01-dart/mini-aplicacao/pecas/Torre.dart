import 'Ipeca.dart';
import '../jogo/Board.dart';

class Torre extends Peca{
    Torre({
        required int x,
        required int y,
        required Cor cor
    }) : super(x, y, cor);

    @override
    List<Movimento> mostrarPossibilidades(Board tabuleiro){
        List<Movimento> possibilidades = [];
        _adicionarMovimento(possibilidades, x, y, (x) => x, (y) => y+1, (x, y) => (y <= 7), tabuleiro);
        _adicionarMovimento(possibilidades, x, y, (x) => x, (y) => y-1, (x, y) => (y >= 0), tabuleiro);
        _adicionarMovimento(possibilidades, x, y, (x) => x+1, (y) => y, (x, y) => (x <= 7), tabuleiro);
        _adicionarMovimento(possibilidades, x, y, (x) => x-1, (y) => y, (x, y) => (x >= 0), tabuleiro);
        return possibilidades;
    }

    @override
    String show(){
        if(this.cor == Cor.branca) return ' ♖ ';
        else return ' ♜ ';
    }

    void _adicionarMovimento(List<Movimento> lista, int x, int y, int Function(int) fx, int Function(int) fy, bool Function(int, int) cond, Board tabuleiro){
        Movimento novo;
        x = fx(x);
        y = fy(y);
        while(cond(x, y)){
            novo = Movimento(x, y);
            if(!tabuleiro.temPeca(x, y))lista.add(novo);
            else if(tabuleiro.corPeca(x,y) != cor){
                lista.add(novo);
                break;
            }
            else break;
            x = fx(x); y = fy(y);
        }
    }
}