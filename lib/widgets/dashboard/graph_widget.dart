// lib/widgets/dashboard/graph_widget.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../utils/date_formatter.dart';
import '../../utils/number_utils.dart';

class GraphWidget extends StatefulWidget {
  final List<Map<String, dynamic>> graphData;

  const GraphWidget({super.key, required this.graphData});

  @override
  _GraphWidgetState createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  double _sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    if (widget.graphData.isEmpty) {
      return Container(
        height: 230,
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/dashboard/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Text(
            'No data available',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    final weeks = widget.graphData.map((data) => data['week'] as String).toList();
    final totalWeights = widget.graphData.map((data) => data['total_weight'] as double).toList();

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _sliderValue = (_sliderValue + details.delta.dx / 20)
              .clamp(0.0, weeks.length - 1.0);
        });
      },
      onTapDown: (TapDownDetails details) {
        final chartWidth = MediaQuery.of(context).size.width;
        final position = details.localPosition.dx;
        setState(() {
          _sliderValue = (position / chartWidth * (weeks.length - 1))
              .clamp(0.0, weeks.length - 1.0);
        });
      },
      child: Container(
        height: 230,
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/dashboard/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Graph with padding to avoid overlap with the overlay button
            Padding(
              padding: const EdgeInsets.only(top: 40), // Adjust this value as needed
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                margin: EdgeInsets.zero,
                series: <ChartSeries>[
                  SplineAreaSeries<Map<String, dynamic>, String>(
                    dataSource: widget.graphData,
                    xValueMapper: (Map<String, dynamic> data, _) => data['week'],
                    yValueMapper: (Map<String, dynamic> data, _) => data['total_weight'],
                    color: Colors.transparent, // Make the area transparent to show the image
                    splineType: SplineType.natural,
                    borderColor: Colors.orange,
                    borderWidth: 3,
                  ),
                  SplineSeries<Map<String, dynamic>, String>(
                    dataSource: [widget.graphData[_sliderValue.toInt()]],
                    xValueMapper: (Map<String, dynamic> data, _) => data['week'],
                    yValueMapper: (Map<String, dynamic> data, _) => data['total_weight'],
                    color: Colors.transparent,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      color: Colors.orange,
                      borderColor: Colors.orange,
                      borderWidth: 4,
                      width: 12,
                      height: 12,
                    ),
                  ),
                ],
                primaryXAxis: CategoryAxis(
                  isVisible: false,
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  isVisible: false,
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                ),
              ),
            ),
            // Overlay button
            Positioned(
              right: 16,
              top: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormatter.format(weeks[_sliderValue.toInt()]),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${NumberUtils.convertDouble(totalWeights[_sliderValue.toInt()])} kg',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}