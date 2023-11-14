import 'dart:math';

import 'package:cb_charts_flutter/src/utils/math_utils.dart';
import 'package:flutter/widgets.dart';

class CBSunburstSegmentWidget extends StatelessWidget {
  final String id;
  final double diameter;
  final double width;
  final double dividerWidth;
  final Color color;
  final double fromPercentage;
  final double toPercentage;

  const CBSunburstSegmentWidget({super.key,
    required this.id,
    required this.diameter,
    required this.width,
    required this.dividerWidth,
    required this.color,
    required this.fromPercentage,
    required this.toPercentage
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(diameter + width),
      painter: CBSunburstSegmentPainter(id, diameter, width, dividerWidth,
          color, fromPercentage, toPercentage),
    );
  }
}

class CBSunburstSegmentPainter extends CustomPainter {
  final String id;
  final double diameter;
  final double width;
  final double dividerWidth;
  final Color color;
  final double fromPercentage;
  final double toPercentage;
  late final Paint _paint;
  late final Paint _dividerPainter;

  CBSunburstSegmentPainter(this.id, this.diameter, this.width,
      this.dividerWidth, this.color, this.fromPercentage, this.toPercentage) {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    _dividerPainter = Paint()
      ..strokeWidth = dividerWidth
      ..blendMode = BlendMode.clear;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const total = 2 * pi;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = diameter/2;
    final startAngle = -pi / 2 + (total * fromPercentage);
    final angle = total * (toPercentage.clamp(0, 1) - fromPercentage);
    final Offset arcEndPointP1 = MathUtils.calculateArcEndpoint(center, radius - width/2, startAngle, angle);
    final Offset arcEndPointP2 = MathUtils.calculateArcEndpoint(center, radius + width/2, startAngle, angle);

    canvas.saveLayer(Rect.largest, Paint());
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      angle,
      false,
      _paint,
    );
    canvas.drawLine(arcEndPointP1, arcEndPointP2, _dividerPainter);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is CBSunburstSegmentPainter) {
      return oldDelegate.diameter != diameter ||
          oldDelegate.width != width ||
          oldDelegate.color != color ||
          oldDelegate.fromPercentage != fromPercentage ||
          oldDelegate.toPercentage != toPercentage;
    }
    return true;
  }

  @override
  bool hitTest(Offset position) {
    final segAngleFrom = 2 * fromPercentage * pi;
    final segAngleTo = 2 * toPercentage * pi;
    final centerX = (diameter + width)/2;
    final centerY = (diameter + width)/2;
    double angle = atan2(position.dy - centerY, position.dx - centerX);
    angle = MathUtils.convertATan2To02pi(angle);

    if (angle >= segAngleFrom && angle <= segAngleTo) {
      final distance = sqrt(pow(position.dx - centerX, 2) + pow(position.dy - centerY, 2));
      return distance >= (diameter - width)/2 && distance <= (diameter + width)/2;
    }
    return false;
  }
}