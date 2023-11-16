import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

class GaugeChartPage extends StatefulWidget {
  const GaugeChartPage({super.key});

  @override
  State<GaugeChartPage> createState() => _GaugeChartPageState();
}

class _GaugeChartPageState extends State<GaugeChartPage> {
  final _controller = CBGaugeController();

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gauge chart'),
      ),
      body: Center(
        child: CBGaugeChart(
          controller: _controller,
          centerInfoBuilder: (range) => Text(range.id),
          data: CBGaugeData(
              diameter: 300,
              width: 50,
              railColor: const Color(0xFFCCDDFF),
              value: 80,
              max: 100,
              ranges: [
                CBGaugeRange(id: 'Poor', color: const Color(0xFFED6926)),
                CBGaugeRange(id: 'Good', entryPoint: 50, color: const Color(0xFF009398)),
                CBGaugeRange(id: 'Excellent', entryPoint: 75, color: const Color(0xFF404EC8)),
              ],
              icon: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFF0000FF))),
              leftAxis: const Text('Low'),
              rightAxis: const Text('High')
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
