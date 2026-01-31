import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dashboard_item.dart';
import 'live_chart.dart';

class DashboardCard extends StatefulWidget {
  final DashboardItem item;
  final VoidCallback onRemove; // Optional: remove item logic

  const DashboardCard({super.key, required this.item, required this.onRemove});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool _isExpanded = false;

  void _handleSwipe(DragEndDetails details) {
    // Detect Swipe Right
    if (details.primaryVelocity! > 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(widget.item.title)),
            body: Center(
              child: Text("Detailed Analytics for ${widget.item.title}"),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _handleSwipe, // Swipe gesture
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded; // Toggle Expansion
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isExpanded ? 380 : 170,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, widget.item.color.withOpacity(0.02)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _isExpanded
                  ? widget.item.color.withOpacity(0.3)
                  : Colors.black.withOpacity(0.08),
              blurRadius: _isExpanded ? 20 : 12,
              offset: const Offset(0, 6),
              spreadRadius: _isExpanded ? 2 : 0,
            ),
          ],
          border: _isExpanded
              ? Border.all(color: widget.item.color.withOpacity(0.4), width: 2)
              : Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.item.color.withOpacity(0.15),
                      widget.item.color.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.item.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.show_chart_rounded,
                        color: widget.item.color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.item.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    const Spacer(),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      turns: _isExpanded ? 0.5 : 0,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: widget.item.color,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.item.type == ItemType.chart)
                        Expanded(
                          child: LiveChart(
                            dataPoints: widget.item.data,
                            color: widget.item.color,
                            isExpanded: _isExpanded,
                          ),
                        )
                      else
                        Center(
                          child: Text(
                            "Tap to expand\nSwipe right for details",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                          ),
                        ),

                      if (_isExpanded) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: widget.item.color.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: widget.item.color,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Real-time data sync active",
                                  style: GoogleFonts.inter(
                                    color: widget.item.color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
