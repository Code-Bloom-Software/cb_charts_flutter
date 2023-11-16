import 'package:flutter/widgets.dart';

class CBGaugeData {
  /// The chart (semi-circle) diameter
  final double diameter;

  /// The chart width
  final double width;

  /// The rail color
  final Color railColor;

  /// The inner shadow color
  final Color railShadowColor;

  /// The current value
  final double value;

  /// The max value to reach
  final double max;

  /// An optional icon to show with the progress
  final Widget? icon;

  /// An optional widget to show on the left of the chart
  final Widget? leftAxis;

  /// An optional widget to show on the right of the chart
  final Widget? rightAxis;

  /// List of ranges (must contains at least one)
  final List<CBGaugeRange> ranges;

  CBGaugeData({
    this.diameter = 300,
    this.width = 35,
    this.railColor = const Color(0xFFCCDDFF),
    this.railShadowColor = const Color(0x330056FF),
    required this.value,
    required this.max,
    this.icon,
    this.leftAxis,
    this.rightAxis,
    required this.ranges
  });
}

class CBGaugeRange {
  /// An unique identifier to the range
  final String id;

  /// A range goes from this entry point until the next entry point
  final double entryPoint;

  /// The color of the progress in this range
  final Color color;

  CBGaugeRange({
    required this.id,
    this.entryPoint = 0,
    required this.color
  });
}