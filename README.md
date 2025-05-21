A Flutter package for creating beautiful and interactive charts in your applications. cb_charts_flutter offers a variety of chart types to visualize your data effectively.

## Available Chart Types

`cb_charts_flutter` provides a versatile collection of charts to suit your data visualization needs:

*   **Bubble Chart:** Ideal for displaying three dimensions of data, where the size of the bubble represents the third dimension.
*   **Gauge Chart:** Useful for displaying a single value within a range, often used to show progress or a metric against a target.
*   **Legends Chart:** A chart that primarily focuses on displaying legends, which can be helpful for categorical data representation.
*   **Ring Chart:** Similar to a pie chart but with a hole in the center, often used to show proportions of a whole.
*   **Sectioned Line Chart:** A line chart that can be divided into sections, possibly to highlight different phases or categories over a continuous variable.
*   **Sunburst Chart:** A hierarchical chart that displays data as a series of rings, where each ring represents a level in the hierarchy.

## Getting Started

To use `cb_charts_flutter` in your Flutter project, follow these steps:

1.  **Add Dependency:**
    Open your `pubspec.yaml` file and add `cb_charts_flutter` to your dependencies:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      cb_charts_flutter: ^0.0.1 # Replace with the latest version
    ```

2.  **Install Package:**
    Run the following command in your terminal from your project's root directory:

    ```bash
    flutter pub get
    ```

3.  **Import Package:**
    Now, in your Dart code, you can import the package:

    ```dart
    import 'package:cb_charts_flutter/cb_charts_flutter.dart';
    ```

## Usage

### Bubble Chart

Displays data as a series of bubbles, where the size and position of the bubbles can represent different data dimensions. It's useful for visualizing relationships between three variables.

```dart
import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

// Inside your widget's build method:
CBBubbleChart(
  controller: _bubbleController, // Initialize a CBBubbleController
  data: CBBubbleData(
    items: [
      CBBubbleItem(
          label: 'Category A',
          color: Colors.blue,
          backgroundColor: Colors.blue.withOpacity(0.2),
          values: [5, 8, 3, 9, 4, 6, 7, 2, 5, 8]),
      CBBubbleItem(
          label: 'Category B',
          color: Colors.green,
          backgroundColor: Colors.green.withOpacity(0.2),
          values: [3, 6, 9, 2, 7, 5, 8, 4, 6, 9]),
      CBBubbleItem(
          label: 'Category C',
          color: Colors.red,
          backgroundColor: Colors.red.withOpacity(0.2),
          values: [10, 4, 7, 5, 2, 8, 3, 6, 9, 4]),
    ],
  ),
  onIndex: (index) => Text('\${index}h', style: const TextStyle(fontSize: 10)),
  onLabel: (label) => Text(label, style: const TextStyle(fontSize: 14)),
  onTap: (laneIndex, circleIndex, value) => CBBubbleTapWidget(
    anchor: const Offset(0, 0.5),
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: 40,
      height: 40,
      child: Text(value.toString()),
    ),
  ),
)
```

**Note:** You'll need to initialize a `CBBubbleController` and manage its lifecycle, typically within a `StatefulWidget`. See the example in `example/lib/bubble_chart_page.dart` for a full implementation.

### Gauge Chart

Displays a single value within a given range, often used to show progress towards a goal or a metric's status.

```dart
import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

// Inside your widget's build method:
CBGaugeChart(
  controller: _gaugeController, // Initialize a CBGaugeController
  data: CBGaugeData(
    diameter: 250, // Diameter of the gauge
    width: 40,     // Thickness of the gauge ring
    railColor: Colors.grey.shade300,
    value: 75,     // Current value
    max: 100,      // Maximum value of the gauge
    ranges: [
      CBGaugeRange(id: 'Low', color: Colors.red, entryPoint: 0),
      CBGaugeRange(id: 'Medium', color: Colors.orange, entryPoint: 50),
      CBGaugeRange(id: 'High', color: Colors.green, entryPoint: 75),
    ],
    icon: Container( // Optional: Icon to display on the gauge needle
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Colors.blue)),
    leftAxis: const Text('Start'), // Optional: Label for the start of the axis
    rightAxis: const Text('End'),  // Optional: Label for the end of the axis
  ),
  centerInfoBuilder: (range) => Column( // Optional: Builder for content in the center
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('\${range.value.toInt()}%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      Text(range.id, style: TextStyle(fontSize: 16, color: range.color)),
    ],
  ),
)
```

**Note:** You'll need to initialize a `CBGaugeController` and manage its lifecycle. Refer to `example/lib/gauge_chart_page.dart` for a complete example.

### Legends Chart

This chart is designed to display data primarily through legends, making it suitable for representing categorical data with corresponding values.

```dart
import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

// Inside your widget's build method:
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: CBLegendsChart(
    data: CBLegendsData(
      items: [
        CBLegendsItem(label: 'Category X', value: 30, color: Colors.purple),
        CBLegendsItem(label: 'Category Y', value: 50, color: Colors.teal),
        CBLegendsItem(label: 'Category Z', value: 20, color: Colors.amber),
      ]
    ),
    // Optional: Customize the chevron icon
    chevron: const Icon(Icons.expand_more, size: 28),
    // Optional: Builder for the header title, typically showing the total
    headerTitleBuilder: (total, _) => Text('Total: \${total.toInt()}', style: TextStyle(fontWeight: FontWeight.bold)),
    // Optional: Builder for customizing the label of each legend item
    itemLabelBuilder: (label) => Text(label, style: TextStyle(fontSize: 14)),
    // Optional: Builder for customizing the value display of each legend item
    itemValueBuilder: (value) => Text('\${value.toInt()}%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
  ),
)
```

Refer to `example/lib/legends_chart_page.dart` and `example/lib/legends_chart_with_goal_page.dart` for more examples, including how to display progress towards a goal.

### Ring Chart

Represents data as segments of a ring, similar to a pie chart but with a hollow center. It's effective for showing proportions of a whole.

```dart
import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

// Inside your widget's build method:
CBRingChart(
  controller: _ringChartController, // Initialize a CBRingChartController
  data: CBRingChartData(
    segments: [
      CBRingChartSegment(label: 'Product A', value: 45, color: Colors.cyan),
      CBRingChartSegment(label: 'Product B', value: 30, color: Colors.orange),
      CBRingChartSegment(label: 'Product C', value: 25, color: Colors.pink),
    ],
    // Optional: Define the thickness of the ring
    strokeWidth: 30,
    // Optional: Define the space between segments
    segmentSpacing: 2,
  ),
  // Optional: Builder for the label displayed in the center of the ring
  // This label often shows the total value or a summary.
  buildLabel: (animationPercentage, segmentsTotal, chartMax) {
    final currentValue = (segmentsTotal * animationPercentage).toInt();
    return Text(
      '\$currentValue',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  },
  // Optional: Callback for when a segment is selected (tapped)
  onSelected: (segment, chartMax) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(segment.label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      Text('\${segment.value.toInt()}% of total', style: TextStyle(fontSize: 14)),
    ],
  ),
)
```

**Note:** You'll need to initialize a `CBRingChartController` and manage its lifecycle.
For more advanced examples, including displaying progress towards a goal or values over a goal, see:
*   `example/lib/ring_chart_page.dart`
*   `example/lib/ring_chart_with_goal_page.dart`
*   `example/lib/ring_chart_over_goal_page.dart`

### Sectioned Line Chart

Displays data as a line chart that can be divided into distinct sections. This is useful for visualizing trends over time or a continuous variable, where different segments of the line represent different categories, phases, or states.

```dart
import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

// Inside your widget's build method:
Container(
  width: 800, // Example width, adjust as needed
  height: 300, // Example height, includes space for chart and timeline
  child: Column(
    children: [
      Expanded(
        child: CBSectionedLineChart(
          controller: _sectionedLineController, // Initialize a CBSectionedLineController
          data: CBSectionedLineData(
            divider: const Divider(height: 0, thickness: 1, color: Colors.grey),
            dividerAlternate: Divider(height: 0, thickness: 1, color: Colors.grey.withOpacity(0.5)),
            xAxisDivider: 12, // Number of divisions on the X-axis for the background grid
            maxY: 150,        // Maximum Y-axis value
            sections: [
              CBSectionedLineSection(
                label: 'Phase 1',
                lineColor: Colors.blue,
                backgroundColor: Colors.blue.withOpacity(0.2),
                selectionColor: Colors.blue.withOpacity(0.1),
                // Widget to display when this section is expanded/selected
                expandedWidget: _buildDetailPopup('Phase 1 Details', Size(100, 60)),
                // Widget to display as a marker on the line for this section
                collapsedWidget: _buildMarker(Colors.blue, Size.square(12)),
                values: const [
                  Offset(0, 20), Offset(30, 90), Offset(60, 50), // X represents time/index, Y represents value
                ],
              ),
              CBSectionedLineSection(
                label: 'Phase 2',
                lineColor: Colors.green,
                backgroundColor: Colors.green.withOpacity(0.2),
                selectionColor: Colors.green.withOpacity(0.1),
                expandedWidget: _buildDetailPopup('Phase 2 Details', Size(100, 60)),
                collapsedWidget: _buildMarker(Colors.green, Size.square(12)),
                values: const [
                  Offset(90, 120), Offset(120, 80), Offset(150, 100),
                ],
              ),
            ],
          ),
        ),
      ),
      // Optional: Timeline view to complement the chart
      SizedBox(
        height: 50,
        child: CBSectionedLineTimeLine(
          onIndex: (index) => Text('\${index * 5} min'), // Customize timeline labels
          xAxisDivider: 12, // Should generally match CBSectionedLineData.xAxisDivider
        ),
      ),
    ],
  ),
)

// Helper methods for expandedWidget and collapsedWidget (customize as needed)
Widget _buildDetailPopup(String text, Size size) {
  return PreferredSize(
    preferredSize: size,
    child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Text(text),
    ),
  );
}

Widget _buildMarker(Color color, Size size) {
  return PreferredSize(
    preferredSize: size,
    child: Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    ),
  );
}
```

**Note:** You'll need to initialize a `CBSectionedLineController` and manage its lifecycle. This chart often works well with a horizontal scroll view if the content is wide. Refer to `example/lib/sectioned_line_chart_page.dart` for a complete example.

### Sunburst Chart

Displays hierarchical data as a series of rings, where each ring represents a level in the hierarchy. The innermost ring is the root, and segments in outer rings represent children of segments in the inner rings.

```dart
import 'package:cb_charts_flutter/cb_charts_flutter.dart';
import 'package:flutter/material.dart';

// Inside your widget's build method:
CBSunburstChart(
  controller: _sunburstController, // Initialize a CBSunburstController
  // Optional: Builder for content displayed in the center of the sunburst
  centerInfoBuilder: (segment) => SizedBox(
    width: 120, // Adjust width as needed
    child: Text(
      segment?.id ?? 'Total', // Display segment ID or a default text
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  ),
  data: CBSunburstData(
    diameter: 300, // Overall diameter of the chart
    dividerWidth: 2, // Width of the dividers between segments
    segments: [
      CBSunburstSegment(
        id: 'Electronics',
        value: 100,
        width: 40, // Width (thickness) of this ring segment
        color: Colors.blueGrey.shade300,
        selectedColor: Colors.blueGrey.shade500,
        backgroundColor: Colors.blueGrey.shade50,
        children: [
          CBSunburstSegment(
            id: 'Mobile Phones',
            value: 60,
            width: 40,
            color: Colors.lightBlue.shade200,
            selectedColor: Colors.lightBlue.shade400,
            backgroundColor: Colors.lightBlue.shade50,
            children: [
              CBSunburstSegment(id: 'Brand A', value: 25, width: 40, color: Colors.teal.shade100, selectedColor: Colors.teal.shade300, backgroundColor: Colors.teal.shade50),
              CBSunburstSegment(id: 'Brand B', value: 35, width: 40, color: Colors.cyan.shade100, selectedColor: Colors.cyan.shade300, backgroundColor: Colors.cyan.shade50),
            ],
          ),
          CBSunburstSegment(id: 'Laptops', value: 40, width: 40, color: Colors.indigo.shade200, selectedColor: Colors.indigo.shade400, backgroundColor: Colors.indigo.shade50),
        ],
      ),
      CBSunburstSegment(
        id: 'Furniture',
        value: 80,
        width: 40,
        color: Colors.brown.shade300,
        selectedColor: Colors.brown.shade500,
        backgroundColor: Colors.brown.shade50,
        children: [
          CBSunburstSegment(id: 'Tables', value: 45, width: 40, color: Colors.lime.shade200, selectedColor: Colors.lime.shade400, backgroundColor: Colors.lime.shade50),
          CBSunburstSegment(id: 'Chairs', value: 35, width: 40, color: Colors.amber.shade200, selectedColor: Colors.amber.shade400, backgroundColor: Colors.amber.shade50),
        ],
      ),
    ],
  ),
)
```

**Note:** You'll need to initialize a `CBSunburstController` and manage its lifecycle. The `CBSunburstSegment` can be nested to create the hierarchical structure. Refer to `example/lib/sunburst_chart_page.dart` for a complete example.

## Additional Information

### Contributing

Contributions are welcome! If you'd like to contribute to `cb_charts_flutter`, please follow these general steps:

1.  **Fork the Repository:** Create your own fork of the the project's GitHub repository.
2.  **Create a Branch:** Make a new branch in your fork for your feature or bug fix.
    ```bash
    git checkout -b my-new-feature
    ```
3.  **Make Changes:** Implement your feature or bug fix. Ensure your code adheres to the existing style and that you add or update relevant tests.
4.  **Test Your Changes:** Run all tests to ensure everything is working correctly.
5.  **Commit Your Changes:**
    ```bash
    git commit -m 'Add some amazing feature'
    ```
6.  **Push to Your Fork:**
    ```bash
    git push origin my-new-feature
    ```
7.  **Submit a Pull Request:** Open a pull request from your fork's branch to the main `cb_charts_flutter` repository. Provide a clear description of your changes.

### Reporting Issues

If you encounter any bugs or have suggestions for improvements, please file an issue on the project's GitHub Issues page.

When reporting an issue, please include:
*   A clear and descriptive title.
*   The version of `cb_charts_flutter` you are using.
*   The version of Flutter you are using (`flutter --version`).
*   Steps to reproduce the issue.
*   Expected behavior and actual behavior.
*   Any relevant code snippets or screenshots.

### Where to find more information

*   The `/example` folder in this repository contains complete, runnable examples for each chart type.
*   For more details on Flutter package development, see the [official Flutter documentation](https://flutter.dev/developing-packages).
