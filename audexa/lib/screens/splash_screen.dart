import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A1A),
                  Color(0xFF121212),
                  Color(0xFF1A1A1A),
                ],
              ),
            ),
          ),
          // Centered Logo and Text
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF23272A),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFBB86FC).withValues(alpha: 0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.mic_rounded,
                        size: 64,
                        color: Color(0xFFBB86FC),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const ShaderMask(
                    shaderCallback: _createShader,
                    child: Text(
                      'AUDEXA',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'AI POWERED VOICE NOTES',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Loading indicator at bottom
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 40,
                height: 2,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFBB86FC).withValues(alpha: 0.5)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Shader _createShader(Rect bounds) {
    return const LinearGradient(
      colors: [Color(0xFFBB86FC), Color(0xFF03DAC6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds);
  }
}
