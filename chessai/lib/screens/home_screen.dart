import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_circular_button.dart';
import '../widgets/chess_piece_icon.dart';
import '../widgets/floating_chess_window.dart';
import '../providers/floating_window_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FloatingWindowProvider>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2C2C2C),
                  Color(0xFF1A1A1A),
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
                    onPressed: () => provider.toggleVisibility(),
                    label: provider.isVisible ? 'ACTIVE' : 'START',
                  ),
                  const SizedBox(height: 50),
                  // Stop button with Queen chess piece
                  CustomCircularButton(
                    customIcon: const ChessPieceIcon(
                      piece: '♕', // Unicode for white queen
                      color: Colors.white,
                    ),
                    color: Colors.red.shade600,
                    onPressed: provider.isVisible 
                        ? () {
                            provider.hide();
                          } as VoidCallback
                        : () => null,
                    label: 'STOP',
                  ),
                ],
              ),
            ),
          ),
          
          // Floating window with chess icon
          if (provider.isVisible)
            const FloatingChessWindow(),
        ],
      ),
    );
  }
}
