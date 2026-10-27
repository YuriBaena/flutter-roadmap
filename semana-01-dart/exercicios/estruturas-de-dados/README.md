
# 🚀 Semana 1: Dart - Guia de Fundamentos e Coleções

Este documento serve como um resumo prático dos principais conceitos, tipos de dados e métodos da linguagem **Dart** abordados durante o início da jornada de desenvolvimento Flutter.

---

## 🏛️ 1. Estrutura Básica de um Programa
Diferente de C/C++, o ponto de entrada do Dart é a função `main()`, que tipicamente retorna `void` e não exige `return 0`.

```dart
void main() {
  print('Olá, Dart!');
}

```

---

## 📦 2. Tipos de Dados e Variáveis

### Tipos Primitivos

* **`int`**: Números inteiros (64-bit / 8 bytes no ambiente nativo/mobile).
* **`double`**: Números de ponto flutuante (decimais).
* **`String`**: Textos em codificação UTF-16.
* **`bool`**: Valores booleanos (`true` ou `false`).

### Palavras-chave de Declaração

* **`var`**: O Dart infere o tipo automaticamente no momento da atribuição (imutável em tipo após definido).
* **`final`**: Valor atribuído uma única vez em tempo de execução (*runtime*).
* **`const`**: Constante absoluta em tempo de compilação (*compile-time*), excelente para otimização de Widgets no Flutter.

---

## 📋 3. Estruturas de Dados (Coleções)

### A. `List<T>` (Listas Ordenadas)

Permite armazenar elementos em sequência e aceita duplicatas.

* **Criar com tamanho padrão:** `List<int> lista = List.filled(5, 0, growable: true);`
* **Tamanho:** `lista.length`
* **Verificar se está vazia:** `lista.isEmpty` ou `lista.isNotEmpty`

#### Principais Métodos de Listas:

* **`.add(item)`**: Adiciona um item ao final da lista.
* **`.where((item) => condição)`**: Filtra elementos retornando um `Iterable` (geralmente convertido com `.toList()`).
* **`.map((item) => transformação)`**: Transforma cada elemento da lista.
* **`.sort((a, b) => ...)`**: Ordena a lista (in-place).
* Exemplo numérico crescente: `numeros.sort((a, b) => a - b);`
* Exemplo numérico decrescente: `numeros.sort((a, b) => b - a);`



---

### B. `Map<K, V>` (Pares Chave-Valor)

Associa uma chave única a um valor. Essencial para consumo de APIs (JSON).

```dart
Map<String, dynamic> usuario = {
  'nome': 'Carlos',
  'idade': 28,
};

```

#### Principais Métodos e Acessos:

* **Acesso por chave:** `usuario['nome']`
* **Adicionar/Atualizar:** `usuario['ativo'] = true;`
* **Verificar chave:** `usuario.containsKey('idade');`
* **Percorrer:** `usuario.forEach((chave, valor) { ... });`

---

### C. `Set<T>` (Conjuntos Únicos)

Armazena elementos sem repetição. Mantém a ordem de inserção (*LinkedHashSet*), mas não aceita acesso por índice (ex: `meuSet[0]` não existe).

* **Criar e remover duplicatas:**
```dart
List<String> repetidos = ['a', 'b', 'a'];
Set<String> unicos = repetidos.toSet(); // {'a', 'b'}

```


* **Operações matemáticas:** `.union()`, `.intersection()`, `.difference()`.

---

## 🔤 4. Interpolação de Strings

Esqueça o uso excessivo de `+` para juntar textos. No Dart, usamos o cifrão (`$`) para injetar variáveis ou expressões diretamente nas strings:

```dart
String nome = 'Ana';
double preco = 19.99;

// Interpolação simples e com expressões
print('Cliente: $nome \vert{} Total: R\$${preco * 2}');

// Formatando casas decimais
print('Preço formatado: ${preco.toStringAsFixed(2)}');

```

---

## 💻 5. Executando no WSL / Terminal

Para rodar qualquer arquivo de script Dart diretamente no terminal:

```bash
dart nome_do_arquivo.dart

```

```

```