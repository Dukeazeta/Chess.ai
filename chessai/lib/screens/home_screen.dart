import 'package:flutter/material.dart';
import '../widgets/custom_circular_button.dart';
import '../widgets/chess_piece_icon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF2C2C2C),
              const Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Start button with King chess piece
              CustomCircularButton(
                customIcon: const ChessPieceIcon(
                  piece: '♔', // Unicode for white king
                  color: Colors.white,
                ),
                color: Colors.green.shade600,
                onPressed: () {
                  // Start functionality
                  print('Start pressed');
                },
                label: 'START',
              ),
              const SizedBox(height: 50),
              // Stop button with Queen chess piece
              CustomCircularButton(
                customIcon: const ChessPieceIcon(
                  piece: '♕', // Unicode for white queen
                  color: Colors.white,
                ),
                color: Colors.red.shade600,
                onPressed: () {
                  // Stop functionality
                  print('Stop pressed');
                },
                label: 'STOP',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
