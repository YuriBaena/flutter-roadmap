void main(){
    Map<String, int> pessoas_idades = {
        'Yann': 19,
        'Yuri': 22,
        'Marcio': 53,
        'Alessandra': 55
    };

    pessoas_idades['Isabelle'] = 27;
    pessoas_idades.remove('Marcio');

    if(pessoas_idades.containsKey('Yuri')) print('Temos o melhor.');
    if(pessoas_idades.containsValue(19)) print('Temos um jovem adulto.');

    pessoas_idades['Yuri'] = 23;

    pessoas_idades.forEach(
        (pessoa, idade) {
            const ano_atual = 2026;
            var ano_nascimento = ano_atual - idade;
            print('$pessoa tem $idade anos, ou seja, nasceu em $ano_nascimento');
        }
    );
}
