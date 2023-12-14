import 'package:example/bubble_chart_page.dart';
import 'package:example/gauge_chart_page.dart';
import 'package:example/legends_chart_page.dart';
import 'package:example/legends_chart_with_goal_page.dart';
import 'package:example/ring_chart_over_goal_page.dart';
import 'package:example/ring_chart_page.dart';
import 'package:example/ring_chart_with_goal_page.dart';
import 'package:example/sunburst_chart_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CB Charts Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CB Charts Flutter Demo'),
      initialRoute: "/",
      routes: {
        '/sunburst_chart_page': (context) => const SunburstChartPage(),
        '/gauge_chart_page': (context) => const GaugeChartPage(),
        '/ring_chart_page': (context) => const RingChartPage(),
        '/ring_chart_with_goal_page': (context) => const RingChartWithGoalPage(),
        '/ring_chart_over_goal_page': (context) => const RingChartOverGoalPage(),
        '/legends_chart_page': (context) => const LegendsChartPage(),
        '/legends_chart_with_goal_page': (context) => const LegendsPageWithGoalPage(),
        '/bubble_chart_page': (context) => const BubbleChartPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Sunburst chart'),
            onTap: () {
              Navigator.pushNamed(context, '/sunburst_chart_page');
            },
          ),
          ListTile(
            title: const Text('Gauge chart'),
            onTap: () {
              Navigator.pushNamed(context, '/gauge_chart_page');
            },
          ),
          ListTile(
            title: const Text('Ring chart'),
            onTap: () {
              Navigator.pushNamed(context, '/ring_chart_page');
            },
          ),
          ListTile(
            title: const Text('Ring chart (with goal)'),
            onTap: () {
              Navigator.pushNamed(context, '/ring_chart_with_goal_page');
            },
          ),
          ListTile(
            title: const Text('Ring chart (over goal)'),
            onTap: () {
              Navigator.pushNamed(context, '/ring_chart_over_goal_page');
            },
          ),
          ListTile(
            title: const Text('Legends chart'),
            onTap: () {
              Navigator.pushNamed(context, '/legends_chart_page');
            },
          ),
          ListTile(
            title: const Text('Legends chart (with goal)'),
            onTap: () {
              Navigator.pushNamed(context, '/legends_chart_with_goal_page');
            },
          ),
          ListTile(
            title: const Text('Bubble chart'),
            onTap: () {
              Navigator.pushNamed(context, '/bubble_chart_page');
            },
          ),
        ],
      )
    );
  }
}
