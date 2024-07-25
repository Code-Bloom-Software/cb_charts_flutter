import 'dart:math';

import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

class StackedCircleChartPage extends StatefulWidget {
  const StackedCircleChartPage({super.key});

  @override
  State<StackedCircleChartPage> createState() => _StackedCircleChartPageState();
}

class _StackedCircleChartPageState extends State<StackedCircleChartPage> {
  final CbStackedCircleController _controller = CbStackedCircleController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _controller.dismiss(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Stacked circle chart'),
          ),
          body: Center(
            child: CbStackedCircleChart(
              controller: _controller,
              alignment: Alignment.bottomRight,
              data: CbStackedCircleData(
                minDiameter: 50,
                maxDiameter: 327,
                circles: [
                  CBStackedCircleItem(label: 'Walking', color: const Color(0xFF404EC8), value: 327),
                  CBStackedCircleItem(label: 'D. Care', color: const Color(0xFF822E6C), value: 20),
                  CBStackedCircleItem(label: 'Apartment', color: const Color(0xFFD9F79F), value: 268),
                  CBStackedCircleItem(label: 'At Home', color: const Color(0xFFFE5801), value: 204),
                ],
              ),
              labelBuilder: (curDiameter, nextDiameter, circle) => Align(
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.center,
                  width: nextDiameter - curDiameter / 2 < 0
                    ? curDiameter
                    : 2 * sqrt(pow(curDiameter / 2, 2) - pow(nextDiameter - curDiameter / 2, 2)),
                  height: curDiameter - nextDiameter,
                  child: Text(circle.label),
                ),
              ),
            )
          )
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
