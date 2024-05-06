import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

class CBSectionedLineData {
  /// The chart line width
  final double lineWidth;

  /// the number of dividers in y-axis
  final int numDividers;

  /// Max y-axis
  final double maxY;

  /// Divider widget
  final Widget? divider;

  /// Divider widget to alternate
  final Widget? dividerAlternate;

  final int xAxisDivider;

  /// The chart sections
  final List<CBSectionedLineSection> sections;

  CBSectionedLineData({
    this.lineWidth = 2.0,
    this.numDividers = 5,
    required this.maxY,
    this.divider,
    this.dividerAlternate,
    required this.xAxisDivider,
    required this.sections
  });
}

class CBSectionedLineSection {

  /// The label to identify this item
  final String label;

  /// The line color
  final Color lineColor;

  /// The bellow line color
  final Color backgroundColor;

  /// The selection color
  final Color selectionColor;

  /// Widget to show when the section widget is too small
  final PreferredSizeWidget? collapsedWidget;

  /// Widget to show when there is space in section widget and when selected
  final PreferredSizeWidget? expandedWidget;

  /// The list of values of this section
  final List<Offset> values;

  CBSectionedLineSection({
    required this.label,
    required this.lineColor,
    required this.backgroundColor,
    required this.selectionColor,
    this.collapsedWidget,
    this.expandedWidget,
    required this.values
  });

  double get sum => values.map((e) => e.dy)
      .reduce((value, element) => value + element);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CBSectionedLineSection &&
              runtimeType == other.runtimeType &&
              label == other.label &&
              lineColor == other.lineColor &&
              backgroundColor == other.backgroundColor &&
              const ListEquality().equals(values, other.values);

  @override
  int get hashCode =>
      label.hashCode ^
      lineColor.hashCode ^
      backgroundColor.hashCode ^
      values.hashCode;
}