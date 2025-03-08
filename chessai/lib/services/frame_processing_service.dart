import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:chess_move_detection/util/move_detection_util.dart';

class FrameProcessingService {
  static final FrameProcessingService _instance = FrameProcessingService._internal();
  factory FrameProcessingService() => _instance;
  FrameProcessingService._internal();

  String? _lastProcessedFrame;
  bool _isProcessing = false;
  StreamController<Map<String, dynamic>>? _moveDetectionController;
  Stream<Map<String, dynamic>>? moveDetectionStream;

  // Initialize the frame processing service
  void initialize() {
    _moveDetectionController = StreamController<Map<String, dynamic>>.broadcast();
    moveDetectionStream = _moveDetectionController?.stream;
  }

  // Process a new frame from the screen capture service
  Future<void> processFrame(String imagePath) async {
    // Skip if already processing a frame
    if (_isProcessing) return;
    
    // Skip if this is the same frame as last time
    if (_lastProcessedFrame == imagePath) return;
    
    _isProcessing = true;
    _lastProcessedFrame = imagePath;
    
    try {
      // Load the image
      final File imageFile = File(imagePath);
      final List<int> imageBytes = await imageFile.readAsBytes();
      final img.Image? image = img.decodeImage(imageBytes);
      
      if (image == null) {
        _isProcessing = false;
        return;
      }
      
      // Detect if a move has been made
      final bool moveDetected = await _detectMove(image);
      
      if (moveDetected) {
        // If a move is detected, notify listeners
        _moveDetectionController?.add({
          'moveDetected': true,
          'imagePath': imagePath,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
        
        // Save the frame for reference
        await _saveReferenceFrame(imagePath);
      }
    } catch (e) {
      debugPrint('Error processing frame: $e');
    } finally {
      _isProcessing = false;
    }
  }
  // Update the _detectMove method in FrameProcessingService
  
  // Store the previous frame for comparison
  img.Image? _previousFrame;
  
  Future<bool> _detectMove(img.Image currentFrame) async {
    if (_previousFrame == null) {
      _previousFrame = currentFrame;
      return false;
    }
    
    // Calculate the difference between the current and previous frames
    double differencePercentage = MoveDetectionUtil.calculateImageDifference(
      _previousFrame!, 
      currentFrame
    );
    
    // Detect regions of change
    List<Rect> changedRegions = MoveDetectionUtil.detectChangedRegions(
      _previousFrame!, 
      currentFrame
    );
    
    // Determine if the changes represent a chess move
    bool isMoveDetected = MoveDetectionUtil.isChessMove(
      changedRegions, 
      differencePercentage
    );
    
    // Update the previous frame
    _previousFrame = currentFrame;
    
    return isMoveDetected;
  }
  // Save a reference frame when a move is detected
  Future<void> _saveReferenceFrame(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newPath = '${directory.path}/reference_frame_$timestamp.jpg';
      
      final File originalFile = File(imagePath);
      await originalFile.copy(newPath);
      
      debugPrint('Reference frame saved: $newPath');
    } catch (e) {
      debugPrint('Error saving reference frame: $e');
    }
  }

  // Clean up resources
  void dispose() {
    _moveDetectionController?.close();
    _moveDetectionController = null;
  }
}