import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/analytics_service.dart';

class ModernMetricChart extends StatelessWidget {
  final MetricData data;
  final Color color;
  final bool isExpanded;

  const ModernMetricChart({
    super.key,
    required this.data,
    required this.color,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: isExpanded ? 300 : 80,
      padding: EdgeInsets.only(
        right: isExpanded ? 20 : 8,
        left: isExpanded ? 20 : 8,
        top: isExpanded ? 32 : 20,
        bottom: isExpanded ? 32 : 8,
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: isExpanded,
            drawVerticalLine: true,
            horizontalInterval: data.unit == '\$' ? 20 : 10,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.white.withValues(alpha: 0.05), strokeWidth: 1),
            getDrawingVerticalLine: (value) =>
                FlLine(color: Colors.white.withValues(alpha: 0.05), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            show: isExpanded,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: isExpanded,
                reservedSize: 45,
                interval: 6,
                getTitlesWidget: (value, meta) {
                  final hour = value.toInt();
                  if (hour % 6 == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        '${hour}h',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: isExpanded,
                reservedSize: 50,
                interval: data.unit == '\$' ? 40 : 20,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Text(
                      value.toInt().toString(),
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            enabled: false,
            handleBuiltInTouches: false,
          ),
          minX: 0,
          maxX: (data.history.length - 1).toDouble(),
          minY: data.history.reduce((a, b) => a < b ? a : b) * 0.9,
          maxY: data.history.reduce((a, b) => a > b ? a : b) * 1.1,
          lineBarsData: [
            LineChartBarData(
              spots: data.history
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              color: color,
              barWidth: isExpanded ? 3 : 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: isExpanded,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 2.5,
                    color: color,
                    strokeWidth: 1.5,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.05)],
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      ),
    );
  }
}
