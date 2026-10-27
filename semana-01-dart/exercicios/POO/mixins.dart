mixin Autentication{
    String get nome;
    void logar() => print('$nome está logando...');
    void deslogar() => print('$nome está saindo...');
}

class Usuario with Autentication{
    String _nome;
    int _idade;

    Usuario(this._nome, this._idade);

    String get nome => this._nome;
}

void main(){
    Usuario yuri = Usuario('Yuri', 22);
    yuri.logar();
    yuri. deslogar();
}