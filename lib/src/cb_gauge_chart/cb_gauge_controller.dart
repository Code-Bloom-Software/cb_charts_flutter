import 'package:flutter/widgets.dart';

class CBGaugeController extends ChangeNotifier {

  /// Init the chart animation.
  void forward() {
    notifyListeners();
  }
}