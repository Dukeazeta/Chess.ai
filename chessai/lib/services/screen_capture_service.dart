import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
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
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }
  
  Future<void> startForegroundService() async {
    // Initialize foreground task
FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'screen_capture',
        channelName: 'Screen Capture Service',
        channelDescription: 'Service for capturing screen content',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 1000,
        autoRunOnBoot: false,
        allowWifiLock: false,
      ),
    );
    
    // Start the foreground service
    await FlutterForegroundTask.startService(
      notificationTitle: 'Chess.ai',
      notificationText: 'Capturing screen for analysis',
      callback: startCallback,
    );
  }
  
  Future<void> stopForegroundService() async {
    await FlutterForegroundTask.stopService();
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

// This is the callback function that will be executed when the foreground service is started
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(ScreenCaptureTaskHandler());
}

// Task handler for the foreground service
class ScreenCaptureTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, dynamic sendPort) async {
    // Initialize any resources needed for the foreground task
  }

  @override
  Future<void> onEvent(DateTime timestamp, dynamic sendPort) async {
    // This is called periodically based on the interval set in foregroundTaskOptions
  }

  @override
  Future<void> onDestroy(DateTime timestamp, dynamic sendPort) async {
    // Clean up resources when the service is stopped
  }

  @override
  void onButtonPressed(String id) {
    // Handle notification button presses if any
  }
}