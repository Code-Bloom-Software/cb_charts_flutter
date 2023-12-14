import 'package:flutter/widgets.dart';

enum CBRingChartControllerOp {
  forward, dismiss
}

class CBRingChartController extends ChangeNotifier {
  CBRingChartControllerOp? op;

  void forward() {
    op = CBRingChartControllerOp.forward;
    notifyListeners();
  }

  void dismiss() {
    op = CBRingChartControllerOp.dismiss;
    notifyListeners();
  }
}