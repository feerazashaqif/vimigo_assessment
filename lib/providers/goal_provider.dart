import 'package:flutter/material.dart';

class GoalNotifier with ChangeNotifier {
  int selected = 0;
  bool openBottomSheet = false;
  double pathAnimation = 0, moveLeft = 0, moveRight = 0, scale = 0;

  setSelected(int value) {
    selected = value;
    notifyListeners();
  }

  setOpenBottomSheet(bool value) {
    openBottomSheet = value;
    notifyListeners();
  }

  setPathAnimationValue(double value) {
    pathAnimation = value;
    notifyListeners();
  }

  setMoveLeftValue(double value) {
    moveLeft = value;
    notifyListeners();
  }

  setMoveRightValue(double value) {
    moveRight = value;
    notifyListeners();
  }

  setScaleValue(double value) {
    scale = value;
    notifyListeners();
  }
}
