import 'package:web/web.dart' as web;

import 'chart.dart';

Future<void> main() async {
  final output = web.document.querySelector('#output') as web.HTMLDivElement;

  var chartComponent = MyChartComponent();

  var chart = await chartComponent.build();

  output.appendChild(chart);
}

class MyChartComponent with WithChart {
  Future<web.HTMLDivElement> build() async {
    await loadChartEngine();

    return buildLineChart(
      'Chart Demo',
      'X',
      'Y',
      ['A', 'B', 'C'],
      {
        'A': [100, 200, 300],
        'B': [100, 110, 120],
        'C': [200, 100, 10],
      },
      colors: ['red', 'green', 'blue'],
      backgroundColor: 'rgb(240,240,240)',
    );
  }
}
