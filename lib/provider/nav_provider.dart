import 'package:flutter/material.dart';

class NavProvider extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void setIndex(BuildContext context, int i) {
    _index = i;
    notifyListeners();

    switch (i) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/favorites');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }
}