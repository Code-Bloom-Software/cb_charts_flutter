import 'package:flutter/widgets.dart';

class CbStackedCircleController extends ChangeNotifier {

  /// If there's a circle selected, it will be dismissed.
  void dismiss() {
    notifyListeners();
  }
}