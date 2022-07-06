import 'package:flutter/material.dart';
import 'package:nitya/utils/constants.dart';

class NavigationModel extends ChangeNotifier {
  double xOffset = 0;
  int homeIndex = 0;
  int bottomIndex = 0;
  bool isInternetConnected = true;

  bool get isDrawerOpen => xOffset == kDrawerWidth ? true : false;

  openDrawer() {
    xOffset = kDrawerWidth;
    notifyListeners();
  }

  changeInternet(bool connected) {
    isInternetConnected = connected;
    notifyListeners();
  }

  closeDrawer() {
    xOffset = 0;
    notifyListeners();
  }

  setHomeIndex(int index) {
    homeIndex = index;
    notifyListeners();
  }

  setMainIndex(int index) {
    bottomIndex = index;
    notifyListeners();
  }
}
