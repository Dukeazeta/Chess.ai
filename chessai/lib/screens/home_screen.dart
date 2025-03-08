import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/capture_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess.ai Screen Capture'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<CaptureState>(
        builder: (context, captureState, child) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: captureState.latestCapturePath != null
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.file(
                              File(captureState.latestCapturePath!),
                              fit: BoxFit.contain,
                            ),
                            if (captureState.isProcessing)
                              const CircularProgressIndicator(),
                          ],
                        )
                      : const Text('No capture yet'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: captureState.isCapturing
                          ? () => captureState.stopCapture()
                          : () => captureState.startCapture(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: captureState.isCapturing
                            ? Colors.red
                            : Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        captureState.isCapturing
                            ? 'Stop Capture'
                            : 'Start Capture',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}