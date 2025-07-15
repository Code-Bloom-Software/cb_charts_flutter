import 'package:flutter/cupertino.dart';

class CBRankingData {

  /// The maximum value for the biggest bar
  final double maxValue;

  /// Bars width
  final double barWidth;

  /// Spacing between bars
  final double barSpacing;

  /// Minimum bar length to show the icon
  final double minBarLengthToShowIcon;

  /// Label space width or height depending on chart axis
  final double labelLength;

  /// The chart bars
  final List<CBRankingItem> bars;

  CBRankingData({
    required this.maxValue,
    required this.barWidth,
    required this.barSpacing,
    this.minBarLengthToShowIcon = 0,
    this.labelLength = 0,
    required this.bars
  });
}

class CBRankingItem {

  /// The label to identify this item
  final String label;

  /// An optional icon to show with the progress
  final Widget? icon;

  /// The bar decoration
  final BoxDecoration decoration;

  /// The value for this item
  final double value;

  CBRankingItem({
    required this.label,
    this.icon,
    required this.decoration,
    required this.value,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final CBRankingItem otherItem = other as CBRankingItem;
    return label == otherItem.label &&
        decoration == otherItem.decoration &&
        value == otherItem.value;
  }

  @override
  int get hashCode => label.hashCode ^ decoration.hashCode ^ value.hashCode;
}