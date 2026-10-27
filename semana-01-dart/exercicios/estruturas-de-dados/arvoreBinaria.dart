class ArvoreBinaria {
  String _tipo;
  int? _valor;
  late ArvoreBinaria esq;
  late ArvoreBinaria dir;

  ArvoreBinaria(this._tipo, [this._valor, ArvoreBinaria? esq, ArvoreBinaria? dir]) {
    this.esq = esq ?? folha;
    this.dir = dir ?? folha;
  }

  ArvoreBinaria._folha() : _tipo = 'Folha', _valor = null;
  static final ArvoreBinaria folha = ArvoreBinaria._folha();

  void adicionarEsq(ArvoreBinaria esq) {
    this.esq = esq;
  }

  void adicionarDir(ArvoreBinaria dir) {
    this.dir = dir;
  }

  String get tipo => _tipo;
  int get valor => _valor ?? 0;
  ArvoreBinaria get e => esq;
  ArvoreBinaria get d => dir;
}

void main(){
    ArvoreBinaria arv = ArvoreBinaria('Galho', 5);
    ArvoreBinaria a1 = ArvoreBinaria('Galho', 2);
    ArvoreBinaria a2 = ArvoreBinaria('Galho', 3);
    ArvoreBinaria a3 = ArvoreBinaria('Galho', 4);
    ArvoreBinaria a4 = ArvoreBinaria('Galho', 1);

    a3.adicionarDir(a4);
    a2.adicionarEsq(a3);
    arv.adicionarEsq(a1);
    arv.adicionarDir(a2);

    percorrerArvore(arv);
    
}

void percorrerArvore(ArvoreBinaria a){
    if(a.tipo == 'Folha') return;
    else{
        print(a.valor);
        percorrerArvore(a.e);
        percorrerArvore(a.d);
    }
}