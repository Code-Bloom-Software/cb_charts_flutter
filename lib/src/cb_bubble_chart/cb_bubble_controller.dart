import 'package:flutter/widgets.dart';

class CBBubbleController extends ChangeNotifier {
  CBBubbleControllerOp op = CBBubbleControllerOp.forward;

  void forward() {
    op = CBBubbleControllerOp.forward;
    notifyListeners();
  }

  void dismiss() {
    op = CBBubbleControllerOp.dismiss;
    notifyListeners();
  }
}

enum CBBubbleControllerOp {
  forward, dismiss
}