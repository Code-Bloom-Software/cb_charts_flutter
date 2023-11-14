import 'package:flutter/widgets.dart';

class CBSunburstController extends ChangeNotifier{

  /// If there's a segment selected, it will be dismissed.
  void dismiss() {
    notifyListeners();
  }
}