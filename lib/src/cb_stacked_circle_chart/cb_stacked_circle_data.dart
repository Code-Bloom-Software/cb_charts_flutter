import 'dart:ui';

class CbStackedCircleData {

  /// The minimum diameter for the smallest circles
  final double minDiameter;

  /// The maximum diameter for the biggest circle
  final double maxDiameter;

  /// The chart circles
  final List<CBStackedCircleItem> circles;

  CbStackedCircleData({
    required this.minDiameter,
    required this.maxDiameter,
    required this.circles
  });
}

class CBStackedCircleItem {

  /// The label to identify this item
  final String label;

  /// The circle fill color
  final Color color;

  /// The value for this item
  final double value;

  CBStackedCircleItem({
    required this.label,
    required this.color,
    required this.value
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final CBStackedCircleItem otherItem = other as CBStackedCircleItem;
    return label == otherItem.label &&
        color == otherItem.color &&
        value == otherItem.value;
  }

  @override
  int get hashCode => label.hashCode ^ color.hashCode ^ value.hashCode;
}