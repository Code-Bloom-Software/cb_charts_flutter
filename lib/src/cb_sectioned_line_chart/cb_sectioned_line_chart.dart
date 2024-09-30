import 'dart:math';

import 'package:cb_charts_flutter/src/cb_sectioned_line_chart/cb_sectioned_line_components.dart';
import 'package:cb_charts_flutter/src/cb_sectioned_line_chart/cb_sectioned_line_controller.dart';
import 'package:cb_charts_flutter/src/cb_sectioned_line_chart/cb_sectioned_line_data.dart';
import 'package:cb_charts_flutter/src/utils/math_utils.dart';
import 'package:flutter/material.dart';

const _defaultPadding = 8.0;

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
  void didUpdateWidget(covariant CBSectionedLineChart oldWidget) {
    if (oldWidget.data != widget.data) {
      _lastSelected = _selected;
      _lastSelectedIndex = _selectedIndex;
      _selected = null;
      _selectedIndex = null;
    }
    super.didUpdateWidget(oldWidget);
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
      final selectorWidthExtraSpace = selectorWidth >= expandedWidgetWidth ? 0.0 : expandedWidgetWidth - selectorWidth;
      final divider = widget.data.divider;
      final dividerAlternate = widget.data.dividerAlternate;
      final dividerHeight = constraints.maxHeight/widget.data.numDividers;
      final selectorLeftPosition = ((selected ?? lastSelected)
          ?.values
          .map((e) => e.dx)
          .reduce(min) ?? 0) - selectorWidthExtraSpace/2;

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
              left: selectorLeftPosition.clamp(0, constraints.maxWidth - selectorWidth - selectorWidthExtraSpace),
              child: AnimatedOpacity(
                opacity: selected != null && selectedIndex != null ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: CBSectionedLineSelection(
                    maxWidth: constraints.maxWidth,
                    maxY: widget.data.maxY,
                    lineWidth: widget.data.lineWidth,
                    selectorLeftPosition: selectorLeftPosition,
                    selectorWidth: selectorWidth,
                    selectorWidthExtraSpace: selectorWidthExtraSpace,
                    lineColor: selected?.lineColor ?? lastSelected?.lineColor,
                    backgroundColor: selected?.backgroundColor ?? lastSelected?.backgroundColor,
                    selected: selected,
                    lastSelected: lastSelected
                )
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
                          : e.lineColor.withOpacity(0.25))
                      .toList(),
                  areaColors: widget.data.sections
                      .map((e) => e == selected
                          ? e.backgroundColor
                          : e.backgroundColor.withOpacity(0.25))
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
    final nextSectionDy = nextSection != null && nextSection.values.isNotEmpty ? nextSection.values[0].dy : 0.0;
    final leftOffset = section.values.map((e) => e.dx).reduce(min);
    final bottomOffset = max(section.values.map((e) => e.dy).reduce(max), nextSectionDy);
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

    return maxOffset - minOffset >= 0 ? maxOffset - minOffset : 0;
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
                child: Container(
                    alignment: Alignment.centerRight,
                    child: FractionalTranslation(
                        translation: const Offset(0.5, 0),
                        child: onIndex.call(index)))))
          ],
        );
      }
    );
  }
}

class CBSectionedLineSelection extends StatelessWidget {
  final double maxWidth;
  final double maxY;
  final double lineWidth;
  final double selectorLeftPosition;
  final double selectorWidth;
  final double selectorWidthExtraSpace;
  final Color? lineColor;
  final Color? backgroundColor;
  final CBSectionedLineSection? selected;
  final CBSectionedLineSection? lastSelected;

  const CBSectionedLineSelection({super.key,
    required this.maxWidth,
    required this.maxY,
    required this.lineWidth,
    required this.selectorLeftPosition,
    required this.selectorWidth,
    required this.selectorWidthExtraSpace,
    required this.lineColor,
    required this.backgroundColor,
    required this.selected,
    required this.lastSelected
  });

  @override
  Widget build(BuildContext context) {
    final color = selected?.selectionColor ?? lastSelected?.selectionColor;
    final lineColor = this.lineColor;
    final backgroundColor = this.backgroundColor;
    const overSelectionHeight = 22.0;
    final maxOffset = maxWidth - selectorWidth - selectorWidthExtraSpace;
    final Offset fixPositionOffset;
    if (selectorLeftPosition < 0) {
      fixPositionOffset = Offset(selectorLeftPosition, 0);
    } else if (selectorLeftPosition > maxOffset) {
      fixPositionOffset = Offset(selectorLeftPosition - maxOffset, 0);
    } else {
      fixPositionOffset = Offset.zero;
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Transform.translate(
          offset: fixPositionOffset,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                padding: const EdgeInsets.only(top: _defaultPadding),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)
                    ),
                    gradient: color != null ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [color, color.withOpacity(0.3)],
                        stops: const [0.35, 1]
                    ) : null
                ),
                width: selectorWidth,
                height: selected != null || lastSelected != null
                    ? maxY + 2 * _defaultPadding + ((selected ?? lastSelected)?.expandedWidget?.preferredSize.height ?? 0)
                    : 0,
              ),
              Transform.translate(
                offset: const Offset(0, overSelectionHeight),
                child: ShaderMask(
                  blendMode: BlendMode.dstATop,
                  shaderCallback: (rect) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.transparent],
                  ).createShader(rect),
                  child: Container(
                    decoration: lineColor != null ? BoxDecoration(
                      color: backgroundColor,
                    ) : null,
                    height: overSelectionHeight,
                    width: selectorWidth,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: _defaultPadding),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: color
          ),
          width: selectorWidth + selectorWidthExtraSpace,
          height: selected != null || lastSelected != null
              ? 2 * _defaultPadding + ((selected ?? lastSelected)?.expandedWidget?.preferredSize.height ?? 0)
              : 0,
          child: ((selected ?? lastSelected)?.expandedWidget ?? const SizedBox.shrink()),
        ),
      ],
    );
  }
}
