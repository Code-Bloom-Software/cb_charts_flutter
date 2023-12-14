import 'package:cb_charts_flutter/src/cb_legends_chart/cb_legends_data.dart';
import 'package:flutter/material.dart';

/// It draws a legend chart. See a demo inside the example app.
class CBLegendsChart extends StatefulWidget {
  /// The chart data
  final CBLegendsData data;

  /// Builder to draw the header title
  final Widget Function(double total, double? goal) headerTitleBuilder;

  /// Widget used as chevron on header
  final Widget? chevron;

  /// Builder to draw the label of an item
  final Widget Function(String label) itemLabelBuilder;

  /// Builder to draw the value of an item
  final Widget Function(double value) itemValueBuilder;

  const CBLegendsChart({super.key,
    required this.data,
    required this.headerTitleBuilder,
    this.chevron,
    required this.itemLabelBuilder,
    required this.itemValueBuilder
  });

  @override
  State<CBLegendsChart> createState() => _CBLegendsChartState();
}

class _CBLegendsChartState extends State<CBLegendsChart> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  bool _expanded = false;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = widget.data.headerHeight;
    final itemHeight = widget.data.itemHeight;
    final dividerColor = widget.data.dividerColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(height: 0, thickness: 1, color: dividerColor),
        GestureDetector(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
              if (_expanded) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            },
            child: ChartLegendsHeader(
              data: widget.data,
              headerTitleBuilder: widget.headerTitleBuilder,
              headerHeight: headerHeight,
              animatedChevron: widget.chevron != null ? AnimatedRotation(
                turns: _expanded ? 1 / 2 : 0,
                duration: const Duration(milliseconds: 300),
                child: widget.chevron,
              ) : const SizedBox.shrink(),
            )),
        AnimatedOpacity(
            opacity: _expanded ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.decelerate,
            child: Divider(height: 0, thickness: 1, color: dividerColor)
        ),
        ClipRect(
          child: SizeTransition(
            sizeFactor: _animation,
            child: AnimatedSlide(
              offset: _expanded ? Offset.zero : const Offset(0, -1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
              child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return ChartLegendsRow(
                        item: widget.data.items[i],
                        itemLabelBuilder: widget.itemLabelBuilder,
                        itemValueBuilder: widget.itemValueBuilder,
                        itemHeight: itemHeight,
                        max: widget.data.max
                    );
                  },
                  separatorBuilder: (context, i) => Divider(height: 0, thickness: 1, color: dividerColor),
                  itemCount: widget.data.items.length),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class ChartLegendsHeader extends StatelessWidget {
  final CBLegendsData data;
  final Function(double total, double? goal) headerTitleBuilder;
  final double headerHeight;
  final Widget animatedChevron;

  const ChartLegendsHeader({super.key,
    required this.data,
    required this.headerTitleBuilder,
    required this.headerHeight,
    required this.animatedChevron
  });

  @override
  Widget build(BuildContext context) {
    final sum = data.items.map((e) => e.value).reduce((value, element) => value + element);

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: headerHeight,
      child: Row(
        children: [
          _buildMarkers(),
          const SizedBox(width: 8),
          headerTitleBuilder.call(sum, data.goal),
          const Spacer(),
          animatedChevron
        ],
      ),
    );
  }

  Widget _buildMarkers() {
    final upperBound = data.items.length > 3 ? 3 : data.items.length;
    final markers = data.items.sublist(0, upperBound);

    return SizedBox(
      width: 40,
      height: 24,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: markers.asMap().entries.map((e) => Container(
          height: 24,
          width: 24,
          margin: EdgeInsets.only(left: 8.0 * e.key),
          decoration: BoxDecoration(
              color: e.value.color,
              shape: BoxShape.circle
          ),
        )).toList(),
      ),
    );
  }
}

class ChartLegendsRow extends StatelessWidget {
  final CBLegendsItem item;
  final Widget Function(String label) itemLabelBuilder;
  final Widget Function(double value) itemValueBuilder;
  final double itemHeight;
  final double max;

  const ChartLegendsRow({super.key,
    required this.item,
    required this.itemLabelBuilder,
    required this.itemValueBuilder,
    required this.itemHeight,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: itemHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        final spaceWidth = constraints.maxWidth;

        return Row(
          children: [
            SizedBox(
              width: 0.37 * spaceWidth,
              child: itemLabelBuilder.call(item.label),
            ),
            _buildBar(width: 0.35 * spaceWidth),
            const Spacer(),
            itemValueBuilder.call(item.value)
          ],
        );
      }),
    );
  }

  Widget _buildBar({required double width}) => Stack(
    children: [
      Container(
        width: width,
        height: 16,
        decoration: const BoxDecoration(
            color: Color(0xFFE5EEFF),
            borderRadius: BorderRadius.all(Radius.circular(16))
        ),
      ),
      Container(
        width: width * (item.value/max),
        height: 16,
        decoration: BoxDecoration(
            color: item.color,
            borderRadius: const BorderRadius.all(Radius.circular(16))
        ),
      ),
    ],
  );
}
