import 'dart:ui';

import 'package:cb_charts_flutter/cb_charts_flutter.dart';

/// The data structure to feed the [CBSunburstChart].
class CBSunburstData {
  /// The diameter of the first layer
  final double diameter;

  /// The divider width of segments and layer
  final double dividerWidth;

  /// The segments to draw the whole chart
  final List<CBSunburstSegment> segments;

  CBSunburstData({
    required this.diameter,
    this.dividerWidth = 2,
    required this.segments
  });
}

class CBSunburstSegment {
  /// An unique id to this segment
  final String id;

  /// The value of this segment
  final double value;

  /// The width of this segment
  final double width;

  /// The color of this segment (without interaction)
  final Color color;

  /// The color of this segment (after selected)
  final Color selectedColor;

  /// The color of this segment (when this and its children are not selected)
  final Color backgroundColor;

  /// The children of this segment (defaults to empty)
  final List<CBSunburstSegment> children;

  /// The parent of this segment (null if this it's in the first layer)
  CBSunburstSegment? parent;

  CBSunburstSegment({
    required this.id,
    required this.value,
    required this.width,
    required this.color,
    required this.selectedColor,
    required this.backgroundColor,
    this.children = const []
  }) {
    for (final child in children) {
      child.parent = this;
    }
  }
}