import 'dart:math';

import 'package:cb_charts_flutter/src/cb_ring_chart/cb_ring_chart_controller.dart';
import 'package:cb_charts_flutter/src/cb_ring_chart/cb_ring_chart_data.dart';
import 'package:cb_charts_flutter/src/cb_ring_chart/cb_ring_components.dart';
import 'package:cb_charts_flutter/src/utils/math_utils.dart';
import 'package:flutter/widgets.dart';

/// It draws a ring chart. See a demo inside the example app.
class CBRingChart extends StatefulWidget {

  /// The chart controller (use it to begin the animation, for example)
  final CBRingChartController? controller;

  /// The chart data
  final CBRingChartData data;

  /// An optional builder to implement a widget that is shown in the chart center
  final Widget Function(double animPercent, double segmentsTotal, double chartMax)? buildLabel;

  /// An optional builder to implement a widget that is shown in the chart center (when a segment is selected)
  final Widget Function(CBRingChartSegment segment, double chartMax)? onSelected;

  const CBRingChart({super.key,
    this.controller,
    required this.data,
    this.buildLabel,
    this.onSelected,
  });

  @override
  State<CBRingChart> createState() => _CBRingChartState();
}

class _CBRingChartState extends State<CBRingChart> with SingleTickerProviderStateMixin {
  late final AnimationController _segmentAnimationController;
  late final Animation _segmentAnimation;
  _RingSegmentSelected? _selected;
  Widget? _selectedLabel;
  bool _animCompleted = false;

  @override
  void initState() {
    _segmentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _segmentAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _segmentAnimationController,
        curve: Curves.decelerate));
    _segmentAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animCompleted = true;
        });
      }
    });
    widget.controller?.addListener(() {
      switch (widget.controller?.op) {
        case CBRingChartControllerOp.forward:
          _segmentAnimationController.forward();
        case CBRingChartControllerOp.dismiss:
          setState(() {
            _selected = null;
            _selectedLabel = null;
          });
        default:
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final segments = widget.data.segments;
    final overGoal = widget.data.overGoal;
    final goal = widget.data.goal;
    final values = segments.map((e) => e.value).toList();
    final goalPercentage = goal != null ? (MathUtils.calcToPercentage(values, segments.length - 1, max: goal) - 1.0).clamp(0.0, 1.0) : 0.0;
    final goalRadius = (widget.data.diameter + widget.data.overGoalWidth / 2) / 2;
    final left = (widget.data.diameter/2 + (goalPercentage * 2 * pi * goalRadius)/2)
        .clamp(0.0, widget.data.diameter - (overGoal != null ? overGoal.size.width : 0.0));

    return GestureDetector(
      onTap: () {
        setState(() {
          _selected = null;
          _selectedLabel = null;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            height: widget.data.diameter + (overGoal != null && goalPercentage > 0.0 ? overGoal.size.height : 0.0),
            width: widget.data.diameter,
            child: Stack(
              alignment: Alignment.center,
              children: [
                RingRail(
                    diameter: widget.data.diameter,
                    width: widget.data.railWidth,
                    segmentWidth: widget.data.segmentWidth,
                    color: widget.data.railColor,
                    shadowColor: widget.data.railShadowColor),
                AnimatedOpacity(
                  opacity: _selected == null ? 1 : 0.2,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.decelerate,
                  child: RingOverGoal(
                      show: _animCompleted,
                      diameter: widget.data.diameter,
                      width: widget.data.overGoalWidth,
                      color: widget.data.overGoalColor,
                      percentage: goalPercentage
                  ),
                ),
                AnimatedBuilder(
                  animation: _segmentAnimation,
                  builder: (context, child) => Stack(
                      children: segments.asMap().entries.map((e) {
                        final values = segments.map((e) => e.value).toList();
                        final fromPercentage = MathUtils.calcFromPercentage(values, e.key, max: widget.data.chartMax);
                        final toPercentage = MathUtils.calcToPercentage(values, e.key, max: widget.data.chartMax);
                        final selected = _selected != null
                            ? _selected?.fromPercentage == fromPercentage && _selected?.toPercentage == toPercentage
                            : null;

                        return GestureDetector(
                          onTap: () => _handleSegmentTap(fromPercentage, toPercentage, e.value),
                          child: RingSegment(
                              selected: selected,
                              diameter: widget.data.diameter,
                              width: widget.data.selectedSegmentWidth,
                              segmentWidth: widget.data.segmentWidth,
                              color: e.value.color,
                              fromPercentage: _animCompleted ? fromPercentage : 0,
                              toPercentage: toPercentage * _segmentAnimation.value),
                        );
                      }).toList().reversed.toList()),
                ),
                _selectedLabel ?? AnimatedBuilder(
                    animation: _segmentAnimation,
                    builder: (context, child) => widget.buildLabel != null ? widget.buildLabel!.call(
                        _segmentAnimation.value,
                        widget.data.segmentsTotal,
                        widget.data.goal ?? widget.data.chartMax) : const SizedBox.shrink()),
              ],
            ),
          ),
          if (overGoal != null && goalPercentage > 0.0) Positioned(
              left: left - (overGoal.size.width / 2) * (1 + overGoal.alignment.x),
              bottom: sqrt(pow(goalRadius, 2) - pow(left - goalRadius, 2)) +
                  goalRadius -
                  (overGoal.size.height / 2) * (1 + overGoal.alignment.y),
              child: AnimatedOpacity(
                  opacity: _animCompleted && _selected == null ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.decelerate,
                  child: overGoal.child
              )
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _segmentAnimationController.dispose();
    super.dispose();
  }

  void _handleSegmentTap(double fromPercentage, double toPercentage, CBRingChartSegment segment) {
    setState(() {
      _selectedLabel = widget.onSelected?.call(segment, widget.data.goal ?? widget.data.chartMax);
      _selected = _RingSegmentSelected(fromPercentage, toPercentage, segment);
    });
  }
}


class _RingSegmentSelected {
  final double fromPercentage;
  final double toPercentage;
  final CBRingChartSegment segment;

  _RingSegmentSelected(this.fromPercentage, this.toPercentage, this.segment);
}