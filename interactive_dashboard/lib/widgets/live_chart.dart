import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LiveChart extends StatelessWidget {
  final List<double> dataPoints;
  final Color color;
  final bool isExpanded;

  const LiveChart({
    super.key,
    required this.dataPoints,
    required this.color,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    // If collapsed, show a simplified sparkline. If expanded, show full chart.
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: isExpanded ? 220 : 80,
      padding: const EdgeInsets.only(right: 20, left: 8, top: 20, bottom: 16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: isExpanded,
          ), // Only show grid when expanded
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: isExpanded,
                reservedSize: 32,
                interval: 1,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: isExpanded, reservedSize: 42),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (dataPoints.length - 1).toDouble(),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: dataPoints
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              color: color,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: isExpanded,
              ), // Show dots only when expanded
              belowBarData: BarAreaData(
                show: true,
                color: color.withOpacity(0.2),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 400), // Animate data changes
        curve: Curves.easeInOut,
      ),
    );
  }
}
