import 'package:hive_flutter/hive_flutter.dart';
import '../models/scan_item.dart';

class HiveService {
  static const String _boxName = 'scan_history';

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ScanItemAdapter());
    }

    await Hive.openBox<ScanItem>(_boxName);
  }

  static Box<ScanItem> getBox() {
    return Hive.box<ScanItem>(_boxName);
  }

  static Future<void> addScan(String code, String format) async {
    final box = getBox();
    final newItem = ScanItem(
      code: code,
      format: format,
      timestamp: DateTime.now(),
    );
    await box.add(newItem);
  }
}
