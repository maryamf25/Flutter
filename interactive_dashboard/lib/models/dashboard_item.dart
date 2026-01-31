import 'package:flutter/material.dart';

enum ItemType { chart, stat, notification, activity }

class DashboardItem {
  final String id;
  final String title;
  final ItemType type;
  final Color color;
  // Holds dynamic data (e.g., chart points or stat numbers)
  List<double> data;

  DashboardItem({
    required this.id,
    required this.title,
    required this.type,
    required this.color,
    this.data = const [],
  });
}
