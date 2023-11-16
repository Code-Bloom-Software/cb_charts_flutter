import 'dart:math';

import 'package:flutter/widgets.dart';

class CBGaugeRailWidget extends StatelessWidget {
  final double diameter;
  final double width;
  final Color color;
  final Color shadowColor;

  const CBGaugeRailWidget({super.key,
    required this.diameter,
    required this.width,
    required this.color,
    required this.shadowColor
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CBGaugeRail(diameter, width, color, shadowColor),
      size: Size(diameter + width, (diameter + width)/2),
    );
  }
}

class CBGaugeRail extends CustomPainter {
  final double diameter;
  final double width;
  final Color color;
  final Color shadowColor;
  late final Paint _paint;
  late final Paint _shadowPaint;

  CBGaugeRail(this.diameter, this.width, this.color, this.shadowColor) {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    _shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = diameter/2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      _paint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + width/2 - 2),
      1.05 * pi,
      0.9 * pi,
      false,
      _shadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is CBGaugeRail) {
      return oldDelegate.diameter != diameter ||
          oldDelegate.width != width ||
          oldDelegate.color != color ||
          oldDelegate.shadowColor != shadowColor;
    }
    return true;
  }
}

class CBGaugeProgressWidget extends StatelessWidget {
  final double diameter;
  final double width;
  final Color color;
  final double value;
  final double max;

  const CBGaugeProgressWidget({super.key,
    required this.diameter,
    required this.width,
    required this.color,
    required this.value,
    required this.max
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CBGaugeProgress(diameter, width, color, value, max),
      size: Size(diameter + width, (diameter + width)/2),
    );
  }
}

class CBGaugeProgress extends CustomPainter {
  final double diameter;
  final double width;
  final Color color;
  final double value;
  final double max;
  late final Paint _paint;

  CBGaugeProgress(this.diameter, this.width, this.color, this.value, this.max) {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = diameter/2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi * (value/max).clamp(0, 1),
      false,
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is CBGaugeProgress) {
      return oldDelegate.diameter != diameter ||
          oldDelegate.width != width ||
          oldDelegate.color != color ||
          oldDelegate.value != value ||
          oldDelegate.max != max;
    }
    return true;
  }
}