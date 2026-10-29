import '../jogo/Board.dart';

class Movimento{
    final int _x;
    final int _y;

    Movimento(this._x, this._y);

    @override
    String toString(){
        return '(${this.x}, ${this.y})';
    }

    int get x => this._x;
    int get y => this._y;
}

enum Cor{
    preta('Preta'),
    branca('Branca');

    final String descricao;

    Cor(this.descricao);
}

abstract class Peca{
    int _x;
    int _y;
    Cor cor_peca;

    Peca(this._x, this._y, this.cor_peca);

    void mover(int fx, int fy){
        _x = fx;
        _y = fy;
    }
    List<Movimento> mostrarPossibilidades(Board tabuleiro);
    String show();

    (int, int) get posicao => (this._x, this._y);
    int get x => this._x;
    int get y => this._y;
    set x(int fx){
        _x = fx;
    }
    set y(int fy){
        _y = fy;
    }
    Cor get cor => this.cor_peca;
}