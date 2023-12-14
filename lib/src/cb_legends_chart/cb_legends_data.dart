import 'dart:ui';

class CBLegendsData {
  /// The height of the header
  final double headerHeight;

  /// The height of each item
  final double itemHeight;

  /// The color used in dividers (item and header)
  final Color dividerColor;

  /// If not null, the bars progress will be based on this goal, otherwise it will based on the sum of all items values
  final double? goal;

  /// The list of items (will be drawn in the same order)
  final List<CBLegendsItem> items;

  CBLegendsData({
    this.headerHeight = 56,
    this.itemHeight = 48,
    this.dividerColor = const Color(0xFFE5F4F4),
    this.goal,
    required this.items
  });

  get max => goal ?? items.map((e) => e.value).reduce((value, element) => value + element);
}

class CBLegendsItem {

  /// The label to identify the item
  final String label;

  /// The value of this item
  final double value;

  /// The color of the bar progress for this item
  final Color color;

  CBLegendsItem({
    required this.label,
    required this.value,
    required this.color
  });
}