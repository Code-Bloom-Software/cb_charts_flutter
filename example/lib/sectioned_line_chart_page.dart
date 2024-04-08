import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

class SectionedLineChartPage extends StatefulWidget {
  const SectionedLineChartPage({super.key});

  @override
  State<SectionedLineChartPage> createState() => _SectionedLineChartPageState();
}

class _SectionedLineChartPageState extends State<SectionedLineChartPage> {
  final _controller = CBSectionedLineController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.dismiss();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Sectioned line chart'),
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 800, height: 250,
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: CBSectionedLineChart(
                      controller: _controller,
                      data: CBSectionedLineData(
                          divider: const Divider(height: 0, thickness: 1, color: Colors.blue),
                          dividerAlternate: Divider(height: 0, thickness: 1, color: Colors.blue.withOpacity(0.5)),
                          xAxisDivider: 12,
                          sections: [
                            CBSectionedLineSection(
                                label: 'Home',
                                lineColor: const Color(0xFF009693),
                                backgroundColor: Color.alphaBlend(const Color(0xFF009693).withOpacity(0.3), Colors.white),
                                selectionColor: Color.alphaBlend(const Color(0xFF009693).withOpacity(0.1), Colors.white),
                                expandedWidget: _buildExpandableWidget('Home', 350, const Size(80, 50)),
                                collapsedWidget: _buildCollapsedWidget(const Size.square(16)),
                                values: const [Offset(0, 0), Offset(30, 80), Offset(60, 120), Offset(90, 150)]
                            ),
                            CBSectionedLineSection(
                                label: 'Park',
                                lineColor: const Color(0xFF822E6C),
                                backgroundColor: Color.alphaBlend(const Color(0xFF822E6C).withOpacity(0.3), Colors.white),
                                selectionColor: Color.alphaBlend(const Color(0xFF822E6C).withOpacity(0.1), Colors.white),
                                expandedWidget: _buildExpandableWidget('Park', 100, const Size(80, 50)),
                                collapsedWidget: _buildCollapsedWidget(const Size.square(16)),
                                values: const [Offset(120, 0), Offset(150, 20), Offset(180, 80)]
                            ),
                            CBSectionedLineSection(
                                label: 'Walking',
                                lineColor: const Color(0xFFED6926),
                                backgroundColor: Color.alphaBlend(const Color(0xFFED6926).withOpacity(0.3), Colors.white),
                                selectionColor: Color.alphaBlend(const Color(0xFFED6926).withOpacity(0.1), Colors.white),
                                expandedWidget: _buildExpandableWidget('Walking', 170, const Size(80, 50)),
                                collapsedWidget: _buildCollapsedWidget(const Size.square(16)),
                                values: const [Offset(210, 0), Offset(240, 50), Offset(270, 120), Offset(300, 0)]
                            )
                          ]
                      )
                  ),
                ),
                SizedBox(
                  width: 800,
                  height: 50,
                  child: CBSectionedLineTimeLine(
                      leading: null,
                      onIndex: (index) => Text('${index + 1}h'),
                      xAxisDivider: 24
                  ),
                )
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

  PreferredSizeWidget _buildExpandableWidget(String label, double sum, Size size) =>
      PreferredSize(
          preferredSize: size,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label),
                Text('Sum: $sum')
              ],
            ),
          )
      );

  PreferredSizeWidget _buildCollapsedWidget(Size size) => PreferredSize(
      preferredSize: size,
      child: Container(
        width: size.width,
          height: size.height,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue)));
}
