void main(){
    Set<int> precos = {9238, 4637, 826, 12};
    List<int> moedas = [1, 5, 10, 15, 25, 50, 100];
    moedas.sort((a,b){
        if(a < b){
            return 1;
        }
        else if(a > b){
            return -1;
        }
        else return 0;
    });
    
    print('Moedas: $moedas');

    for(int preco in precos){
        List<int> qtd = List.filled(moedas.length, 0);
        int i = 0, p = preco;
        while(p > 0){
            if(p >= moedas[i]){
                p -= moedas[i];
                qtd[i]++;
            }
            else i++;
        }
        print('Segue as quantidades de cada moeda usadas para esse preço: R\$${preco.toStringAsFixed(2)} -> $qtd');
    }
}