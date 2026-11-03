import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../chess/domain/jogo/jogo.dart';
import '../chess/domain/pecas/pecas.dart';
import 'chess_square.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  final Jogo jogo = Jogo.iniciar();
  int? selectedRow;
  int? selectedCol;
  List<Movimento> possibleMoves = [];

  String? _pieceAt(int row, int col) {
    return jogo.xadrez.checarPosicao(row, col).mostrarPeca();
  }

  void _onSquareTap(int row, int col) {
    setState(() {
      if (possibleMoves.any((move) => move.x == row && move.y == col)) {
        final from = _toAlgebraic(selectedRow!, selectedCol!);
        final to = _toAlgebraic(row, col);
        jogo.executarMovimento(from, to);
        selectedRow = null;
        selectedCol = null;
        possibleMoves = [];
        return;
      }

      if (jogo.xadrez.corPeca(row, col) == jogo.vez) {
        selectedRow = row;
        selectedCol = col;
        possibleMoves = jogo.movimentosPossiveis(row, col);
      } else {
        selectedRow = null;
        selectedCol = null;
        possibleMoves = [];
      }
    });
  }

  String _toAlgebraic(int row, int col) {
    return '${String.fromCharCode('a'.codeUnitAt(0) + col)}${8 - row}';
  }

  @override
  Widget build(BuildContext context) {
    final capturadasBrancas = jogo.capturadasPeloBranco
        .map((peca) => peca.show())
        .join();
    final capturadasPretas = jogo.capturadasPeloPreto
        .map((peca) => peca.show())
        .join();

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight - 90;
        final boardSize = math
            .min(constraints.maxWidth, availableHeight)
            .clamp(0.0, constraints.maxWidth)
            .toDouble();

        return SizedBox(
          width: boardSize,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Vez das ${jogo.vez == Cor.branca ? 'brancas' : 'pretas'}'),
              const SizedBox(height: 8),
              SizedBox.square(
                dimension: boardSize,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemCount: 64,
                  itemBuilder: (context, index) {
                    final row = index ~/ 8;
                    final col = index % 8;
                    final piece = _pieceAt(row, col);

                    return ChessSquare(
                      row: row,
                      col: col,
                      isLight: (row + col) % 2 == 0,
                      piece: piece,
                      isSelected: row == selectedRow && col == selectedCol,
                      isPossibleMove: possibleMoves.any(
                        (move) => move.x == row && move.y == col,
                      ),
                      onTap: () => _onSquareTap(row, col),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text('Capturadas pelas brancas:$capturadasBrancas'),
              Text('Capturadas pelas pretas:$capturadasPretas'),
            ],
          ),
        );
      },
    );
  }
}