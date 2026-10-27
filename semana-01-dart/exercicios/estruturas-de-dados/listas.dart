void main(){
    List<int> numeros = [1,2,3,4,5];
    print(numeros);
    // Metódos essenciais
    //--------------------------------------------------------------
    numeros.add(6);
    print("Adicionei mais um número: ");
    print(numeros);
    
    //--------------------------------------------------------------
    numeros.remove(1);
    print("Removi um número: ");
    print(numeros);

    //--------------------------------------------------------------
    List<int> filtrado = numeros
                            .where((x) => x%2==0)
                            .toList();
    print("Filtrei: ");
    print(filtrado);

    //--------------------------------------------------------------
    print("Mostra primos de 1 ate 100");
    descobrirPrimos();

}

void descobrirPrimos(){
    const int limite = 100;
    List<bool> primos = List.filled(limite, true);
    List<int> p = [];

    primos[0] = primos[1] = false;

    for(int i = 2; i*i < limite; i++){
        if(primos[i]){
            for(int j = i*i; j < limite; j+=i) primos[j] = false;
        }
    }
    
    for(int i = 0; i < limite; i++) if(primos[i]) p.add(i);

    p.sort((a, b) => b.compareTo(a));

    print(p);
}