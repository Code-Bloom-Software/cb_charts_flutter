import 'dart:math';

import 'package:cb_charts_flutter/src/cb_stacked_circle_chart/cb_stacked_circle_controller.dart';
import 'package:cb_charts_flutter/src/cb_stacked_circle_chart/cb_stacked_circle_data.dart';
import 'package:flutter/material.dart';

class CbStackedCircleChart extends StatefulWidget {

  /// The chart controller (use it to dismiss tap, for example)
  final CbStackedCircleController? controller;

  /// The alignment of circles (like the Stack widget alignment, but constrained inside the circle)
  final Alignment alignment;

  /// The chart data
  final CbStackedCircleData data;

  /// An optional builder to label (it receives the current circle diameter and the next circle diameter)
  final Widget Function(double curDiameter, double nextDiameter, CBStackedCircleItem item)? labelBuilder;

  /// An optional builder to show a widget on tap (it receives the current circle diameter and the next circle diameter)
  final Widget Function(Alignment aligment, double curDiameter, double nextDiameter, CBStackedCircleItem item)? onTapBuilder;

  const CbStackedCircleChart({super.key,
    this.controller,
    this.alignment = Alignment.bottomRight,
    required this.data,
    this.labelBuilder,
    this.onTapBuilder
  });

  @override
  State<CbStackedCircleChart> createState() => _CbStackedCircleChartState();
}

class _CbStackedCircleChartState extends State<CbStackedCircleChart> {
  CBStackedCircleItem? _selected;
  Widget? _selectedWidget;

  @override
  void initState() {
    widget.controller?.addListener(_handleListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final circles = widget.data.circles;
    final maxCircleValue = circles.map((e) => e.value).reduce(max);
    circles.sort((c1, c2) => c2.value.compareTo(c1.value));

    return SizedBox(
      width: widget.data.maxDiameter,
      height: widget.data.maxDiameter,
      child: Stack(
        children: [
          Stack(
            alignment: _clampToCircle(widget.alignment),
            children: circles.asMap().entries.map((circleEntry) {
              final circle = circleEntry.value;
              final diameter = ((circle.value / maxCircleValue) * widget.data.maxDiameter)
                  .clamp(widget.data.minDiameter, widget.data.maxDiameter);
              final nextCircle = circleEntry.key < circles.length - 1 ? circles[circleEntry.key + 1] : null;
              final nextDiameter = nextCircle != null ? ((nextCircle.value / maxCircleValue) * widget.data.maxDiameter)
                  .clamp(widget.data.minDiameter, widget.data.maxDiameter) : 0.0;

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selected = circle;
                        _selectedWidget = widget.onTapBuilder?.call(_clampToCircle(widget.alignment),
                            diameter, nextDiameter, circle);
                      });
                    },
                    child: Container(
                      width: diameter,
                      height: diameter,
                      decoration: BoxDecoration(
                          color: circle.color,
                          shape: BoxShape.circle
                      ),
                      child: widget.labelBuilder?.call(diameter, nextDiameter, circle),
                    ),
                  ),
                  IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: _selected != null && _selected != circle ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: diameter,
                        height: diameter,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList()
          ),
          if (_selectedWidget != null) _selectedWidget!
        ],
      ),
    );
  }

  Alignment _clampToCircle(Alignment position) {
    double dx = position.x;
    double dy = position.y;
    double distance = sqrt(pow(dx, 2) + pow(dy, 2));

    if (distance > 1) {
      double angle = atan2(dy, dx);
      dx = cos(angle);
      dy = sin(angle);
    }

    return Alignment(dx, dy);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleListener);
    super.dispose();
  }

  void _handleListener() {
    setState(() {
      _selected = null;
      _selectedWidget = null;
    });
  }
}
