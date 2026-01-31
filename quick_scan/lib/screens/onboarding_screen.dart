import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.qr_code_scanner,
      title: 'Welcome to QuickScan',
      description:
          'Scan and generate QR codes & barcodes with ease. All-in-one solution for your scanning needs.',
      color: Color(0xFFFDB623),
    ),
    OnboardingPage(
      icon: Icons.camera_alt,
      title: 'Scan with Camera',
      description:
          'Tap the yellow Scan button at the bottom to open camera and instantly scan any QR code or barcode.',
      color: Color(0xFFFDB623),
    ),
    OnboardingPage(
      icon: Icons.add_circle_outline,
      title: 'Generate Codes',
      description:
          'Tap the + icon at top-left to create your own QR codes and barcodes. Choose from multiple formats!',
      color: Color(0xFF6C5CE7),
    ),
    OnboardingPage(
      icon: Icons.photo_library,
      title: 'Scan from Images',
      description:
          'In the scanner screen, tap Gallery button to scan QR codes from your saved photos.',
      color: Color(0xFFFDB623),
    ),
    OnboardingPage(
      icon: Icons.swipe,
      title: 'Swipe Actions',
      description:
          'Swipe left on any scan to reveal Share, Copy, and Delete options for quick access.',
      color: Color(0xFFFDB623),
    ),
    OnboardingPage(
      icon: Icons.touch_app,
      title: 'Tap for Details',
      description:
          'Tap any scan to view full details, copy content, share with others, or open links directly.',
      color: Color(0xFFFDB623),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            _buildIndicator(),
            const SizedBox(height: 30),
            _buildButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF3D3D3D),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(page.icon, size: 100, color: page.color),
          ),
          const SizedBox(height: 50),
          Text(
            page.title,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            page.description,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[400],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(0xFFFDB623)
                : Colors.grey[700],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    final isLastPage = _currentPage == _pages.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                'Back',
                style: GoogleFonts.poppins(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            )
          else
            const SizedBox(width: 80),
          GestureDetector(
            onTap: () {
              if (isLastPage) {
                _completeOnboarding();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFFDB623),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLastPage ? Icons.check : Icons.arrow_forward,
                color: const Color(0xFF2D2D2D),
                size: 32,
              ),
            ),
          ),
          if (!isLastPage)
            TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                'Skip',
                style: GoogleFonts.poppins(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            )
          else
            const SizedBox(width: 80),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
