import 'package:flutter/material.dart';

class ScannerOverlay extends StatelessWidget {
  final Rect scanWindow;

  const ScannerOverlay({super.key, required this.scanWindow});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcOut),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  backgroundBlendMode: BlendMode.dstIn,
                ),
              ),
              Positioned.fromRect(
                rect: scanWindow,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fromRect(
          rect: scanWindow,
          child: CustomPaint(painter: BorderPainter(), child: Container()),
        ),
      ],
    );
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double length = 30.0;
    final double strokeWidth = 5.0;

    final Paint paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(
      Path()
        ..moveTo(0, length)
        ..lineTo(0, 0)
        ..lineTo(length, 0),
      paint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(width - length, 0)
        ..lineTo(width, 0)
        ..lineTo(width, length),
      paint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(width, height - length)
        ..lineTo(width, height)
        ..lineTo(width - length, height),
      paint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(length, height)
        ..lineTo(0, height)
        ..lineTo(0, height - length),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
