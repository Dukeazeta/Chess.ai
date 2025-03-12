import 'package:flutter/material.dart';

class FloatingChessWindow extends StatefulWidget {
  const FloatingChessWindow({super.key});

  @override
  State<FloatingChessWindow> createState() => _FloatingChessWindowState();
}

class _FloatingChessWindowState extends State<FloatingChessWindow> {
  Offset _position = const Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position = Offset(
              (_position.dx + details.delta.dx).clamp(0, size.width - 50),
              (_position.dy + details.delta.dy).clamp(0, size.height - 50),
            );
          });
        },
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
    );
  }
}
