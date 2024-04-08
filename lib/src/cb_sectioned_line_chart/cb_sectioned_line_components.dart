import 'package:cb_charts_flutter/src/utils/math_utils.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class CBSectionedLineWidget extends StatelessWidget {
  final double lineWidth;
  final List<List<Offset>> data;
  final List<Color> lineColors;
  final List<Color> areaColors;

  const CBSectionedLineWidget({super.key,
    this.lineWidth = 2.0,
    required this.data,
    required this.lineColors,
    required this.areaColors,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: CBSectionedLinePainter(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              lineWidth: lineWidth,
              data: data,
              lineColors: lineColors,
              areaColors: areaColors
          ),
        );
      }
    );
  }
}

class CBSectionedLinePainter extends CustomPainter {
  final Size size;
  final double lineWidth;
  final List<List<Offset>> data;
  final List<Color> lineColors;
  final List<Color> areaColors;
  late final Paint _linePaint;
  late final Paint _areaPaint;

  CBSectionedLinePainter({
    required this.size,
    required this.lineWidth,
    required this.data,
    required this.lineColors,
    required this.areaColors,
  }) {
    _linePaint = Paint()
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;
    _areaPaint = Paint()
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final List<Offset> points = data.expand((element) => element).toList();
    int curColorIndex = 0;
    Path linePath = Path();
    Path areaPath = Path();

    linePath.moveTo(points.first.dx, points.first.dy);
    areaPath.moveTo(points.first.dx, size.height);
    areaPath.lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i < points.length - 2 ? points[i + 2] : p2;

      final cp1x = p1.dx + (p2.dx - p0.dx) / 8;
      final cp1y = p1.dy + (p2.dy - p0.dy) / 8;

      final cp2x = p2.dx - (p3.dx - p1.dx) / 8;
      final cp2y = p2.dy - (p3.dy - p1.dy) / 8;

      linePath.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
      areaPath.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);

      if (curColorIndex != MathUtils.findOuterIndex(data, i + 1) || i == points.length - 2) {
        curColorIndex = MathUtils.findOuterIndex(data, i);

        _areaPaint.color = areaColors[curColorIndex];
        areaPath.lineTo(p2.dx, size.height);
        areaPath.lineTo(p1.dx, size.height);
        areaPath.close();
        canvas.drawPath(areaPath, _areaPaint);
        areaPath = Path();
        areaPath.moveTo(p2.dx, size.height);
        areaPath.lineTo(p2.dx, p2.dy);

        _linePaint.color = lineColors[curColorIndex];
        canvas.drawPath(linePath, _linePaint);
        linePath = Path();
        linePath.moveTo(p2.dx, p2.dy);

        curColorIndex = MathUtils.findOuterIndex(data, i + 1);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is CBSectionedLinePainter) {
      final eq = const ListEquality().equals;

      return oldDelegate.size != oldDelegate.size ||
          oldDelegate.lineWidth != lineWidth ||
          !eq(oldDelegate.data, data) ||
          !eq(oldDelegate.lineColors, lineColors) ||
          !eq(oldDelegate.areaColors, areaColors);
    }
    return true;
  }

  @override
  bool hitTest(Offset position) {
    final boundingIndex = MathUtils.findBoundingIndexInCartesianPlan(data, position, size);

    return boundingIndex != -1;
  }
}