import 'package:flutter/material.dart';

class ChessOverlayWidget extends StatefulWidget {
  const ChessOverlayWidget({Key? key}) : super(key: key);

  @override
  State<ChessOverlayWidget> createState() => _ChessOverlayWidgetState();
}

class _ChessOverlayWidgetState extends State<ChessOverlayWidget> {
  Offset _position = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
        },
        child: AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
          left: _position.dx,
          top: _position.dy,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.sports_esports,
                size: 25,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}