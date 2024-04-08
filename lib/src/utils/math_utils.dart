import 'dart:math';
import 'dart:ui';

class MathUtils {

  static double calcTotal(List<double> values) =>
      values.reduce((value, element) => value + element);

  static double calcFromPercentage(List<double> values, int index, {double? max}) => index == 0 ? 0.0 :
  values.sublist(0, index).reduce((value,
      element) => element + value) / (max ?? calcTotal(values));

  static double calcToPercentage(List<double> values, int index, {double? max}) =>
      values.sublist(0, index + 1).reduce((value, element) => element + value) /
      (max ?? calcTotal(values));

  static double convertATan2To02pi(double angle) {
    if (angle >= -pi/2 && angle < pi) {
      return angle + pi/2;
    }
    return 2.5 * pi + angle;
  }

  static Offset calculateArcEndpoint(Offset center, double radius, double startAngle, double sweepAngle) {
    double x = center.dx + radius * cos(startAngle + sweepAngle);
    double y = center.dy + radius * sin(startAngle + sweepAngle);

    return Offset(x, y);
  }

  static int findOuterIndex(List<List<dynamic>> data, int expandedIndex) {
    int currentIndex = 0;

    for (int i = 0; i < data.length; i++) {
      if (expandedIndex >= currentIndex && expandedIndex < currentIndex + data[i].length) {
        return i;
      }
      currentIndex += data[i].length;
    }
    return -1;
  }

  static int findBoundingIndexInCartesianPlan(List<List<Offset>> data, Offset screenPosition, Size size) {
    final cartesianPosition = Offset(screenPosition.dx, size.height - screenPosition.dy);
    final expandedData = data.expand((element) => element).toList();

    for (int i = 0; i < expandedData.length - 1; i++) {
      final x0 = expandedData[i].dx;
      final x1 = expandedData[i + 1].dx;
      final y = max(size.height - expandedData[i].dy, size.height - expandedData[i + 1].dy);

      if (cartesianPosition.dx >= x0 && cartesianPosition.dx <= x1
          && cartesianPosition.dy >= 0 && cartesianPosition.dy <= y) {
        return findOuterIndex(data, i);
      }
    }
    return -1;
  }
}