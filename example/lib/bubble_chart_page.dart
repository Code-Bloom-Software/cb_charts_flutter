import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

class BubbleChartPage extends StatefulWidget {
  const BubbleChartPage({super.key});

  @override
  State<BubbleChartPage> createState() => _BubbleChartPageState();
}

class _BubbleChartPageState extends State<BubbleChartPage> {
  final _controller = CBBubbleController();

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
          title: const Text('Bubble chart'),
        ),
        body: Center(
          child: CBBubbleChart(
            controller: _controller,
            data: CBBubbleData(
              scale: CBBubbleScale.log,
              items: [
                CBBubbleItem(
                    label: 'Running',
                    color: const Color(0xFFED6926),
                    backgroundColor: Color.alphaBlend(const Color(0xFFED6926).withOpacity(0.2), Colors.white),
                    values: [0,1,0,1,3,9,4,0,5,7,10,2,8,3,1,7,5,9,4,6,0,10,8,2]
                ),
                CBBubbleItem(
                    label: 'Playing',
                    color: const Color(0xFF822E6C),
                    backgroundColor: Color.alphaBlend(const Color(0xFF822E6C).withOpacity(0.2), Colors.white),
                    values: [0,2,8,20,7,1,4,9,0,10,5,2,8,3,7,1,4,9,0,10,5,6,15,8]
                ),
                CBBubbleItem(
                    label: 'Sleeping',
                    color: const Color(0xFF009693),
                    backgroundColor: Color.alphaBlend(const Color(0xFF009693).withOpacity(0.2), Colors.white),
                    values: [30,10,0,1,5,2,8,4,0,6,10,3,7,1,5,2,8,4,0,6,10,9,3,7]
                ),
              ]
            ),
            onIndex: (index) =>
                Text('${index}h', style: const TextStyle(
                    fontSize: 10, color: Color(0xFF8A909C))),
            onLabel: (label) => Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              label,
              style: const TextStyle(fontSize: 14, color: Color(0xFF16223A)),
            ),
            onTap: (laneIndex, circleIndex, value) => CBBubbleTapWidget(
              anchor: const Offset(0, 0.5),
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
                ),
                width: 30,
                height: 30,
                child: Text(value.toString()),
              ),
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
