import 'package:cb_charts_flutter/src/cb_ranking_chart/cb_ranking_controller.dart';
import 'package:cb_charts_flutter/src/cb_ranking_chart/cb_ranking_data.dart';
import 'package:flutter/widgets.dart';

class CBRankingChart extends StatefulWidget {
  /// The chart controller (use it to begin the animation, for example)
  final CBRankingController? controller;

  /// Horizontal or vertical direction (default vertical)
  final Axis direction;

  final Widget Function(String label, double value)? labelBuilder;

  /// The chart data
  final CBRankingData data;

  const CBRankingChart({super.key,
    this.controller,
    this.direction = Axis.vertical,
    this.labelBuilder,
    required this.data
  });

  @override
  State<CBRankingChart> createState() => _CBRankingChartState();
}

class _CBRankingChartState extends State<CBRankingChart> {
  bool _initialized = false;

  @override
  void initState() {
    widget.controller?.addListener(_listener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final bars = data.bars;
    bars.sort((a, b) => b.value.compareTo(a.value));
    final direction = widget.direction;
    final labelBuilder = widget.labelBuilder;

    return LayoutBuilder(builder: (context, constraints) {
      final maxLength = direction == Axis.vertical
          ? constraints.maxWidth
          : constraints.maxHeight;

      return Flex(
          direction: widget.direction,
          crossAxisAlignment: direction == Axis.vertical
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          spacing: data.barSpacing,
          children: bars.map((e) {
            final barLength = _initialized
                ? _calculateBarLength(e.value, data.maxValue, maxLength, data.labelLength)
                : 0.0;

            return Flex(
                direction: direction == Axis.vertical
                    ? Axis.horizontal
                    : Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (direction == Axis.horizontal) _buildLabel(direction, labelBuilder, e),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.decelerate,
                    height: direction == Axis.vertical ? data.barWidth : barLength,
                    width: direction == Axis.vertical ? barLength : data.barWidth,
                    decoration: e.decoration,
                    child: barLength >= data.minBarLengthToShowIcon
                        ? AnimatedOpacity(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.decelerate,
                            opacity: _initialized ? 1 : 0,
                            child: e.icon)
                        : null,
                  ),
                  if (direction == Axis.vertical) _buildLabel(direction, labelBuilder, e)
                ]);
          }).toList());
    });
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_listener);
    super.dispose();
  }

  Widget _buildLabel(
      Axis direction,
      Widget Function(String label, double value)? labelBuilder,
      CBRankingItem item) {
    return labelBuilder != null && _initialized
        ? TweenAnimationBuilder(
            duration: const Duration(milliseconds: 400),
            curve: Curves.decelerate,
            tween: Tween<double>(begin: 0.0, end: item.value),
            builder: (context, value, widget) => labelBuilder(item.label, value)
    )
        : const SizedBox.shrink();
  }

  double _calculateBarLength(double value, double maxValue, double maxLength, double labelLength) {
    return (value * (maxLength - labelLength))/maxValue;
  }

  void _listener() {
    setState(() {
      _initialized = true;
    });
  }
}
