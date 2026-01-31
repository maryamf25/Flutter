import 'package:hive/hive.dart';

part 'scan_item.g.dart';

@HiveType(typeId: 0)
class ScanItem extends HiveObject {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String format;

  @HiveField(2)
  final DateTime timestamp;

  ScanItem({required this.code, required this.format, required this.timestamp});
}
