import 'dart:math';

import 'package:cb_charts_flutter/src/utils/math_utils.dart';
import 'package:flutter/material.dart';

class RingRail extends StatelessWidget {
  final double diameter;
  final double width;
  final double segmentWidth;
  final Color color;
  final Color shadowColor;

  const RingRail({super.key,
    required this.diameter,
    required this.width,
    required this.segmentWidth,
    required this.color,
    required this.shadowColor
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RingRailPainter(width, segmentWidth, color, shadowColor),
      size: Size.square(diameter),
    );
  }
}

class RingRailPainter extends CustomPainter {
  final double width;
  final double segmentWidth;
  final Color color;
  final Color shadowColor;
  late final Paint _paint;
  late final Paint _shadowPaint;

  RingRailPainter(this.width, this.segmentWidth, this.color, this.shadowColor) {
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
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - width - (segmentWidth - width))/2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi/2,
      2 * pi,
      false,
      _paint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + width/2 - 2),
      0.9 * -pi,
      0.9 * pi,
      false,
      _shadowPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - width/2 + 2),
      0.9 * pi,
      0.9 * -pi,
      false,
      _shadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is RingRailPainter) {
      return oldDelegate.width != width ||
          oldDelegate.segmentWidth != segmentWidth ||
          oldDelegate.color != color ||
          oldDelegate.shadowColor != shadowColor;
    }
    return true;
  }
}

class RingSegment extends StatelessWidget {
  final bool? selected;
  final double diameter;
  final double width;
  final double segmentWidth;
  final Color color;
  final double fromPercentage;
  final double toPercentage;

  const RingSegment({super.key,
    required this.selected,
    required this.diameter,
    required this.width,
    required this.segmentWidth,
    required this.color,
    required this.fromPercentage,
    required this.toPercentage
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: selected != null
          ? (selected!
          ? ColorTween(begin: color, end: color)
          : ColorTween(
          begin: color,
          end: Color.alphaBlend(color.withOpacity(0.2), Colors.white)))
          : ColorTween(
          begin: Color.alphaBlend(color.withOpacity(0.2), Colors.white),
          end: color),
      builder: (context, color, child) => TweenAnimationBuilder(
        tween: selected != null
            ? (selected!
            ? Tween<double>(begin: segmentWidth, end: width)
            : Tween(begin: width, end: segmentWidth))
            : Tween(begin: segmentWidth, end: segmentWidth),
        duration: const Duration(milliseconds: 200),
        curve: Curves.decelerate,
        builder: (context, width, child) => CustomPaint(
          painter: RingSegmentPainter(diameter,
              width, segmentWidth, color!, fromPercentage, toPercentage),
          size: Size.square(diameter),
        ),
      ),
    );
  }
}

class RingSegmentPainter extends CustomPainter {
  final double diameter;
  final double width;
  final double segmentWidth;
  final Color color;
  final double fromPercentage;
  final double toPercentage;
  late final Paint _paint;

  RingSegmentPainter(this.diameter, this.width, this.segmentWidth, this.color,
      this.fromPercentage, this.toPercentage) {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const total = 2 * pi;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - width + (width - segmentWidth))/2;
    final startAngle = -pi / 2 + (total * fromPercentage);
    final angle = total * (toPercentage.clamp(0, 1) - fromPercentage);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      angle,
      false,
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is RingSegmentPainter) {
      return oldDelegate.diameter != diameter ||
          oldDelegate.width != width ||
          oldDelegate.segmentWidth != segmentWidth ||
          oldDelegate.color != color ||
          oldDelegate.fromPercentage != fromPercentage ||
          oldDelegate.toPercentage != toPercentage;
    }
    return true;
  }

  @override
  bool hitTest(Offset position) {
    final segAngle = 2 * toPercentage * pi;
    final centerX = diameter/2;
    final centerY = diameter/2;
    double angle = atan2(position.dy - centerY, position.dx - centerX);
    angle = MathUtils.convertATan2To02pi(angle);

    if (angle >= 0 && angle <= segAngle) {
      final distance = sqrt(pow(position.dx - centerX, 2) + pow(position.dy - centerY, 2));
      return distance >= diameter/2 - width && distance <= diameter/2;
    }
    return false;
  }
}

class RingOverGoal extends StatelessWidget {
  final bool show;
  final double diameter;
  final double width;
  final Color color;
  final double percentage;

  const RingOverGoal({super.key,
    required this.show,
    required this.diameter,
    required this.width,
    required this.color,
    required this.percentage
  });

  @override
  Widget build(BuildContext context) {
    return show ? TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: percentage),
      duration: const Duration(milliseconds: 400),
      curve: Curves.decelerate,
      builder: (context, percentage, child) => IgnorePointer(
        child: CustomPaint(
          painter: RingOverGoalPainter(width, color, percentage),
          size: Size.square(diameter),
        ),
      ),
    ) : const SizedBox.shrink();
  }
}

class RingOverGoalPainter extends CustomPainter {
  final double width;
  final Color color;
  final double percentage;
  late final Paint _paint;

  RingOverGoalPainter(this.width, this.color, this.percentage) {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width + width)/2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi/2,
      percentage * 2 * pi,
      false,
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is RingOverGoalPainter) {
      return oldDelegate.width != width ||
          oldDelegate.color != color ||
          oldDelegate.percentage != percentage;
    }
    return true;
  }
}