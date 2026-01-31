import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/scanner_overlay.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
    formats: const [BarcodeFormat.all],
  );

  bool _isFlashOn = false;
  bool _isScanCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.camera.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      _controller.start();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  void _handleDetection(BarcodeCapture capture) {
    if (_isScanCompleted) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final code = barcodes.first.rawValue;
      var format = barcodes.first.format.name;

      if (code != null) {
        setState(() {
          _isScanCompleted = true;
        });

        HapticFeedback.heavyImpact();

        final bool isQRCode = format.toLowerCase().contains('qr');
        final String typeLabel = isQRCode ? 'QR Code' : 'Barcode';

        Fluttertoast.showToast(
          msg: "✓ $typeLabel ($format) detected!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );

        Navigator.pop(context, {'code': code, 'format': format});
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final barcodes = await _controller.analyzeImage(image.path);

        if (barcodes != null && barcodes.barcodes.isNotEmpty) {
          final barcode = barcodes.barcodes.first;
          final code = barcode.rawValue;
          final format = barcode.format.name;

          if (code != null) {
            HapticFeedback.heavyImpact();

            final bool isQRCode = format.toLowerCase().contains('qr');
            final String typeLabel = isQRCode ? 'QR Code' : 'Barcode';

            Fluttertoast.showToast(
              msg: "✓ $typeLabel ($format) detected from image!",
              backgroundColor: Colors.green,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT,
            );

            if (mounted) {
              Navigator.pop(context, {'code': code, 'format': format});
            }
          }
        } else {
          Fluttertoast.showToast(
            msg: "✗ No code found in image",
            backgroundColor: Colors.orange,
            textColor: Colors.white,
          );
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double scanWindowWidth = MediaQuery.of(context).size.width * 0.7;
    final double scanWindowHeight = scanWindowWidth;
    final Rect scanWindow = Rect.fromCenter(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      ),
      width: scanWindowWidth,
      height: scanWindowHeight,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _handleDetection,
            scanWindow: scanWindow,
          ),

          ScannerOverlay(scanWindow: scanWindow),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Text(
                    'Scan Code',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              height: 220,
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Text(
                    "Align code within the frame",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(
                        icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
                        label: 'Flash',
                        onTap: () {
                          _controller.toggleTorch();
                          setState(() => _isFlashOn = !_isFlashOn);
                        },
                      ),
                      const SizedBox(width: 30),
                      _buildControlButton(
                        icon: Icons.cameraswitch_outlined,
                        label: 'Flip',
                        onTap: () => _controller.switchCamera(),
                      ),
                      const SizedBox(width: 30),
                      _buildControlButton(
                        icon: Icons.photo_library,
                        label: 'Gallery',
                        onTap: _pickImageFromGallery,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
