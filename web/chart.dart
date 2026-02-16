import 'dart:math' as math;

import 'package:chart_engine/chart_engine_chartjs.dart'
    deferred as chart_engine;
import 'package:collection/collection.dart';
import 'package:web/web.dart';

mixin WithChart {
  Future<void>? _loadChartEngineFuture;

  Future<void> loadChartEngine() =>
      _loadChartEngineFuture ??= _loadChartEngineImpl();

  Future<void> _loadChartEngineImpl() async {
    await chart_engine.loadLibrary();

    var charEngine = chart_engine.ChartEngineChartJS();
    await charEngine.load();
  }

  HTMLDivElement buildLineChart<V extends num>(
    String title,
    String xTitle,
    String yTitle,
    List<String> seriesX,
    Map<String, List<V>> seriesY, {
    String? backgroundColor,
    int? yAxisMin,
    int? yAxisMax,
    List<String>? colors,
    int? chartWidth,
    int? margin,
  }) {
    var categories = seriesY.keys.toList();

    var colorsMap = Map<String, String>.fromEntries(
      colors?.mapIndexed((i, c) => MapEntry(categories[i], c)) ?? [],
    );

    var chartSeriesOptions = chart_engine.ChartSeriesOptions();

    if (yAxisMax != null) {
      chartSeriesOptions
        ..yAxisMin = yAxisMin ?? 0
        ..yAxisMax = yAxisMax;
    }

    var chartSeries =
        chart_engine.ChartSeries<String, String, dynamic, V>(
            seriesX,
            seriesY,
            options: chartSeriesOptions,
          )
          ..colors = colorsMap
          ..title = title
          ..xTitle = xTitle
          ..yTitle = yTitle;

    chartWidth ??= this.chartWidth;

    var divChart = _createDivChart(
      chartWidth,
      backgroundColor: backgroundColor,
      margin: margin,
    );

    var charEngine = chart_engine.ChartEngineChartJS();

    charEngine.renderLineChart(divChart, chartSeries);

    return divChart;
  }

  int get chartWidth => math.max(300, (window.innerWidth) - 32);

  HTMLDivElement _createDivChart(
    int chartWidth, {
    String? backgroundColor,
    int? margin,
    bool horizontalBar = false,
  }) {
    margin ??= 16;

    var div = HTMLDivElement()
      ..classList.add('shadow')
      ..style.display = 'inline-block'
      ..style.backgroundColor = backgroundColor ?? 'rgba(0,0,0, 0.26)'
      ..style.width = '${chartWidth}px'
      ..style.maxWidth = 'calc( 100vw - 32px )'
      ..style.margin = '${margin}px'
      ..style.borderRadius = '16px';

    if (!horizontalBar) {
      div.style.height = '450px';
    }

    return div;
  }
}
