import 'package:flutter/material.dart';
import '../widgets/custom_circular_button.dart';
import '../widgets/chess_piece_icon.dart';
import '../services/overlay_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _overlayActive = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final hasPermission = await OverlayService.requestPermission();
    if (!hasPermission) {
      // Handle permission denied
    }
  }

  void _toggleOverlay() async {
    if (_overlayActive) {
      await OverlayService.hideOverlay();
    } else {
      await OverlayService.showOverlay();
    }
    
    setState(() {
      _overlayActive = !_overlayActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Container(
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
                onPressed: _toggleOverlay,
                label: _overlayActive ? 'ACTIVE' : 'START',
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
                  if (_overlayActive) {
                    _toggleOverlay();
                  }
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
