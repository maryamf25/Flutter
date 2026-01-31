import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/analytics_service.dart';
import 'modern_metric_chart.dart';
import 'dart:ui';

class MetricCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final MetricData data;
  final Color accentColor;
  final VoidCallback onRefresh;

  const MetricCard({
    super.key,
    required this.title,
    required this.icon,
    required this.data,
    required this.accentColor,
    required this.onRefresh,
  });

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _pulseController;
  double _dragStartX = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      onHorizontalDragStart: (details) {
        _dragStartX = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (details) {
        final dragDistance = details.globalPosition.dx - _dragStartX;
        if (dragDistance.abs() > 80) {
          _dragStartX = details.globalPosition.dx;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => _DetailedMetricScreen(
                title: widget.title,
                icon: widget.icon,
                data: widget.data,
                accentColor: widget.accentColor,
              ),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isExpanded ? 440 : 200,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isExpanded
                ? widget.accentColor.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.1),
            width: _isExpanded ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withOpacity(_isExpanded ? 0.3 : 0.15),
              blurRadius: _isExpanded ? 24 : 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Animated glow effect
                  if (_isExpanded)
                    Positioned(
                      top: -50,
                      right: -50,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  widget.accentColor.withOpacity(
                                    0.2 * _pulseController.value,
                                  ),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    widget.accentColor.withValues(alpha: 0.8),
                                    widget.accentColor.withValues(alpha: 0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.accentColor.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.icon,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.data.formattedValue,
                                          style: GoogleFonts.poppins(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: widget.data.isIncreasing
                                              ? Colors.green.withValues(
                                                  alpha: 0.2,
                                                )
                                              : Colors.red.withValues(
                                                  alpha: 0.2,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              widget.data.isIncreasing
                                                  ? Icons.trending_up
                                                  : Icons.trending_down,
                                              color: widget.data.isIncreasing
                                                  ? Colors.greenAccent
                                                  : Colors.redAccent,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              widget.data.formattedChange,
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: widget.data.isIncreasing
                                                    ? Colors.greenAccent
                                                    : Colors.redAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Chart
                        Expanded(
                          child: ModernMetricChart(
                            data: widget.data,
                            color: widget.accentColor,
                            isExpanded: _isExpanded,
                          ),
                        ),

                        // Timestamp and status
                        if (_isExpanded) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
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
                                  'Live  •  Last updated ${_getTimeAgo(widget.data.timestamp)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '24h history',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}

class _DetailedMetricScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final MetricData data;
  final Color accentColor;

  const _DetailedMetricScreen({
    required this.title,
    required this.icon,
    required this.data,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '$title Details',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white, size: 48),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      data.formattedValue,
                      style: GoogleFonts.poppins(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: data.isIncreasing
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            data.isIncreasing
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: data.isIncreasing
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            data.formattedChange,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: data.isIncreasing
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'vs previous',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 24-hour trend section
              Text(
                '24-Hour Trend',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                child: ModernMetricChart(
                  data: data,
                  color: accentColor,
                  isExpanded: true,
                ),
              ),
              const SizedBox(height: 32),

              // Statistics grid
              Text(
                'Statistics',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(
                    'Current',
                    data.formattedValue,
                    Icons.speed,
                    accentColor,
                  ),
                  _buildStatCard(
                    'Change',
                    data.formattedChange,
                    data.isIncreasing
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    data.isIncreasing ? Colors.greenAccent : Colors.redAccent,
                  ),
                  _buildStatCard(
                    '24h High',
                    _formatValue(data.history.reduce((a, b) => a > b ? a : b)),
                    Icons.trending_up,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    '24h Low',
                    _formatValue(data.history.reduce((a, b) => a < b ? a : b)),
                    Icons.trending_down,
                    Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _formatValue(double value) {
    if (data.unit == '\$') {
      return '\$${value.toStringAsFixed(2)}K';
    } else if (data.unit == '%') {
      return '${value.toStringAsFixed(1)}%';
    } else {
      return value.toStringAsFixed(0) + data.unit;
    }
  }
}
