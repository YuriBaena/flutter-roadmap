import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ChessSquare extends StatelessWidget {
  final int row;
  final int col;
  final bool isLight;
  final String? piece;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isPossibleMove;

  const ChessSquare({
    super.key,
    required this.row,
    required this.col,
    required this.isLight,
    required this.piece,
    required this.onTap,
    this.isSelected = false,
    this.isPossibleMove = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('square-$row-$col'),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isLight ? AppColors.lightSquare : AppColors.darkSquare,
          border: isSelected
              ? Border.all(color: Colors.amber, width: 3)
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isPossibleMove && piece == null)
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
              ),
            if (isPossibleMove && piece != null)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.redAccent, width: 3),
                  shape: BoxShape.circle,
                ),
              ),
            if (piece != null)
              Text(
                piece!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}