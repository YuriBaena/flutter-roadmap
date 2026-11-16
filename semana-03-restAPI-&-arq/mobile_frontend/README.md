# mobile_frontend

A new Flutter project.

## Rodar com Docker Compose

Na pasta `semana-03-restAPI-&-arq`, execute:

```sh
docker compose up --build
```

O frontend web ficará disponível em <http://localhost:3000>.

Após o login, o JWT é armazenado com `flutter_secure_storage` e enviado
automaticamente no cabeçalho `Authorization: Bearer <token>` das requisições
HTTP. A opção **Deslogar** remove o token armazenado.

## Carteira de tickers

Na tela inicial, busque um ticker da B3, informe seu preço médio e adicione-o à
carteira. A busca e as cotações passam pelo backend, que consulta a API da
brapi; use o botão de atualização para buscar os preços novamente. O resultado
é mostrado em reais e em percentual por ação ou cota, pois a carteira não
solicita a quantidade de cada ativo. Tickers e preços médios são gravados no
PostgreSQL e associados ao usuário autenticado; cada usuário só lista ou remove
as próprias posições. O backend expõe `GET` e `POST /api/carteira` e
`DELETE /api/carteira/{id}` para essa carteira.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
