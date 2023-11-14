import 'package:flutter/material.dart';
import 'package:cb_charts_flutter/cb_charts_flutter.dart';

class SunburstChartPage extends StatefulWidget {
  const SunburstChartPage({super.key});

  @override
  State<SunburstChartPage> createState() => _SunburstChartPageState();
}

class _SunburstChartPageState extends State<SunburstChartPage> {
  final CBSunburstController _controller = CBSunburstController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _controller.dismiss(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Sunburst chart'),
        ),
        body: Center(
          child: CBSunburstChart(
            controller: _controller,
            centerInfoBuilder: (segment) => SizedBox(
                width: 100,
                child: Text(segment?.id ?? 'Nothing selected',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14))),
            data: CBSunburstData(
                diameter: 150,
                dividerWidth: 3,
                segments: [
                  CBSunburstSegment(
                      id: 'Medium intensity',
                      value: 20,
                      width: 30,
                      color: const Color(0xFFD499D5),
                      selectedColor: const Color(0xFFA933AB),
                      backgroundColor: Color.alphaBlend(Colors.white.withOpacity(0.8), const Color(0xFFA933AB)),
                      children: [
                        CBSunburstSegment(
                          id: 'Running',
                          value: 5,
                          width: 30,
                          color: const Color(0xFFBA5CBC),
                          selectedColor: const Color(0xFFA933AB),
                          backgroundColor: Color.alphaBlend(Colors.white.withOpacity(0.8), const Color(0xFFA933AB)),
                        ),
                        CBSunburstSegment(
                          id: 'Playing',
                          value: 10,
                          width: 30,
                          color: const Color(0xFFBA5CBC),
                          selectedColor: const Color(0xFFA933AB),
                          backgroundColor: Color.alphaBlend(Colors.white.withOpacity(0.8), const Color(0xFFA933AB)),
                          children: [
                            CBSunburstSegment(
                                id: 'Playing fetch',
                                value: 2,
                                width: 30,
                                color: const Color(0xFFA933AB),
                                selectedColor: const Color(0xFFA933AB),
                                backgroundColor: Color.alphaBlend(Colors.white.withOpacity(0.8), const Color(0xFFA933AB))
                            )
                          ]
                        ),
                      ]
                  ),
                  CBSunburstSegment(
                      id: 'Low intensity',
                      value: 30,
                      width: 30,
                      color: const Color(0xFFF49696),
                      selectedColor: const Color(0xFFE92E2E),
                      backgroundColor: Color.alphaBlend(Colors.white.withOpacity(0.8), const Color(0xFFE92E2E)),
                      children: [
                        CBSunburstSegment(
                            id: 'Sleeping',
                            value: 15,
                            width: 30,
                            color: const Color(0xFFED5858),
                            selectedColor: const Color(0xFFE92E2E),
                            backgroundColor: Color.alphaBlend(Colors.white.withOpacity(0.8), const Color(0xFFE92E2E))
                        )
                      ]
                  ),
                  CBSunburstSegment(
                      id: 'High intensity',
                      value: 5,
                      width: 30,
                      color: Color.alphaBlend(Colors.white.withOpacity(0.5), const Color(0xFF0056FF)),
                      selectedColor: const Color(0xFF0056FF),
                      backgroundColor: Color.alphaBlend(Colors.white.withOpacity(0.8), const Color(0xFF0056FF))
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
