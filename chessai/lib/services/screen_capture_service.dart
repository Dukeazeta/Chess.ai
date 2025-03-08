import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class ScreenCaptureService {
  static final ScreenCaptureService _instance = ScreenCaptureService._internal();
  factory ScreenCaptureService() => _instance;
  ScreenCaptureService._internal();

final ScreenshotController _screenshotController = ScreenshotController();
  bool _isCapturing = false;
  StreamController<String>? _captureStreamController;
  Stream<String>? captureStream;

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> startForegroundService() async {
    await FlutterForegroundService.startForegroundService(
      title: "Screen Capture",
      content: "Capturing screen for analysis",
      iconName: "ic_launcher",
    );
  }

  Future<void> stopForegroundService() async {
    await FlutterForegroundService.stopForegroundService();
  }

  Future<bool> startCapture(BuildContext context) async {
    if (_isCapturing) return true;

    bool hasPermissions = await requestPermissions();
    if (!hasPermissions) return false;

    await startForegroundService();

    // Create a stream controller for capture events
    _captureStreamController = StreamController<String>.broadcast();
    captureStream = _captureStreamController?.stream;

    // Start media projection
    bool started = await _mediaProjection.startProjection();
    if (!started) {
      await stopForegroundService();
      return false;
    }

    _isCapturing = true;
    _startCaptureLoop();
    return true;
  }

  void _startCaptureLoop() async {
    if (!_isCapturing) return;

    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (!_isCapturing) {
        timer.cancel();
        return;
      }

      try {
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final path = '${directory.path}/screen_$timestamp.jpg';

        await _mediaProjection.captureScreen(path);
        _captureStreamController?.add(path);
      } catch (e) {
        debugPrint('Error capturing screen: $e');
      }
    });
  }

  Future<void> stopCapture() async {
    if (!_isCapturing) return;

    _isCapturing = false;
    await _mediaProjection.stopProjection();
    await stopForegroundService();
    await _captureStreamController?.close();
    _captureStreamController = null;
  }

  bool get isCapturing => _isCapturing;
}