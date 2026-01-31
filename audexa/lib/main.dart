import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/note_provider.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_guide.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeProvider() {
    _loadTheme();
  }
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? true;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const VoiceNotesApp(),
    ),
  );
}

class VoiceNotesApp extends StatefulWidget {
  const VoiceNotesApp({super.key});

  @override
  VoiceNotesAppState createState() => VoiceNotesAppState();
}

class VoiceNotesAppState extends State<VoiceNotesApp> {
  bool _showSplash = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    if (mounted) {
      setState(() {
        _showSplash = false;
        _showOnboarding = !seenOnboarding;
      });
    }
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (mounted) setState(() => _showOnboarding = false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Audexa',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFFBF8FF),
            primaryColor: const Color(0xFF6750A4),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6750A4),
              brightness: Brightness.light,
              primary: const Color(0xFF6750A4),
              secondary: const Color(0xFF625B71),
              surface: const Color(0xFFFEF7FF),
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1C1B1F)),
              bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF1C1B1F)),
              bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF49454F)),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF141218),
            primaryColor: const Color(0xFFD0BCFF),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFD0BCFF),
              brightness: Brightness.dark,
              primary: const Color(0xFFD0BCFF),
              secondary: const Color(0xFFCCC2DC),
              surface: const Color(0xFF1C1B1F),
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFE6E1E5)),
              bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFE6E1E5)),
              bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFCAC4D0)),
            ),
          ),
          home: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: _showSplash
                ? const SplashScreen()
                : _showOnboarding
                    ? OnboardingGuide(onDone: _completeOnboarding)
                    : const HomeScreen(),
          ),
        );
      },
    );
  }
}
