import 'dart:ui';

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

  CBBubbleData({
    this.minDiameter = 3,
    this.maxDiameter = 56,
    this.percentOverlap = 0.2,
    this.labelWidth = 100,
    required this.items
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