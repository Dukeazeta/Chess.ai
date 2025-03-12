import 'package:flutter/material.dart';

class ChessPieceIcon extends StatelessWidget {
  final String piece;
  final Color color;
  final double size;

  const ChessPieceIcon({
    super.key,
    required this.piece,
    required this.color,
    this.size = 45,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      piece,
      style: TextStyle(
        fontSize: size,
        color: Colors.white,
        fontFamily: 'Chess',
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}