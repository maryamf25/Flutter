import 'dart:ui';
import 'package:flutter/material.dart';

class OnboardingGuide extends StatefulWidget {
  final VoidCallback onDone;
  const OnboardingGuide({super.key, required this.onDone});

  @override
  State<OnboardingGuide> createState() => _OnboardingGuideState();
}

class _OnboardingGuideState extends State<OnboardingGuide> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> steps = [
    {
      'icon': Icons.mic,
      'title': 'Record Voice Notes',
      'desc': 'Tap the mic button to start recording your thoughts instantly.'
    },
    {
      'icon': Icons.edit,
      'title': 'Edit & Organize',
      'desc': 'Edit, rename, and organize your notes for easy access.'
    },
    {
      'icon': Icons.delete,
      'title': 'Delete Easily',
      'desc': 'Remove notes you no longer need with a single tap.'
    },
    {
      'icon': Icons.search,
      'title': 'Search Instantly',
      'desc': 'Find any note quickly using the search bar.'
    },
  ];

  void _goTo(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      body: Stack(
        children: [
          // Theme-aware background gradient
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF2B133D),
                        const Color(0xFF1F1F1F),
                        const Color(0xFF23272A),
                        primaryColor.withValues(alpha: 0.3),
                      ]
                    : [
                        const Color(0xFFE0C3FC),
                        const Color(0xFFF5F5F5),
                        const Color(0xFFF3E5F5),
                        primaryColor.withValues(alpha: 0.2),
                      ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      'How to Use Audexa',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : primaryColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: steps.length,
                      onPageChanged: (i) => setState(() => _currentPage = i),
                      itemBuilder: (context, i) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.3),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: isDark
                                  ? const Color(0xFF23272A)
                                  : Colors.white,
                              radius: 38,
                              child: Icon(steps[i]['icon'] as IconData,
                                  color: primaryColor, size: 40),
                            ),
                          ),
                          const SizedBox(height: 32),
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: [primaryColor, secondaryColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: Text(
                              steps[i]['title'] as String,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            steps[i]['desc'] as String,
                            style: TextStyle(
                              fontSize: 17,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      steps.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? primaryColor
                              : (isDark ? Colors.white24 : Colors.black12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _currentPage == 0
                            ? null
                            : () => _goTo(_currentPage - 1),
                        child: Text('Prev',
                            style: TextStyle(
                                fontSize: 18,
                                color: _currentPage == 0
                                    ? Colors.grey
                                    : primaryColor)),
                      ),
                      TextButton(
                        onPressed: widget.onDone,
                        child: Text('Skip',
                            style: TextStyle(
                                fontSize: 18,
                                color: isDark
                                    ? Colors.white54
                                    : Colors.black45)),
                      ),
                      _currentPage == steps.length - 1
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: isDark ? Colors.black : Colors.white,
                                minimumSize: const Size(80, 44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: widget.onDone,
                              child: const Text('Done',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: isDark ? Colors.black : Colors.white,
                                minimumSize: const Size(80, 44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: () => _goTo(_currentPage + 1),
                              child: const Text('Next',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                    ],
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
