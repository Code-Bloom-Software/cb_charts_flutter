import 'package:flutter/widgets.dart';

class CBSectionedLineController extends ChangeNotifier {

  /// If there's a segment selected, it will be dismissed.
  void dismiss() {
    notifyListeners();
  }
}