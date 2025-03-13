import 'package:flutter/material.dart';

class FloatingWindowProvider extends ChangeNotifier {
  bool _isVisible = false;
  Offset _position = const Offset(100, 100);

  bool get isVisible => _isVisible;
  Offset get position => _position;

  void toggleVisibility() {
    _isVisible = !_isVisible;
    notifyListeners();
  }

  void show() {
    _isVisible = true;
    notifyListeners();
  }

  void hide() {
    _isVisible = false;
    notifyListeners();
  }

  void updatePosition(Offset newPosition) {
    _position = newPosition;
    notifyListeners();
  }
}