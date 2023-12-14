import 'dart:math';

import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

class RingChartOverGoalPage extends StatefulWidget {
  const RingChartOverGoalPage({super.key});

  @override
  State<RingChartOverGoalPage> createState() => _RingChartOverGoalPageState();
}

class _RingChartOverGoalPageState extends State<RingChartOverGoalPage> {
  final _controller = CBRingChartController();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 600)).then((_) {
      if (!mounted) return;
      _controller.forward();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _controller.dismiss(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Ring chart (over goal)'),
        ),
        body: Center(
          child: CBRingChart(
            controller: _controller,
            data: CBRingChartData(
                segments: [
                  CBRingChartSegment(
                      label: 'Sleeping',
                      value: 40,
                      color: const Color(0xFFED6926)
                  ),
                  CBRingChartSegment(
                      label: 'Running',
                      value: 40,
                      color: const Color(0xFF822E6C)
                  ),
                  CBRingChartSegment(
                      label: 'Playing',
                      value: 30,
                      color: const Color(0xFF009693)
                  ),
                ],
                goal: 100,
                overGoal: CBRingChartOverGoal(
                    alignment: const Alignment(-0.45, -1),
                    size: const Size(90, 45),
                    child: const OverGoalWidgetMarker()
                )
            ),
            buildLabel: (animPercentage, segmentsTotal, chartMax) {
              final value = ((segmentsTotal / chartMax) * 100 * animPercentage).toInt();

              return Text('$value%');
            },
            onSelected: (segment, chartMax) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(segment.label),
                Text('${(segment.value/chartMax * 100).toInt()}%')
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class OverGoalWidgetMarker extends StatelessWidget {
  const OverGoalWidgetMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(-0.5, 1.0),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              width: 90,
              height: 30,
              decoration: const BoxDecoration(
                  color: Color(0xFF0056FF),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: const Text('Over Goal',
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
            const SizedBox(height: 4),
          ],
        ),
        Transform.rotate(
          angle: pi / 4,
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(color: Color(0xFF0056FF)),
          ),
        ),
      ],
    );
  }
}

