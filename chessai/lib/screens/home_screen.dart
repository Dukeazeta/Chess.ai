import 'package:flutter/material.dart';
import '../widgets/custom_circular_button.dart';
import '../widgets/chess_piece_icon.dart';
import '../widgets/floating_chess_window.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showFloatingWindow = false;

  void _toggleFloatingWindow() {
    setState(() {
      _showFloatingWindow = !_showFloatingWindow;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: _toggleFloatingWindow,
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
                      setState(() {
                        _showFloatingWindow = false;
                      });
                    },
                    label: 'STOP',
                  ),
                ],
              ),
            ),
          ),
          
          // Floating window with chess icon
          if (_showFloatingWindow)
            const FloatingChessWindow(),
        ],
      ),
    );
  }
}
