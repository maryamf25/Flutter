# InsightHub - Interactive Analytics Dashboard

A professional Flutter dashboard application featuring real-time analytics, animated charts, and interactive UI components designed for business intelligence and data monitoring.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Design Philosophy](#design-philosophy)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Technical Details](#technical-details)
- [User Guide](#user-guide)
- [Customization Guide](#customization-guide)
- [Performance Optimization](#performance-optimization)
- [Dependencies](#dependencies)
- [License](#license)

## 🎯 Overview

InsightHub is a sophisticated business analytics dashboard built with Flutter that provides real-time monitoring of key performance indicators (KPIs). The application features a clean, professional design inspired by enterprise analytics platforms like Tableau and Power BI, with interactive visualizations and intuitive gesture-based navigation.

### Key Highlights

- **Real-time Data Monitoring**: Automatic updates every 5 seconds with realistic business metrics
- **Interactive Visualizations**: Professional line charts powered by fl_chart library
- **Gesture-Based Navigation**: Tap, swipe, and drag-and-drop interactions
- **Responsive Design**: Adapts seamlessly to different screen sizes and orientations
- **Dark Theme Interface**: Professional dark mode optimized for extended viewing
- **Customizable Layout**: Reorder dashboard cards via drag-and-drop

## 🎯 Features

### ✅ Interactive Metric Cards

#### Tap Gesture - Expand/Collapse

- Tap any metric card to toggle between collapsed and expanded states
- Expanded view shows detailed 24-hour trend chart
- Smooth animation transitions (300ms duration)
- Height adjusts from 200px (collapsed) to 440px (expanded)

#### Swipe Gesture - Detailed Navigation

- Swipe right (velocity > 200 px/s) on any card to open full-screen details
- View comprehensive statistics including:
  - Current value with large display
  - Percentage change with trend indicators
  - 24-hour high and low values
  - Full-size interactive chart (300px height)
- Navigate back using the app bar back button

#### Drag & Drop - Reorder Layout

- Long press on any metric card to initiate drag
- Drag over other cards to swap positions
- Visual feedback with border highlighting during drag
- Reduced opacity (0.3) on source card while dragging
- Scaled feedback (1.1x) shows card being moved
- Layout persists during session

### ✅ Dynamic Charts with fl_chart

#### Real-Time Data Updates

- Automatic refresh every 5 seconds via Timer.periodic
- Realistic data simulation with time-aware generation
- Business hours (9 AM - 5 PM) show higher activity
- Smooth data transitions with animated interpolation

#### Chart Features

- Professional line charts with gradient fills
- Curved bezier interpolation for smooth lines
- Interactive dots on expanded view
- Grid lines and axis labels (configurable intervals)
- Reserved space for labels: bottom (45px), left (50px)
- Touch interactions disabled for cleaner presentation

#### Supported Metrics

1. **Revenue**: $100K-$200K range, displays in thousands
2. **Active Users**: 5K-12K range, integer values
3. **Conversion Rate**: 2.5%-5.5% range, one decimal place
4. **Server Load**: 35%-85% range, one decimal place

### ✅ Customizable Dashboard Layout

#### Drag-and-Drop Implementation

- Uses Flutter's LongPressDraggable and DragTarget widgets
- Maintains metric order in `_metricsOrder` list
- Supports both wide (2-column grid) and narrow (single column) layouts
- Responsive breakpoint at 600px width

#### Visual Feedback System

- Border highlighting (0.5 opacity) when dragging over valid targets
- Smooth color transitions for accent highlights
- Maintains card state during reordering operations

## 🎨 Design Philosophy

### Professional Dark Theme

The application uses a carefully crafted dark color palette designed for professional business environments:

#### Background Colors

- Primary Background: `#121212` - Deep neutral black
- Card Background: `#1E1E1E` - Elevated surface gray
- Subtle contrast for visual hierarchy without eye strain

#### Accent Colors (Material Design Inspired)

- **Revenue**: `#1976D2` - Professional Blue
- **Active Users**: `#0288D1` - Light Blue
- **Conversion Rate**: `#00897B` - Teal Green
- **Server Load**: `#FFA726` - Warm Orange

#### Design Principles

- **Flat Design**: No gradients, clean solid colors
- **Minimal Shadows**: Subtle elevation (10px blur, 0.2 opacity)
- **Clear Typography**: Google Fonts Inter (UI), Poppins (metrics)
- **Consistent Spacing**: 24px padding, 16px margins
- **Border Accents**: 0.05 opacity for subtle separation

### Typography Hierarchy

```
- Dashboard Title: Inter 22pt Bold
- Metric Values: Poppins 26pt Bold (collapsed), 56pt Bold (detailed)
- Metric Labels: Inter 16pt SemiBold
- Chart Labels: Inter 9pt Medium
- Body Text: Inter 13-14pt Regular
```

## 🚀 Getting Started

### Prerequisites

Before running the application, ensure you have:

- **Flutter SDK**: Version 3.10.4 or higher
- **Dart SDK**: Version 3.0.0 or higher
- **IDE**: VS Code or Android Studio with Flutter plugins
- **Platform**: Windows, macOS, or Linux for development
- **Emulator/Device**: iOS Simulator, Android Emulator, or physical device

### Installation Steps

1. **Clone the Repository**

```bash
git clone <repository-url>
cd interactive_dashboard
```

2. **Install Dependencies**

```bash
flutter pub get
```

This will download all required packages:

- fl_chart (0.66.2) - Chart rendering
- google_fonts (6.3.3) - Typography

3. **Verify Installation**

```bash
flutter doctor
```

Ensure all components show green checkmarks.

4. **Run the Application**

For development mode:

```bash
flutter run
```

For specific platform:

```bash
flutter run -d chrome        # Web
flutter run -d windows       # Windows Desktop
flutter run -d macos         # macOS Desktop
flutter run -d <device-id>   # Mobile device
```

5. **Build for Production**

```bash
flutter build apk            # Android APK
flutter build ios            # iOS
flutter build web            # Web deployment
flutter build windows        # Windows executable
```

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point, theme configuration
│   ├── MyApp (StatelessWidget)
│   ├── Theme setup with Material 3
│   └── System UI overlay configuration
│
├── screens/
│   ├── splash_screen.dart            # Animated intro screen
│   │   ├── Duration: 2 seconds
│   │   ├── Fade + Scale animations
│   │   └── Auto-navigation to dashboard
│   │
│   └── dashboard_screen.dart         # Main dashboard view
│       ├── Header with logo and title
│       ├── Live status indicator
│       ├── Metric grid (responsive 2-col/1-col)
│       ├── Drag-drop reordering logic
│       └── Auto-refresh timer (5s interval)
│
├── widgets/
│   ├── metric_card.dart              # Interactive metric display
│   │   ├── Tap gesture handling
│   │   ├── Swipe navigation (velocity detection)
│   │   ├── Expand/collapse animation
│   │   ├── Pulse animation for live indicator
│   │   └── DetailedMetricScreen (full-screen view)
│   │
│   └── modern_metric_chart.dart      # Chart visualization
│       ├── fl_chart LineChart widget
│       ├── Configurable height (80px/300px)
│       ├── Grid and axis configuration
│       ├── Gradient area fill
│       └── Touch interaction control
│
├── services/
│   └── analytics_service.dart        # Data generation
│       ├── AnalyticsDataService (singleton)
│       ├── MetricData model
│       ├── Timer-based updates (5s)
│       ├── 24-hour history tracking
│       ├── Business hours logic
│       └── Random variation algorithms
│
└── models/
    └── dashboard_item.dart           # Data structures
```

## 🔧 Technical Details

### Real-Time Data Service

#### AnalyticsDataService Architecture

```dart
class AnalyticsDataService {
  static final AnalyticsDataService _instance = AnalyticsDataService._internal();
  factory AnalyticsDataService() => _instance;
  
  Timer? _updateTimer;
  final Random _random = Random();
  
  void initialize() {
    _updateTimer = Timer.periodic(Duration(seconds: 5), (_) {
      _updateMetrics();
    });
  }
}
```

#### Data Generation Algorithm

1. **Base Value Calculation**: Each metric has min/max range
2. **Time-Based Variation**: Business hours (9-17h) get 1.2x multiplier
3. **Random Fluctuation**: ±10% variation from base value
4. **Trend Calculation**: Compare with previous value for direction
5. **History Management**: Circular buffer of last 24 hours (288 points @ 5min intervals)

#### Business Hours Logic

```dart
final hour = now.hour;
final isBusinessHours = hour >= 9 && hour <= 17;
final multiplier = isBusinessHours ? 1.2 : 0.8;
final value = baseValue * multiplier * (0.9 + random * 0.2);
```

### Animation System

#### Expansion Animation

- Duration: 300ms
- Curve: easeInOut
- Property: Container height (200px → 440px)
- Triggers: onTap gesture

#### Pulse Animation (Live Indicator)

- Duration: 1500ms
- Repeat: Infinite reverse
- Range: 1.0 → 1.3 scale
- Visual: Pulsing green dot

#### Splash Screen Animation

- Duration: 800ms fade, 800ms scale
- Curves: easeInOut, easeOut
- Sequence: Fade in + Scale up simultaneously
- Exit: 500ms fade transition

### Gesture Recognition

#### Tap Detection

```dart
onTap: () {
  setState(() {
    _isExpanded = !_isExpanded;
  });
}
```

#### Swipe Detection

```dart
onHorizontalDragEnd: (details) {
  if (details.primaryVelocity != null && 
      details.primaryVelocity! > 200) {
    Navigator.push(context, MaterialPageRoute(...));
  }
}
```

#### Drag-and-Drop

```dart
LongPressDraggable<int>(
  data: index,
  feedback: Transform.scale(scale: 1.1, child: ...),
  childWhenDragging: Opacity(opacity: 0.3, child: ...),
  child: DragTarget<int>(
    onWillAccept: (data) => data != null && data != index,
    onAccept: (draggedIndex) { /* Reorder logic */ },
  ),
)
```

## 📱 User Guide

### Basic Navigation

#### Starting the App

1. Launch displays animated splash screen (2 seconds)
2. Automatic transition to main dashboard
3. Metrics begin auto-updating every 5 seconds

#### Viewing Metrics

**Collapsed View (Default)**

- Shows current value, label, and mini chart
- Percentage change with trend indicator (▲/▼)
- Color-coded accent for each metric type
- Compact 200px height for overview

**Expanded View**

- Tap any card to expand in-place
- Full-height chart (260px) with grid and axes
- All data labels visible
- Tap again to collapse

**Detailed View**

- Swipe right on any card (fast gesture)
- Opens full-screen detailed analysis
- Statistics grid: Current, Change, 24h High/Low
- Large chart with complete historical data
- Back button returns to dashboard

#### Reordering Metrics

1. **Long Press** on card (hold for ~500ms)
2. **Drag** over another card position
3. Border highlights when over valid drop zone
4. **Release** to complete reorder
5. Layout updates immediately

#### Manual Refresh

- Click refresh button (top-right corner)
- Forces immediate data update
- Does not affect auto-refresh timer

## 🛠️ Customization Guide

### Adding New Metrics

1. **Create Data Method** in `analytics_service.dart`:

```dart
MetricData getNewMetricData() {
  final value = 50 + _random.nextDouble() * 100;
  return MetricData(
    value: value,
    previousValue: value * 0.95,
    history: _generateHistory(50, 150),
    unit: 'units',
    lastUpdated: DateTime.now(),
  );
}
```

2. **Add to Metrics Order** in `dashboard_screen.dart`:

```dart
List<String> _metricsOrder = [
  'revenue', 'users', 'conversion', 'serverLoad', 'newMetric'
];
```

3. **Configure in Build Method**:

```dart
final newMetricData = _analyticsService.getNewMetricData();

'newMetric': {
  'title': 'New Metric',
  'icon': Icons.custom_icon,
  'data': newMetricData,
  'color': const Color(0xFFXXXXXX),
},
```

### Changing Theme Colors

**Update Background Colors**:

```dart
scaffoldBackgroundColor: const Color(0xFF121212),
backgroundColor: const Color(0xFF121212),
color: const Color(0xFF1E1E1E),
```

**Update Accent Colors**:

```dart
'revenue': { 'color': const Color(0xFFXXXXXX) },
'users': { 'color': const Color(0xFFYYYYYY) },
```

### Adjusting Update Frequency

**Change Auto-Refresh Interval**:

```dart
_refreshTimer = Timer.periodic(
  const Duration(seconds: 10),
  (timer) { setState(() {}); }
);
```

### Modifying Chart Appearance

**Chart Height**:

```dart
height: isExpanded ? 350 : 100,
```

**Chart Colors**:

```dart
LineChartBarData(
  color: customColor,
  barWidth: 4,
  belowBarData: BarAreaData(
    gradient: LinearGradient(
      colors: [customColor.withOpacity(0.5), ...],
    ),
  ),
)
```

**Grid Configuration**:

```dart
gridData: FlGridData(
  show: true,
  horizontalInterval: 20,
  verticalInterval: 6,
),
```

### Customizing Animations

**Expansion Speed**:

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 500),
  curve: Curves.elasticOut,
)
```

**Splash Duration**:

```dart
Timer(const Duration(milliseconds: 3000), () { ... });
```

## ⚡ Performance Optimization

### Current Optimizations

1. **Efficient Rebuilds**: Only cards with changed data rebuild
2. **Lazy Chart Rendering**: Charts only rendered when expanded
3. **Timer Management**: Single timer per service, proper disposal
4. **Const Constructors**: Maximum use of const widgets
5. **Minimal Opacity**: Avoid expensive opacity animations

### Best Practices Implemented

- `const` keywords for immutable widgets
- Proper `dispose()` methods for controllers and timers
- Efficient state management with local state
- Debounced gesture handlers

### Performance Monitoring

Use Flutter DevTools to monitor:

```bash
flutter run --profile
```

- Frame rendering time (target: <16ms for 60fps)
- Memory usage (watch for leaks)
- Widget rebuild counts
- GPU/CPU utilization

## 📦 Dependencies

### Production Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
    
  fl_chart: ^0.66.2
  google_fonts: ^6.3.3
```

### Platform Requirements

- **iOS**: Deployment target 11.0+
- **Android**: minSdkVersion 21 (Android 5.0+)
- **Web**: Modern browsers (Chrome, Firefox, Safari, Edge)
- **Desktop**: Windows 10+, macOS 10.14+, Linux (Ubuntu 18.04+)

## 📄 License

This project is part of the AppVerse Internship Program.

### Development Information

- **Developer**: Maryam
- **Organization**: AppVerse Internship
- **Purpose**: Learning Flutter development and dashboard design
- **Year**: 2026

## 🐛 Troubleshooting

### Common Issues

**Charts not displaying:**

- Check fl_chart version compatibility
- Ensure data history has valid values
- Verify chart constraints (height/width)

**Gestures not working:**

- Confirm GestureDetector is not blocked by parent widgets
- Check velocity threshold (may need adjustment)
- Ensure Navigator context is available

**Timer memory leaks:**

- Verify dispose() methods are called
- Cancel timers in dispose()
- Use Timer.periodic properly

**Build errors:**

- Run `flutter clean && flutter pub get`
- Update Flutter SDK: `flutter upgrade`
- Check pubspec.yaml syntax

## 📞 Support

For questions or issues related to this project:

- Review Flutter documentation: https://flutter.dev
- Check fl_chart documentation: https://pub.dev/packages/fl_chart
- Consult with AppVerse mentors

---

**Built with ❤️ using Flutter**
