import 'package:flutter/widgets.dart';

class SunburstChart extends StatefulWidget {
  const SunburstChart({super.key});

  @override
  State<SunburstChart> createState() => _SunburstChartState();
}

class _SunburstChartState extends State<SunburstChart> {
  @override
  Widget build(BuildContext context) {
    return Container(color: const Color(0xFF000000), width: 100, height: 100);
  }
}
