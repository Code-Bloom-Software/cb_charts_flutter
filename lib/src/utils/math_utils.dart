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
}