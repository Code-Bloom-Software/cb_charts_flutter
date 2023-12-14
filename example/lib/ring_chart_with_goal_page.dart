import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

class RingChartWithGoalPage extends StatefulWidget {
  const RingChartWithGoalPage({super.key});

  @override
  State<RingChartWithGoalPage> createState() => _RingChartWithGoalPageState();
}

class _RingChartWithGoalPageState extends State<RingChartWithGoalPage> {
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
          title: const Text('Ring chart (with goal)'),
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
                      value: 10,
                      color: const Color(0xFF822E6C)
                  ),
                  CBRingChartSegment(
                      label: 'Playing',
                      value: 30,
                      color: const Color(0xFF009693)
                  ),
                ],
                goal: 100
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
