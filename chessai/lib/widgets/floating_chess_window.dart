import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/floating_window_provider.dart';

class FloatingChessWindow extends StatelessWidget {
  const FloatingChessWindow({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<FloatingWindowProvider>(context);
    
    return Positioned(
      left: provider.position.dx,
      top: provider.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          final newPosition = Offset(
            (provider.position.dx + details.delta.dx).clamp(0, size.width - 50),
            (provider.position.dy + details.delta.dy).clamp(0, size.height - 50),
          );
          provider.updatePosition(newPosition);
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
