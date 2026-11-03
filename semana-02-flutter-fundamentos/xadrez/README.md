# Xadrez

Aplicativo Flutter que reaproveita o motor de xadrez desenvolvido na semana 1.

## Organização

- `lib/features/chess/domain/pecas/`: peças, cores e movimentos; não depende do Flutter.
- `lib/features/chess/domain/jogo/`: tabuleiro e controle da partida.
- `lib/features/widgets/`: interface do tabuleiro e casas.
- `lib/features/views/`: tela da partida.

O motor foi copiado e adaptado para dentro de `lib/`, mantendo os arquivos da
semana 1 intactos. `Run.dart` não foi integrado porque contém a interface de
terminal (`stdin`/`stdout`); no app, os toques na tela selecionam e movimentam
as peças.

As regras atuais validam os movimentos de cada peça, capturas e alternância de
turno. Xeque, xeque-mate, roque, en passant e promoção ainda não estão
implementados.
