import 'dart:math';

import 'package:cb_charts_flutter/src/cb_bubble_chart/cb_bubble_controller.dart';
import 'package:cb_charts_flutter/src/cb_bubble_chart/cb_bubble_data.dart';
import 'package:flutter/material.dart';

const _horizontalPadding = 24.0;
const _verticalPadding = 8.0;

/// It draws a bubble chart. See a demo inside the example app.
class CBBubbleChart extends StatefulWidget {

  /// The chart controller (use it to begin the animation, for example)
  final CBBubbleController? controller;

  /// The scroll controller used by the chart
  final ScrollController? scrollController;

  /// The chart data
  final CBBubbleData data;

  /// An optional leading to the time line
  final Widget? timeLineLeading;

  /// A builder for each x-axis index
  final Widget Function(int index) onIndex;

  /// A builder for each row label
  final Widget Function(String label) onLabel;

  /// An optional builder to show a widget when the user taps the bubble
  final CBBubbleTapWidget Function(int laneIndex, int circleIndex, double value)? onTap;

  const CBBubbleChart({super.key,
    this.controller,
    this.scrollController,
    required this.data,
    this.timeLineLeading,
    required this.onIndex,
    required this.onLabel,
    this.onTap
  });

  @override
  State<CBBubbleChart> createState() => _CBBubbleChartState();
}

class _CBBubbleChartState extends State<CBBubbleChart> {
  SelectedPair? _selectedPair;
  CBBubbleTapWidget? _selectedWidget;
  bool _initialized = false;

  @override
  void initState() {
    widget.controller?.addListener(_handleListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.data.items;
    final selectedPair = _selectedPair;
    final selectedWidget = _selectedWidget;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPair = null;
          _selectedWidget = null;
        });
      },
      child: SingleChildScrollView(
        controller: widget.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .asMap()
                  .entries
                  .map((e) => Padding(padding: const EdgeInsets.only(bottom: _verticalPadding),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: (_selectedPair?.itemIndex ?? e.key) == e.key ? 1.0 : 0.2,
                    child: CBBubbleChartRow(onLabel: widget.onLabel,
                        data: widget.data,
                        item: e.value,
                        selected: _selectedPair?.itemIndex == e.key ? _selectedPair : null,
                        percentage: _selectedPair != null
                            ? _calculatePercentage(
                            data: widget.data,
                            itemIndex: _selectedPair!.itemIndex,
                            circleIndex: _selectedPair!.circleIndex)
                            : 0,
                        circles: e.value.values.asMap()
                            .entries
                            .map((e2) => GestureDetector(
                          onTap: () => _handleTap(e.key, e2.key),
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            width: widget.data.maxDiameter,
                            height: widget.data.maxDiameter,
                            child: CBBubbleChartCircle(
                                initialized: _initialized,
                                data: widget.data,
                                selected: _selectedPair?.itemIndex == e.key && _selectedPair?.circleIndex == e2.key,
                                item: e.value,
                                percentage: _calculatePercentage(
                                    data: widget.data,
                                    itemIndex: e.key,
                                    circleIndex: e2.key)),
                          ),
                        )).toList()),
                  )))
                  .toList()..add(Padding(
                padding: EdgeInsets.zero,
                child: CBBubbleChartTimeLine(
                  leading: widget.timeLineLeading,
                  onIndex: widget.onIndex,
                  data: widget.data
                ),
              )),
            ),
            if (selectedWidget != null && selectedPair != null) Positioned(
                left: _horizontalPadding +
                    widget.data.labelWidth +
                    selectedPair.circleIndex *
                        widget.data.maxDiameter *
                        (1 - widget.data.percentOverlap) +
                    widget.data.maxDiameter / 2,
                top: widget.data.maxDiameter * selectedPair.itemIndex +
                    _verticalPadding * selectedPair.itemIndex +
                    widget.data.maxDiameter / 2,
                child: FractionalTranslation(
                  translation: Offset(-0.5 + selectedWidget.anchor.dx, -0.5 + selectedWidget.anchor.dy),
                  child: selectedWidget.child,
                )
              )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleListener);
    super.dispose();
  }

  void _handleListener() {
    final controller = widget.controller;

    if (controller != null) {
      switch (controller.op) {
        case CBBubbleControllerOp.forward:
          setState(() {
            _initialized = true;
          });
          break;
        case CBBubbleControllerOp.dismiss:
          setState(() {
            _selectedPair = null;
            _selectedWidget = null;
          });
          break;
      }
    }
  }

  void _handleTap(int itemIndex, int circleIndex) {
    setState(() {
      _selectedPair = SelectedPair(itemIndex, circleIndex);
      _selectedWidget = widget.onTap?.call(itemIndex, circleIndex,
          widget.data.items[itemIndex].values[circleIndex]);
    });
  }

  double _calculatePercentage({required CBBubbleData data, required int itemIndex, required int circleIndex}) {
    final total = data.xAxisMax ?? data.items.map((e) => e.values[circleIndex]).reduce((value, element) => value + element);

    if (total <= 0) return 0;
    final ratio = (data.items[itemIndex].values[circleIndex]/total).clamp(0.0, 1.0);

    switch(data.scale) {
      case CBBubbleScale.linear:
        return ratio;
      case CBBubbleScale.log:
        return log(1 + ratio) / log(2);
      case CBBubbleScale.sqrt:
        return sqrt(ratio);
      case CBBubbleScale.cbrt:
        return pow(ratio, 1/3).toDouble();
      case CBBubbleScale.pow:
        return pow(ratio, data.scalePowExponent).toDouble();
    }
  }
}

class CBBubbleChartTimeLine extends StatelessWidget {
  final Widget? leading;
  final Widget Function(int index) onIndex;
  final CBBubbleData data;

  const CBBubbleChartTimeLine({super.key,
    required this.leading,
    required this.onIndex,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
    final totalWidth = data.items[0].values.length *
        data.maxDiameter *
        (1 - data.percentOverlap) +
        data.maxDiameter * data.percentOverlap;

    return Row(
      children: [
        const SizedBox(width: _horizontalPadding),
        leading != null ? SizedBox(width:data.labelWidth, child: leading!) : const SizedBox(width: 100),
        Stack(alignment: Alignment.center, children: [
          SizedBox(width: totalWidth, height: data.maxDiameter),
          ...data.items[0].values
              .asMap()
              .keys
              .map((e) => Positioned(
              left: e * data.maxDiameter * (1 - data.percentOverlap),
              child: Container(
                  alignment: Alignment.center,
                  height: 32,
                  width: data.maxDiameter,
                  child: onIndex.call(e))))
              .toList()
        ])
      ],
    );
  }
}

class CBBubbleChartRow extends StatelessWidget {
  final Widget Function(String label) onLabel;
  final List<Widget> circles;
  final CBBubbleData data;
  final CBBubbleItem item;
  final SelectedPair? selected;
  final double percentage;

  const CBBubbleChartRow({super.key,
    required this.onLabel,
    required this.circles,
    required this.data,
    required this.item,
    required this.selected,
    required this.percentage
  });

  @override
  Widget build(BuildContext context) {
    final totalWidth = circles.length * data.maxDiameter * (1 - data.percentOverlap) +
        data.maxDiameter * data.percentOverlap;
    final selected = this.selected;
    final diameter = (percentage * data.maxDiameter).clamp(data.minDiameter,
        selected != null ? data.maxDiameter - 10 : data.maxDiameter);
    final rowColor = item.backgroundColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      decoration: BoxDecoration(
          color: rowColor,
          borderRadius: const BorderRadius.all(Radius.circular(16))
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: data.labelWidth, child: onLabel.call(item.label)),
          Stack(children: [
            SizedBox(width: totalWidth, height: data.maxDiameter),
            ...circles.asMap().entries.map((e) => Positioned(
                left: e.key * data.maxDiameter * (1 - data.percentOverlap),
                child: e.value)),
            if (selected != null) _buildSelection(selected, diameter, rowColor)
          ])
        ],
      ),
    );
  }

  Widget _buildSelection(SelectedPair selected, double diameter, Color rowColor) => Positioned( // Selection
      left: selected.circleIndex * data.maxDiameter * (1 - data.percentOverlap),
      child: Container(
        alignment: Alignment.center,
        height: data.maxDiameter,
        width: data.maxDiameter,
        child: Container(
          alignment: Alignment.center,
          height: diameter + 8,
          width: diameter + 8,
          decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle),
          child: Container(
            alignment: Alignment.center,
            height: diameter + 4,
            width: diameter + 4,
            decoration: BoxDecoration(
                color: rowColor,
                shape: BoxShape.circle),
            child: Container(
                alignment: Alignment.center,
                height: diameter,
                width: diameter,
                decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle)),
          ),
        ),
      )
  );
}

class CBBubbleChartCircle extends StatelessWidget {
  final bool initialized;
  final bool selected;
  final double percentage;
  final CBBubbleItem item;
  final CBBubbleData data;

  const CBBubbleChartCircle({super.key,
    required this.initialized,
    required this.selected,
    required this.percentage,
    required this.item,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
    final diameter = (percentage * data.maxDiameter).clamp(data.minDiameter,
        selected ? data.maxDiameter - 10 : data.maxDiameter);

    final circle = AnimatedContainer(
      duration: Duration(milliseconds: selected ? 0 : 600),
      curve: const ElasticInCurve(1.0),
      height: initialized ? diameter : data.minDiameter,
      width: initialized ? diameter : data.minDiameter,
      decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
    );

    return selected
        ? Container(
        alignment: Alignment.center,
        height: diameter + 8,
        width: diameter + 8,
        decoration: BoxDecoration(
            border: Border.all(color: item.color, width: 2),
            shape: BoxShape.circle),
        child: circle)
        : circle;
  }
}

class SelectedPair {
  final int itemIndex;
  final int circleIndex;

  SelectedPair(this.itemIndex, this.circleIndex);
}
