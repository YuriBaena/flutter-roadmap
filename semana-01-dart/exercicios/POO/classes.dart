abstract class AnimalFactory {
    Animal createReproductor(String nome, String habitat);
}

class CachorroFactory extends AnimalFactory {
    CachorroFactory();

    @override
    Animal createReproductor(String nome, String habitat){
        return Cachorro(nome, habitat);
    }
}

class GatoFactory extends AnimalFactory {
    GatoFactory();

    @override
    Animal createReproductor(String nome, String habitat){
        return Gato(nome, habitat);
    }
}

class PassaroFactory extends AnimalFactory {
    PassaroFactory();

    @override
    Animal createReproductor(String nome, String habitat){
        return Passaro(nome, habitat);
    }
}

class PeixeFactory extends AnimalFactory {
    PeixeFactory();

    @override
    Animal createReproductor(String nome, String habitat){
        return Peixe(nome, habitat);
    }
}

abstract class Animal{
    String _nome;
    String _habitat;

    Animal(this._nome, this._habitat);

    String emitirSom();

    String getNome(){
        return this._nome;
    }

}

class Cachorro extends Animal{
    Cachorro(String nome, String habitat) : super(nome, habitat);
    
    @override
    String emitirSom(){
        return 'Au-Au';
    }
}

class Gato extends Animal{
    Gato(String nome, String habitat) : super(nome, habitat);
    
    @override
    String emitirSom(){
        return 'Miau';
    }
}

class Passaro extends Animal{
    Passaro(String nome, String habitat) : super(nome, habitat);
    
    @override
    String emitirSom(){
        return 'Fiu-Fiu';
    }
}

class Peixe extends Animal{
    Peixe(String nome, String habitat) : super(nome, habitat);
    
    @override
    String emitirSom(){
        return 'Glob-Glub';
    }
}

void main(){

    List<(String, String, String)> meus_animais = [
        ('Cachorro', 'Bob', 'Apartamento'),
        ('Gato', 'Mingau', 'Ruas'),
        ('Passaro', 'Joaquin', 'Lagoa'),
        ('Peixe', 'Tonhao', 'Mar-Azul')
    ];
    Map<String, AnimalFactory> nomes_animais = {
        'Cachorro': CachorroFactory(),
        'Gato': GatoFactory(),
        'Passaro': PassaroFactory(),
        'Peixe': PeixeFactory()
    };
    List<Animal> animais = [];

    for(var (especie, nome, habitat) in meus_animais){
        var animal_atual = nomes_animais[especie]!.createReproductor(nome, habitat);
        animais.add(animal_atual);
    }

    for(var atual in animais){
        print('O ${atual.getNome()} faz ${atual.emitirSom()}');
    }

}