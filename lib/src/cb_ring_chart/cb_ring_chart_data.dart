import 'package:flutter/widgets.dart';

class CBRingChartData {
  /// The chart diameter
  final double diameter;

  /// The rail width
  final double railWidth;

  /// The rail color
  final Color railColor;

  /// The inner shadow color
  final Color railShadowColor;

  /// The segment width
  final double segmentWidth;

  /// The segment width when selected
  final double selectedSegmentWidth;

  /// The over goal segment width
  final double overGoalWidth;

  /// The over goal segment color
  final Color overGoalColor;

  /// If not null, the chart will calculate percentages based on this, otherwise it uses the total items values sum (see demos in example)
  final double? goal;

  /// The segments list
  final List<CBRingChartSegment> segments;

  /// It can be used to show a widget with information when the segments overcome the goal (see demo in example)
  CBRingChartOverGoal? overGoal;

  CBRingChartData({
    this.diameter = 300,
    this.railWidth = 30,
    this.railColor = const Color(0xFFE5EEFF),
    this.railShadowColor = const Color(0x330056FF),
    this.segmentWidth = 40,
    this.selectedSegmentWidth = 60,
    this.overGoalWidth = 15,
    this.overGoalColor = const Color(0xFFE6F33C),
    this.goal,
    required this.segments,
    this.overGoal
  });

  double get segmentsTotal => segments.map((e) => e.value)
      .reduce((value, element) => value + element);

  double get chartMax {
    final fGoal = goal;
    return fGoal != null ? (segmentsTotal > fGoal ? segmentsTotal : fGoal) : segmentsTotal;
  }
}

class CBRingChartSegment {
  /// A label to identify the segment
  final String label;

  /// The value of this segment
  final double value;

  /// The segment color
  final Color color;

  CBRingChartSegment({
    required this.label,
    required this.value,
    required this.color
  });
}

class CBRingChartOverGoal {

  /// The alignment of the info widget
  final Alignment alignment;

  /// The size of the widget
  final Size size;

  /// The widget to show the information about an over goal
  final Widget child;

  CBRingChartOverGoal({required this.alignment, required this.size, required this.child});
}