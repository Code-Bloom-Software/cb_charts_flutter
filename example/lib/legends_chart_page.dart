import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

class LegendsChartPage extends StatefulWidget {
  const LegendsChartPage({super.key});

  @override
  State<LegendsChartPage> createState() => _LegendsChartPageState();
}

class _LegendsChartPageState extends State<LegendsChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Legends chart'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: CBLegendsChart(
            data: CBLegendsData(
                items: [
                  CBLegendsItem(label: 'Sleeping',
                      value: 40,
                      color: const Color(0xFFED6926)),
                  CBLegendsItem(label: 'Running',
                      value: 10,
                      color: const Color(0xFF822E6C)),
                  CBLegendsItem(label: 'Playing',
                      value: 20,
                      color: const Color(0xFF009693)),
                ]
            ),
            chevron: const Icon(Icons.arrow_drop_down_outlined, size: 32),
            headerTitleBuilder: (total, _) => Text('${total.toInt()}'),
            itemLabelBuilder: (label) => Text(label),
            itemValueBuilder: (value) => Text(value.toInt().toString()),
          ),
        )
      ),
    );
  }
}
