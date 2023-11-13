import 'package:flutter/material.dart';
import 'package:cb_charts_flutter/cb_charts_flutter.dart';

class SunburstChartPage extends StatefulWidget {
  const SunburstChartPage({super.key});

  @override
  State<SunburstChartPage> createState() => _SunburstChartPageState();
}

class _SunburstChartPageState extends State<SunburstChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Sunburst chart'),
      ),
      body: Center(
        child: SunburstChart(),
      ),
    );
  }
}
