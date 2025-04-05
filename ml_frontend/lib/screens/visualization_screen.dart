import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class VisualizationScreen extends StatelessWidget {
  const VisualizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Visualizations")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.red, width: 2),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0, 1),
                  const FlSpot(1, 3),
                  const FlSpot(2, 2),
                  const FlSpot(3, 1.5),
                  const FlSpot(4, 4),
                  const FlSpot(5, 3.5),
                ],
                isCurved: true,
                color: Colors.red,
                barWidth: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
