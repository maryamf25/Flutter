import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/hive_service.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickScan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFDB623),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: const Color(0xFF2D2D2D),
        cardColor: const Color(0xFF3D3D3D),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/check-onboarding': (context) => const OnboardingCheck(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class OnboardingCheck extends StatefulWidget {
  const OnboardingCheck({super.key});

  @override
  State<OnboardingCheck> createState() => _OnboardingCheckState();
}

class _OnboardingCheckState extends State<OnboardingCheck> {
  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? onboardingComplete = prefs.getBool('onboarding_complete');

    if (mounted) {
      if (onboardingComplete == true) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF2D2D2D),
      body: Center(child: CircularProgressIndicator(color: Color(0xFFFDB623))),
    );
  }
}
