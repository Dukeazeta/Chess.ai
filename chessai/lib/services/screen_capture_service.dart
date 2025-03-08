import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
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
  Timer? _captureTimer;

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.manageExternalStorage,  // Add required Android 11+ permission
      Permission.systemAlertWindow,      // Required for foreground service
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> startForegroundService() async {
    await ForegroundService.setup(
      androidNotification: AndroidNotification(
        channelId: 'screen_capture',
        channelName: 'Screen Capture Service',
        channelDescription: 'Service for capturing screen content',
        priority: AndroidNotificationPriority.DEFAULT,
        icon: 'ic_launcher',
      ),
      iosNotification: const IOSNotification(),
      foregroundServiceOptions: const ForegroundServiceOptions(),
    );
    
    await FlutterForegroundService.start(
      notificationTitle: 'Chess.ai',
      notificationText: 'Capturing screen for analysis',
    );
  }
  Future<void> stopForegroundService() async {
    await FlutterForegroundService.stop();
  }
  Widget wrapWithScreenshotCapture(Widget child) {
    return Screenshot(
      controller: _screenshotController,
      child: child,
    );
  }

  Future<bool> startCapture(BuildContext context) async {
    if (_isCapturing) return true;

    bool hasPermissions = await requestPermissions();
    if (!hasPermissions) return false;

    await startForegroundService();

    // Create a stream controller for capture events
    _captureStreamController = StreamController<String>.broadcast();
    captureStream = _captureStreamController?.stream;

    _isCapturing = true;
    _startCaptureLoop();
    return true;
  }

  void _startCaptureLoop() async {
    if (!_isCapturing) return;

    _captureTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (!_isCapturing) {
        timer.cancel();
        return;
      }

      try {
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final path = '${directory.path}/screen_$timestamp.jpg';

        final Uint8List? imageBytes = await _screenshotController.capture();
        if (imageBytes != null) {
          final File file = File(path);
          await file.writeAsBytes(imageBytes);
          _captureStreamController?.add(path);
        }
      } catch (e) {
        debugPrint('Error capturing screen: $e');
      }
    });
  }

  Future<void> stopCapture() async {
    if (!_isCapturing) return;

    _isCapturing = false;
    _captureTimer?.cancel();
    _captureTimer = null;
    await stopForegroundService();
    await _captureStreamController?.close();
    _captureStreamController = null;
  }

  bool get isCapturing => _isCapturing;
}