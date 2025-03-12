import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayService {
  static Future<bool> requestPermission() async {
    try {
      final result = await FlutterOverlayWindow.requestPermission();
      return result ?? false;
    } catch (e) {
      print('Permission request error: $e');
      return false;
    }
  }

  static Future<void> showOverlay() async {
    try {
      final bool hasPermission = await FlutterOverlayWindow.isPermissionGranted();
      if (hasPermission) {
        await FlutterOverlayWindow.showOverlay(
          height: 50,
          width: 50,
          alignment: OverlayAlignment.centerRight,
          flag: OverlayFlag.defaultFlag,
          visibility: NotificationVisibility.visibilityPublic,
        );
      } else {
        print('Overlay permission not granted');
      }
    } catch (e) {
      print('Show overlay error: $e');
    }
  }

  static Future<void> hideOverlay() async {
    try {
      await FlutterOverlayWindow.closeOverlay();
    } catch (e) {
      print('Hide overlay error: $e');
    }
  }
}
