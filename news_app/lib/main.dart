import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'providers/news_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize dotenv
  try {
    await dotenv.load(fileName: ".env");
    print('✓ .env file loaded successfully');
  } catch (e) {
    print('⚠ Warning: .env file not found. Please add your API key.');
    // Initialize with empty environment to avoid NotInitializedError
    dotenv.testLoad(fileInput: 'NEWS_API_KEY=');
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => NewsProvider(),
      child: const NewsApp(),
    ),
  );
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DailyPulse - Your News Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading while checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFF667eea)),
              ),
            );
          }

          // If user is logged in, show main screen
          if (snapshot.hasData) {
            return const MainScreen();
          }

          // Otherwise, show welcome/login flow
          return const WelcomeScreen();
        },
      ),
    );
  }
}
