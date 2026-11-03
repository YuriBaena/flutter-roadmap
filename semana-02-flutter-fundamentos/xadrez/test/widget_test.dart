import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xadrez/features/chess/domain/jogo/jogo.dart';
import 'package:xadrez/features/chess/domain/pecas/pecas.dart';
import 'package:xadrez/main.dart';

void main() {
  test('o jogo inicia com as peças e o turno das brancas', () {
    final jogo = Jogo.iniciar();

    expect(jogo.xadrez.checarPosicao(7, 4).peca, isA<Rei>());
    expect(jogo.xadrez.checarPosicao(6, 4).peca, isA<Peao>());
    expect(jogo.xadrez.checarPosicao(0, 4).peca, isA<Rei>());
    expect(jogo.vez, Cor.branca);
  });

  test('somente movimentos disponíveis alternam o turno', () {
    final jogo = Jogo.iniciar();

    expect(jogo.executarMovimento('e2', 'e5'), isFalse);
    expect(jogo.vez, Cor.branca);
    expect(jogo.executarMovimento('e2', 'e4'), isTrue);
    expect(jogo.vez, Cor.preta);
    expect(jogo.xadrez.checarPosicao(4, 4).peca, isA<Peao>());
  });

  testWidgets('o tabuleiro exibe as peças e permite mover um peão', (
    tester,
  ) async {
    await tester.pumpWidget(const ChessApp());

    expect(find.text('Vez das brancas'), findsOneWidget);
    expect(find.text(' ♙ '), findsNWidgets(8));

    await tester.tap(find.byKey(const ValueKey('square-6-4')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('square-4-4')));
    await tester.pump();

    expect(find.text('Vez das pretas'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('square-4-4')),
        matching: find.text(' ♙ '),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('square-6-4')),
        matching: find.text(' ♙ '),
      ),
      findsNothing,
    );
  });
}
