import 'package:cb_charts_flutter/src/cb_sunburst_chart/cb_sunburst_components.dart';
import 'package:cb_charts_flutter/src/cb_sunburst_chart/cb_sunburst_controller.dart';
import 'package:cb_charts_flutter/src/cb_sunburst_chart/cb_sunburst_data.dart';
import 'package:cb_charts_flutter/src/utils/math_utils.dart';
import 'package:flutter/widgets.dart';

/// It draws a sunburst chart. See a demo inside the example app.
class CBSunburstChart extends StatefulWidget {
  /// The chart controller (use it to dismiss a selection, for example)
  final CBSunburstController? controller;

  /// The chart data
  final CBSunburstData data;

  /// An optional builder to implement a widget that is shown in the chart center
  final Widget Function(CBSunburstSegment? segment)? centerInfoBuilder;

  const CBSunburstChart({super.key,
    this.controller,
    required this.data,
    this.centerInfoBuilder
  });

  @override
  State<CBSunburstChart> createState() => _CBSunburstChartState();
}

class _CBSunburstChartState extends State<CBSunburstChart> {
  CBSunburstSegment? _lastSelected;
  CBSunburstSegment? _selected;
  final List<CBSunburstSegment> _selectedParents = [];

  @override
  void initState() {
    widget.controller?.addListener(_dismiss);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final segments = widget.data.segments;
    final total = MathUtils.calcTotal(segments.map((e) => e.value).toList());

    return Stack(
      alignment: Alignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: _build(0, 1, total, 0, segments)
        ),
        widget.centerInfoBuilder?.call(_selected) ?? const SizedBox.shrink()
      ],
    );
  }

  List<Widget> _build(double fromChild, double toChild, double totalChild, int layer, List<CBSunburstSegment> segments) {
    if (segments.isEmpty) {
      return [];
    }
    return segments.asMap().entries.map((entry) {
          final index = entry.key;
          final segment = entry.value;
          final width = segment.width;
          final Color curColor;
          final Color newColor;
          final values = segments.map((e) => e.value).toList();
          final range = toChild - fromChild;
          final from = range * MathUtils.calcFromPercentage(values, index, max: totalChild) + fromChild;
          final to = range * MathUtils.calcToPercentage(values, index, max: totalChild) + fromChild;

          curColor = _lastSelected != null ? _lastSelected!.color : segment.color;
          if (_selected != null) {
            if (_selected?.id == segment.id) {
              newColor = segment.selectedColor;
            } else {
              if (_selectedParents.map((e) => e.id).contains(segment.id)) {
                newColor = segment.color;
              } else {
                newColor = segment.backgroundColor;
              }
            }
          } else {
            newColor = segment.color;
          }

          return [
            GestureDetector(
              onTap: () {
                setState(() {
                  _lastSelected = _selected;
                  _selected = segment;
                  _selectedParents.clear();
                  CBSunburstSegment? parent = segment.parent;
                  while (parent != null) {
                    _selectedParents.add(parent);
                    parent = parent.parent;
                  }
                });
              },
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 200),
                curve: Curves.decelerate,
                tween: ColorTween(
                  begin: curColor,
                  end: newColor
                ),
                builder: (context, color, child) => CBSunburstSegmentWidget(
                    id: segment.id,
                    diameter: widget.data.diameter + 2 * (layer * width) + (layer * widget.data.dividerWidth),
                    width: width,
                    dividerWidth: widget.data.dividerWidth,
                    color: color!,
                    fromPercentage: from,
                    toPercentage: to),
              ),
            ),
            ..._build(from, to, segment.value, layer + 1, segment.children)
          ];
        })
        .expand((element) => element)
        .toList();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_dismiss);
    super.dispose();
  }

  void _dismiss() {
    setState(() {
      _lastSelected = _selected;
      _selected = null;
      _selectedParents.clear();
    });
  }
}
