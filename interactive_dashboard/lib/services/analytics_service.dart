import 'dart:async';
import 'dart:math';

class MetricData {
  final double currentValue;
  final double previousValue;
  final List<double> history;
  final String unit;
  final DateTime timestamp;

  MetricData({
    required this.currentValue,
    required this.previousValue,
    required this.history,
    required this.unit,
    required this.timestamp,
  });

  double get changePercentage {
    if (previousValue == 0) return 0;
    return ((currentValue - previousValue) / previousValue) * 100;
  }

  bool get isIncreasing => currentValue > previousValue;

  String get formattedValue {
    if (unit == '\$') {
      return '\$${currentValue.toStringAsFixed(2)}K';
    } else if (unit == '%') {
      return '${currentValue.toStringAsFixed(1)}%';
    } else {
      return currentValue.toStringAsFixed(0) + unit;
    }
  }

  String get formattedChange {
    final change = changePercentage.abs();
    final sign = isIncreasing ? '+' : '-';
    return '$sign${change.toStringAsFixed(1)}%';
  }
}

class AnalyticsDataService {
  static final AnalyticsDataService _instance =
      AnalyticsDataService._internal();
  factory AnalyticsDataService() => _instance;
  AnalyticsDataService._internal();

  final Random _random = Random();
  Timer? _updateTimer;

  // Base values for realistic data
  double _revenueBase = 142.5;
  double _usersBase = 8.2;
  double _conversionBase = 3.8;
  double _serverLoadBase = 62.0;

  final List<double> _revenueHistory = [];
  final List<double> _usersHistory = [];
  final List<double> _conversionHistory = [];
  final List<double> _serverLoadHistory = [];

  void initialize() {
    // Initialize with 24 hours of historical data
    _revenueHistory.addAll(_generateInitialData(_revenueBase, 24));
    _usersHistory.addAll(_generateInitialData(_usersBase, 24));
    _conversionHistory.addAll(_generateInitialData(_conversionBase, 24));
    _serverLoadHistory.addAll(_generateInitialData(_serverLoadBase, 24));

    // Start live updates every 5 seconds
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateMetrics();
    });
  }

  List<double> _generateInitialData(double base, int count) {
    return List.generate(count, (i) {
      // Create realistic variations based on time of day
      final hour = i;
      final timeMultiplier = _getTimeMultiplier(hour);
      final variation = (_random.nextDouble() - 0.5) * 0.15;
      return base * timeMultiplier * (1 + variation);
    });
  }

  double _getTimeMultiplier(int hour) {
    // Business hours (9-17) have higher activity
    if (hour >= 9 && hour <= 17) {
      return 1.0 + (0.3 * sin((hour - 9) / 8 * pi));
    } else {
      return 0.7 + (0.2 * _random.nextDouble());
    }
  }

  void _updateMetrics() {
    final now = DateTime.now();
    final hour = now.hour;
    final timeMultiplier = _getTimeMultiplier(hour);

    // Revenue: trend upward during business hours
    final revenueChange = (_random.nextDouble() - 0.45) * 5;
    _revenueBase = (_revenueBase + revenueChange).clamp(100, 200);
    _revenueHistory.add(_revenueBase * timeMultiplier);
    if (_revenueHistory.length > 24) _revenueHistory.removeAt(0);

    // Users: gradual increase
    final usersChange = (_random.nextDouble() - 0.4) * 0.5;
    _usersBase = (_usersBase + usersChange).clamp(5, 12);
    _usersHistory.add(_usersBase * timeMultiplier);
    if (_usersHistory.length > 24) _usersHistory.removeAt(0);

    // Conversion rate: more stable
    final conversionChange = (_random.nextDouble() - 0.5) * 0.2;
    _conversionBase = (_conversionBase + conversionChange).clamp(2.5, 5.5);
    _conversionHistory.add(_conversionBase);
    if (_conversionHistory.length > 24) _conversionHistory.removeAt(0);

    // Server load: varies throughout day
    final loadChange = (_random.nextDouble() - 0.5) * 8;
    _serverLoadBase = (_serverLoadBase + loadChange).clamp(35, 85);
    _serverLoadHistory.add(_serverLoadBase);
    if (_serverLoadHistory.length > 24) _serverLoadHistory.removeAt(0);
  }

  void updateMetrics() {
    _updateMetrics();
  }

  MetricData getRevenueData() {
    return MetricData(
      currentValue: _revenueHistory.last,
      previousValue: _revenueHistory.length > 1
          ? _revenueHistory[_revenueHistory.length - 2]
          : _revenueHistory.last,
      history: List.from(_revenueHistory),
      unit: '\$',
      timestamp: DateTime.now(),
    );
  }

  MetricData getUsersData() {
    return MetricData(
      currentValue: _usersHistory.last,
      previousValue: _usersHistory.length > 1
          ? _usersHistory[_usersHistory.length - 2]
          : _usersHistory.last,
      history: List.from(_usersHistory),
      unit: 'K',
      timestamp: DateTime.now(),
    );
  }

  MetricData getConversionData() {
    return MetricData(
      currentValue: _conversionHistory.last,
      previousValue: _conversionHistory.length > 1
          ? _conversionHistory[_conversionHistory.length - 2]
          : _conversionHistory.last,
      history: List.from(_conversionHistory),
      unit: '%',
      timestamp: DateTime.now(),
    );
  }

  MetricData getServerLoadData() {
    return MetricData(
      currentValue: _serverLoadHistory.last,
      previousValue: _serverLoadHistory.length > 1
          ? _serverLoadHistory[_serverLoadHistory.length - 2]
          : _serverLoadHistory.last,
      history: List.from(_serverLoadHistory),
      unit: '%',
      timestamp: DateTime.now(),
    );
  }

  void dispose() {
    _updateTimer?.cancel();
  }
}
