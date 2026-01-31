import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/analytics_service.dart';
import '../widgets/metric_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AnalyticsDataService _analyticsService = AnalyticsDataService();
  Timer? _refreshTimer;

  final List<String> _metricsOrder = [
    'revenue',
    'users',
    'conversion',
    'serverLoad',
  ];

  @override
  void initState() {
    super.initState();
    _analyticsService.initialize();

    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _analyticsService.dispose();
    super.dispose();
  }

  void _manualRefresh() {
    _analyticsService.updateMetrics();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final revenueData = _analyticsService.getRevenueData();
    final usersData = _analyticsService.getUsersData();
    final conversionData = _analyticsService.getConversionData();
    final serverLoadData = _analyticsService.getServerLoadData();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Logo
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF1976D2,
                            ).withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.insights_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Title and subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Business Analytics',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.greenAccent.withOpacity(
                                        0.5,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Live Monitoring',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Refresh button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                        ),
                        onPressed: _manualRefresh,
                        tooltip: 'Refresh Data',
                      ),
                    ),
                  ],
                ),
              ),

              // Dashboard Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Key Metrics',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.9),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Real-time',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.7),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Metrics Grid
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final isWide = width > 600;

                          // Build metric cards based on order
                          final metricWidgets = _metricsOrder.map((metricKey) {
                            return _buildMetricWidget(
                              metricKey,
                              revenueData,
                              usersData,
                              conversionData,
                              serverLoadData,
                            );
                          }).toList();

                          if (isWide) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: metricWidgets[0]),
                                    Expanded(child: metricWidgets[1]),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: metricWidgets[2]),
                                    Expanded(child: metricWidgets[3]),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Column(children: metricWidgets);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricWidget(
    String metricKey,
    MetricData revenueData,
    MetricData usersData,
    MetricData conversionData,
    MetricData serverLoadData,
  ) {
    final metrics = {
      'revenue': {
        'title': 'Revenue',
        'icon': Icons.attach_money_rounded,
        'data': revenueData,
        'color': const Color(0xFF1976D2),
      },
      'users': {
        'title': 'Active Users',
        'icon': Icons.people_rounded,
        'data': usersData,
        'color': const Color(0xFF0288D1),
      },
      'conversion': {
        'title': 'Conversion Rate',
        'icon': Icons.trending_up_rounded,
        'data': conversionData,
        'color': const Color(0xFF00897B),
      },
      'serverLoad': {
        'title': 'Server Load',
        'icon': Icons.dns_rounded,
        'data': serverLoadData,
        'color': const Color(0xFFFFA726),
      },
    };

    final metric = metrics[metricKey]!;
    final index = _metricsOrder.indexOf(metricKey);

    return LongPressDraggable<int>(
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.1,
          child: Opacity(
            opacity: 0.8,
            child: SizedBox(
              width: 350,
              child: MetricCard(
                title: metric['title'] as String,
                icon: metric['icon'] as IconData,
                data: metric['data'] as MetricData,
                accentColor: metric['color'] as Color,
                onRefresh: _manualRefresh,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: MetricCard(
          title: metric['title'] as String,
          icon: metric['icon'] as IconData,
          data: metric['data'] as MetricData,
          accentColor: metric['color'] as Color,
          onRefresh: _manualRefresh,
        ),
      ),
      child: DragTarget<int>(
        onWillAcceptWithDetails: (details) => details.data != index,
        onAcceptWithDetails: (details) {
          setState(() {
            final draggedIndex = details.data;
            final item = _metricsOrder.removeAt(draggedIndex);
            _metricsOrder.insert(index, item);
          });
        },
        builder: (context, candidateData, rejectedData) {
          final isHovered = candidateData.isNotEmpty;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: isHovered
                  ? Border.all(
                      color: (metric['color'] as Color).withValues(alpha: 0.5),
                      width: 3,
                    )
                  : null,
            ),
            child: MetricCard(
              title: metric['title'] as String,
              icon: metric['icon'] as IconData,
              data: metric['data'] as MetricData,
              accentColor: metric['color'] as Color,
              onRefresh: _manualRefresh,
            ),
          );
        },
      ),
    );
  }
}
