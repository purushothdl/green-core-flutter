// lib/widgets/dashboard/graph_widget.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/date_formatter.dart';

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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/dashboard/waste_card_bg.jpg'),
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
    final wasteData = widget.graphData.map((data) => data['waste_data'] as Map<String, double>).toList();

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
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/dashboard/waste_card_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            LineChart(
              LineChartData(
                lineTouchData: LineTouchData(enabled: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: weeks.length.toDouble() - 1,
                lineBarsData: [
                  LineChartBarData(
                    spots: wasteData
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(
                              entry.key.toDouble(),
                              entry.value['biodegradable'] ?? 0.0,
                            ))
                        .toList(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: wasteData
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(
                              entry.key.toDouble(),
                              entry.value['hazardous'] ?? 0.0,
                            ))
                        .toList(),
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.orange.withOpacity(0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: wasteData
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(
                              entry.key.toDouble(),
                              entry.value['recyclable'] ?? 0.0,
                            ))
                        .toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                ],
                backgroundColor: Colors.blueGrey.withOpacity(0.5),
              ),
            ),
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
                      '${wasteData[_sliderValue.toInt()]['biodegradable']?.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        color: Colors.green,
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