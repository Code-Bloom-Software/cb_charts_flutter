import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

class LegendsPageWithGoalPage extends StatefulWidget {
  const LegendsPageWithGoalPage({super.key});

  @override
  State<LegendsPageWithGoalPage> createState() => _LegendsPageWithGoalPageState();
}

class _LegendsPageWithGoalPageState extends State<LegendsPageWithGoalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Legends chart (with goal)'),
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CBLegendsChart(
              data: CBLegendsData(
                  goal: 100,
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
              headerTitleBuilder: (total, goal) => Text('${((total/goal!) * 100).toInt()}%'),
              itemLabelBuilder: (label) => Text(label),
              itemValueBuilder: (value) => Text(value.toInt().toString()),
            ),
          )
      ),
    );
  }
}
