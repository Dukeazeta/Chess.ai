import 'package:flutter/material.dart';
import '../widgets/custom_circular_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Start button (Up arrow)
            CustomCircularButton(
              icon: Icons.arrow_upward,
              color: Colors.green,
              onPressed: () {
                // Start functionality
                print('Start pressed');
              },
              label: 'START',
            ),
            const SizedBox(height: 40),
            // Stop button (Down arrow)
            CustomCircularButton(
              icon: Icons.arrow_downward,
              color: Colors.red,
              onPressed: () {
                // Stop functionality
                print('Stop pressed');
              },
              label: 'STOP',
            ),
          ],
        ),
      ),
    );
  }
}