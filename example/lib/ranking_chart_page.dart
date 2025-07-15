import 'dart:math';

import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

class RankingChartPage extends StatefulWidget {
  const RankingChartPage({super.key});

  @override
  State<RankingChartPage> createState() => _RankingChartPageState();
}

class _RankingChartPageState extends State<RankingChartPage> {
  final _controller = CBRankingController();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 2000)).then((_) {
      if (!mounted) return;
      _controller.forward();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
        topRight: Radius.circular(10),
        bottomRight: Radius.circular(10)
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gauge chart'),
        leading: IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.update)
        ),
      ),
      body: Center(
        child: Container(
          height: 500,
          width: 500,
          color: Colors.black.withOpacity(0.1),
          child: CBRankingChart(
            controller: _controller,
            direction: Axis.vertical,
            labelBuilder: (label, value) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text('$label: ${value.toInt()}'),
            ),
            data: CBRankingData(
                maxValue: 100,
                barWidth: 50,
                barSpacing: 5,
                minBarLengthToShowIcon: 150,
                labelLength: 100,
                bars: [
                  CBRankingItem(
                      label: 'Walking',
                      decoration: const BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: borderRadius
                      ),
                      value: Random().nextInt(100).toDouble()
                  ),
                  CBRankingItem(
                      label: 'Resting',
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Align(alignment: Alignment.centerRight, child: Icon(Icons.add)),
                      ),
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: borderRadius
                      ),
                      value: Random().nextInt(100).toDouble()
                  ),
                  CBRankingItem(
                      label: 'Sleeping',
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: borderRadius
                      ),
                      value: Random().nextInt(100).toDouble()
                  ),
                  CBRankingItem(
                      label: 'Running',
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: borderRadius
                      ),
                      value: Random().nextInt(100).toDouble()
                  )
                ]
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
