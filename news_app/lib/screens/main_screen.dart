import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'saved_articles_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SavedArticlesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF0891B2), // fallback color
            unselectedItemColor: Colors.grey[400],
            selectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              _buildNavItem(
                index: 0,
                label: 'Home',
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
              ),
              _buildNavItem(
                index: 1,
                label: 'Saved',
                icon: Icons.bookmark_border,
                activeIcon: Icons.bookmark,
              ),
              _buildNavItem(
                index: 2,
                label: 'Profile',
                icon: Icons.person_outline,
                activeIcon: Icons.person,
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}
BottomNavigationBarItem _buildNavItem({
  required int index,
  required String label,
  required IconData icon,
  required IconData activeIcon,
}) {
  return BottomNavigationBarItem(
    label: label,
    icon: Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Icon(icon, size: 28),
    ),
    activeIcon: Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 18, 49, 57),
            Color(0xFF0891B2),
          ],
        ).createShader(bounds),
        child: Icon(
          activeIcon,
          size: 28,
          color: Colors.white,
        ),
      ),
    ),
  );
}
