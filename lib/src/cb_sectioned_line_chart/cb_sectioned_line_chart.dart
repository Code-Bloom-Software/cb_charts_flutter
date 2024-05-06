import 'dart:math';

import 'package:cb_charts_flutter/src/cb_sectioned_line_chart/cb_sectioned_line_components.dart';
import 'package:cb_charts_flutter/src/cb_sectioned_line_chart/cb_sectioned_line_controller.dart';
import 'package:cb_charts_flutter/src/cb_sectioned_line_chart/cb_sectioned_line_data.dart';
import 'package:cb_charts_flutter/src/utils/math_utils.dart';
import 'package:flutter/material.dart';

const _defaultPadding = 16.0;

class CBSectionedLineChart extends StatefulWidget {

  /// The chart controller (use it to dismiss tap, for example)
  final CBSectionedLineController? controller;

  /// The chart data
  final CBSectionedLineData data;

  /// Listener to the section tap
  final Function(CBSectionedLineSection)? onSectionTap;

  const CBSectionedLineChart({super.key,
    this.controller,
    required this.data,
    this.onSectionTap,
  });

  @override
  State<CBSectionedLineChart> createState() => _CBSectionedLineChartState();
}

class _CBSectionedLineChartState extends State<CBSectionedLineChart> {
  CBSectionedLineSection? _selected;
  int? _selectedIndex;
  CBSectionedLineSection? _lastSelected;
  int? _lastSelectedIndex;

  @override
  void initState() {
    widget.controller?.addListener(_handleListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    final selectedIndex = _selectedIndex;
    final lastSelected = _lastSelected;
    final lastSelectedIndex = _lastSelectedIndex;

    return LayoutBuilder(builder: (context, constraints) {
      final data = widget.data.sections
          .map((e) => e.values
              .map((e) => Offset(e.dx, constraints.maxHeight - e.dy))
              .toList())
          .toList();
      final selectorWidth = _resolveSelectorWidth(data, selected, selectedIndex,
          lastSelected, lastSelectedIndex);
      final expandedWidgetWidth = ((_selected ?? _lastSelected)?.expandedWidget?.preferredSize.width ?? 0) + 2 * _defaultPadding;
      final selectorWidthExtraSpace = selectorWidth >= expandedWidgetWidth ? 0 : expandedWidgetWidth - selectorWidth;
      final divider = widget.data.divider;
      final dividerAlternate = widget.data.dividerAlternate;
      final dividerHeight = constraints.maxHeight/widget.data.numDividers;

      return GestureDetector(
        onTapDown: (details) {
          final boundingIndex = MathUtils.findBoundingIndexInCartesianPlan(
              data,
              details.localPosition,
              Size(constraints.maxWidth, constraints.maxHeight));
          if (boundingIndex != -1) {
            final region = widget.data.sections[boundingIndex];

            widget.onSectionTap?.call(region);
            setState(() {
              _lastSelected = _selected;
              _lastSelectedIndex = _selectedIndex;
              _selected = region;
              _selectedIndex = boundingIndex;
            });
          }
        },
        child: Stack(
          children: [
            if (divider != null) Column(
              children: List.generate(widget.data.numDividers, (i) => Padding(
                padding: EdgeInsets.only(top: dividerHeight),
                child: i % 2 == 0 ? divider : (dividerAlternate ?? divider),
              )),
            ),
            Positioned(
              bottom: 0,
              left: ((selected ?? lastSelected)
                  ?.values
                  .map((e) => e.dx)
                  .reduce(min) ?? 0) - selectorWidthExtraSpace/2,
              child: AnimatedOpacity(
                opacity: selected != null && selectedIndex != null ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: _defaultPadding),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)
                    ),
                    color: selected?.selectionColor ?? lastSelected?.selectionColor,
                  ),
                  width: selectorWidth + selectorWidthExtraSpace,
                  height: selected != null || lastSelected != null
                      ? widget.data.maxY + 2 * _defaultPadding + ((selected ?? lastSelected)?.expandedWidget?.preferredSize.height ?? 0)
                      : 0,
                  child: ((selected ?? lastSelected)?.expandedWidget ?? const SizedBox.shrink()),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: selected != null && selectedIndex != null ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: CBSectionedLineWidget(
                  lineWidth: widget.data.lineWidth,
                  data: data,
                  lineColors: widget.data.sections.map((e) => e.lineColor).toList(),
                  areaColors: widget.data.sections
                      .map((e) => e.backgroundColor)
                      .toList()),
            ),
            AnimatedOpacity(
              opacity: selected != null && selectedIndex != null ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: CBSectionedLineWidget(
                  lineWidth: widget.data.lineWidth,
                  data: data,
                  lineColors: widget.data.sections
                      .map((e) => e == selected
                          ? e.lineColor
                          : e.lineColor.withOpacity(0.5))
                      .toList(),
                  areaColors: widget.data.sections
                      .map((e) => e == selected
                          ? e.backgroundColor
                          : e.backgroundColor.withOpacity(0.5))
                      .toList()),
            ),
            ...widget.data.sections
                .asMap()
                .entries
                .map((e) => _resolveSectionWidget(
                        e.value,
                        e.key <= widget.data.sections.length - 2
                            ? widget.data.sections[e.key + 1]
                            : null))
                .toList(),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleListener);
    super.dispose();
  }

  Widget _resolveSectionWidget(CBSectionedLineSection section, CBSectionedLineSection? nextSection) {
    final double rightOffset;
    if (nextSection != null) {
      rightOffset = nextSection.values.map((e) => e.dx).reduce(min);
    } else {
      rightOffset = section.values.map((e) => e.dx).reduce(max);
    }
    final leftOffset = section.values.map((e) => e.dx).reduce(min);
    final bottomOffset = section.values.map((e) => e.dy).reduce(max);
    final sectionWidth = rightOffset - leftOffset;
    final expandedWidget = section.expandedWidget;
    final collapsedWidget = section.collapsedWidget;

    if (expandedWidget != null && sectionWidth >= expandedWidget.preferredSize.width + 2 * _defaultPadding) {
      return Positioned(
          left: leftOffset + sectionWidth/2 - expandedWidget.preferredSize.width/2,
          bottom: bottomOffset + _defaultPadding,
          child: AnimatedOpacity(
              opacity: _selected != null ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: expandedWidget
          )
      );
    } else if (collapsedWidget != null) {
      return Positioned(
          left: leftOffset + sectionWidth/2 - collapsedWidget.preferredSize.width/2,
          bottom: bottomOffset + _defaultPadding,
          child: AnimatedOpacity(
              opacity: _selected != null ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: collapsedWidget
          )
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  double _resolveSelectorWidth(List<List<Offset>> data, CBSectionedLineSection? selected, int? selectedIndex,
      CBSectionedLineSection? lastSelected, int? lastSelectedIndex) {
    final double maxOffset;
    final double minOffset;

    if (selected == null && lastSelected == null) return 0;

    if (selected != null && selectedIndex != null) {
      if (selectedIndex <= data.length - 2) {
        maxOffset = data[selectedIndex + 1]
            .map((e) => e.dx)
            .reduce(min);
      } else {
        maxOffset = selected.values
            .map((e) => e.dx)
            .reduce(max);
      }
      minOffset = selected.values
          .map((e) => e.dx)
          .reduce(min);
    } else {
      if (lastSelectedIndex! <= data.length - 2) {
        maxOffset = data[lastSelectedIndex + 1]
            .map((e) => e.dx)
            .reduce(min);
      } else {
        maxOffset = lastSelected!.values
            .map((e) => e.dx)
            .reduce(max);
      }
      minOffset = lastSelected!.values
          .map((e) => e.dx)
          .reduce(min);
    }

    return maxOffset - minOffset;
  }

  void _handleListener() {
    setState(() {
      _lastSelected = _selected;
      _lastSelectedIndex = _selectedIndex;
      _selected = null;
      _selectedIndex = null;
    });
  }
}

class CBSectionedLineTimeLine extends StatelessWidget {
  final Widget? leading;
  final Widget Function(int index) onIndex;
  final int xAxisDivider;

  const CBSectionedLineTimeLine({super.key,
    required this.leading,
    required this.onIndex,
    required this.xAxisDivider
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth/xAxisDivider;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(xAxisDivider, (index) => SizedBox(
                width: width,
                child: Center(child: onIndex.call(index)))
            )
          ],
        );
      }
    );
  }
}

