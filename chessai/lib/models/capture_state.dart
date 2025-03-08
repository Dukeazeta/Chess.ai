import 'dart:io';
import 'package:flutter/material.dart';
import '../services/screen_capture_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CaptureState extends ChangeNotifier {
  final ScreenCaptureService _captureService = ScreenCaptureService();
  String? _latestCapturePath;
  bool _isProcessing = false;

  String? get latestCapturePath => _latestCapturePath;
  bool get isCapturing => _captureService.isCapturing;
  bool get isProcessing => _isProcessing;

  Future<bool> startCapture(BuildContext context) async {
    bool started = await _captureService.startCapture(context);
    
    if (started) {
      _captureService.captureStream?.listen((path) {
        _latestCapturePath = path;
        _processImage(path);
        notifyListeners();
      });
    }
    
    notifyListeners();
    return started;
  }

  Future<void> stopCapture() async {
    await _captureService.stopCapture();
    notifyListeners();
  }

  void _processImage(String path) async {
    _isProcessing = true;
    notifyListeners();

    // Here you would implement your chess board detection and analysis
    // For example:
    // 1. Detect chess board from the captured image
    // 2. Recognize pieces and their positions
    // 3. Analyze the position with a chess engine

    // Simulate processing delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    _isProcessing = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _captureService.stopCapture();
    super.dispose();
  }
}