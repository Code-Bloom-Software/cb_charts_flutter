import 'dart:math';

import 'package:cb_charts_flutter/src/cb_gauge_chart/cb_gauge_components.dart';
import 'package:cb_charts_flutter/src/cb_gauge_chart/cb_gauge_controller.dart';
import 'package:cb_charts_flutter/src/cb_gauge_chart/cb_gauge_data.dart';
import 'package:cb_charts_flutter/src/utils/math_utils.dart';
import 'package:flutter/widgets.dart';

/// It draws a gauge chart. See a demo inside the example app.
class CBGaugeChart extends StatefulWidget {
  /// The chart controller (use it to begin the animation, for example)
  final CBGaugeController? controller;

  /// An optional builder to implement a widget that is shown in the chart center
  final Widget Function(CBGaugeRange range)? centerInfoBuilder;

  /// The chart data
  final CBGaugeData data;

  const CBGaugeChart({super.key,
    this.controller,
    this.centerInfoBuilder,
    required this.data
  });

  @override
  State<CBGaugeChart> createState() => _CBGaugeChartState();
}

class _CBGaugeChartState extends State<CBGaugeChart> with SingleTickerProviderStateMixin {
  late final AnimationController _progressAnimationController;
  late final Animation _progressAnimation;

  @override
  void initState() {
    _progressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _progressAnimationController, curve: Curves.decelerate));
    widget.controller?.addListener(_listener);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final diameter = widget.data.diameter;
    final width = widget.data.width;
    final value = widget.data.value;
    final max = widget.data.max;
    final railColor = widget.data.railColor;
    final railShadowColor = widget.data.railShadowColor;
    final leftAxis = widget.data.leftAxis;
    final rightAxis = widget.data.rightAxis;
    final ranges = widget.data.ranges;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: diameter + width,
          height: (diameter + width)/2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CBGaugeRailWidget(
                  diameter: diameter,
                  width: width,
                  color: railColor,
                  shadowColor: railShadowColor
              ),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  final animValue = _progressAnimation.value * value;
                  final range = _defineRange(ranges, animValue);
                  final center = Offset((diameter + width) / 2, (diameter + width) / 2);
                  final radius = diameter/ 2;
                  const startAngle = 0.95 * pi;
                  final sweepAngle = pi * (animValue/max).clamp(0, 1);
                  final offset = MathUtils.calculateArcEndpoint(center, radius, startAngle, sweepAngle);

                  return Stack(
                    children: [
                      CBGaugeProgressWidget(
                        diameter: diameter,
                        width: width,
                        color: range.color,
                        value: animValue,
                        max: max
                      ),
                      if (widget.data.icon != null)
                        Positioned(
                            left: offset.dx,
                            top: offset.dy,
                            child: FractionalTranslation(
                                translation: const Offset(-0.5, -0.5),
                                child: widget.data.icon!
                            )
                        )
                    ],
                  );
                },
              ),
              if (widget.centerInfoBuilder != null)
                Align(
                    alignment: Alignment.bottomCenter,
                    child: widget.centerInfoBuilder!.call(_defineRange(ranges, value)))
            ],
          ),
        ),
        SizedBox(
          width: diameter + width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leftAxis != null ? FractionalTranslation(
                  translation: const Offset(-0.5, 0),
                  child: Container(
                      margin: EdgeInsets.only(left: width),
                      child: leftAxis)) : const SizedBox.shrink(),
              rightAxis != null ? FractionalTranslation(
                  translation: const Offset(0.5, 0),
                  child: Container(
                      margin: EdgeInsets.only(right: width),
                      child: rightAxis)) : const SizedBox.shrink(),
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    widget.controller?.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    _progressAnimationController.forward();
  }
  
  CBGaugeRange _defineRange(List<CBGaugeRange> ranges, final double value) {
    return ranges.lastWhere((element) => value >= element.entryPoint);
  }
}
