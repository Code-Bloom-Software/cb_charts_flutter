import 'package:flutter/widgets.dart';

class CBBubbleData {

  /// The minimum diameter for the bubble (when its value is zero)
  final double minDiameter;

  /// The maximum diameter for the bubble
  final double maxDiameter;

  /// The percentage of the bubble that can overlaps its neighbors
  final double percentOverlap;

  /// Max width to the labels
  final double labelWidth;

  /// The items list
  final List<CBBubbleItem> items;

  /// The max value for the bubble in x axis (if null the max will be the sum)
  final double? xAxisMax;

  CBBubbleData({
    this.minDiameter = 3,
    this.maxDiameter = 56,
    this.percentOverlap = 0.2,
    this.labelWidth = 100,
    required this.items,
    this.xAxisMax
  });
}

class CBBubbleItem {

  /// The label to identify this item
  final String label;

  /// The item color
  final Color color;

  /// The lane color
  final Color backgroundColor;

  /// The list of values of this item
  final List<double> values;

  CBBubbleItem({
    required this.label,
    required this.color,
    required this.backgroundColor,
    required this.values
  });
}

class CBBubbleTapWidget {

  /// The anchor to positioning the widget, e.g, Offset(0, 0) to center it
  final Offset anchor;

  /// The actual widget
  final Widget child;

  CBBubbleTapWidget({
    required this.anchor,
    required this.child
  });
}