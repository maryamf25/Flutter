import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageScannerScreen extends StatefulWidget {
  const ImageScannerScreen({super.key});

  @override
  State<ImageScannerScreen> createState() => _ImageScannerScreenState();
}

class _ImageScannerScreenState extends State<ImageScannerScreen> {
  XFile? _selectedImage;
  bool _isScanning = false;
  String? _detectedCode;
  String? _detectedFormat;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _isScanning = true;
          _detectedCode = null;
          _detectedFormat = null;
        });

        await _scanImageForBarcode();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error picking image: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _scanImageForBarcode() async {
    if (_selectedImage == null) return;

    try {
      final MobileScannerController controller = MobileScannerController();

      final BarcodeCapture? barcodes = await controller.analyzeImage(
        _selectedImage!.path,
      );

      await controller.dispose();

      if (barcodes != null && barcodes.barcodes.isNotEmpty) {
        final barcode = barcodes.barcodes.first;
        final code = barcode.rawValue;
        final format = barcode.format.name;

        if (code != null) {
          setState(() {
            _detectedCode = code;
            _detectedFormat = format;
            _isScanning = false;
          });

          Fluttertoast.showToast(
            msg: "✓ ${_getBarcodeTypeLabel(format)} detected!",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
          );
        } else {
          setState(() => _isScanning = false);
          _showNoCodeFound();
        }
      } else {
        setState(() => _isScanning = false);
        _showNoCodeFound();
      }
    } catch (e) {
      setState(() => _isScanning = false);
      Fluttertoast.showToast(
        msg: "Error scanning image: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _showNoCodeFound() {
    Fluttertoast.showToast(
      msg: "✗ No QR code or barcode found in image",
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  String _getBarcodeTypeLabel(String format) {
    if (format.toLowerCase().contains('qr')) {
      return 'QR Code';
    } else if (format.toLowerCase().contains('ean')) {
      return 'EAN Barcode';
    } else if (format.toLowerCase().contains('upc')) {
      return 'UPC Barcode';
    } else if (format.toLowerCase().contains('code')) {
      return 'Barcode ($format)';
    } else {
      return format;
    }
  }

  IconData _getBarcodeIcon(String format) {
    if (format.toLowerCase().contains('qr')) {
      return Icons.qr_code_2;
    } else {
      return Icons.barcode_reader;
    }
  }

  Color _getBarcodeColor(String format) {
    if (format.toLowerCase().contains('qr')) {
      return Colors.blueAccent;
    } else {
      return Colors.deepPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Scan from Image',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No image selected',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 30),

              if (_isScanning)
                Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Scanning for codes...',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),

              if (_detectedCode != null && _detectedFormat != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _getBarcodeColor(
                      _detectedFormat!,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getBarcodeColor(_detectedFormat!),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getBarcodeIcon(_detectedFormat!),
                        size: 48,
                        color: _getBarcodeColor(_detectedFormat!),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${_getBarcodeTypeLabel(_detectedFormat!)} Detected!',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getBarcodeColor(_detectedFormat!),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _detectedFormat!.toUpperCase(),
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SelectableText(
                          _detectedCode!,
                          style: GoogleFonts.robotoMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context, {
                            'code': _detectedCode!,
                            'format': _detectedFormat!,
                          });
                          Fluttertoast.showToast(
                            msg: "✓ Scan saved successfully!",
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );
                        },
                        icon: const Icon(Icons.check_circle),
                        label: Text(
                          'Save This Scan',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getBarcodeColor(_detectedFormat!),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (!_isScanning && _detectedCode == null)
                const SizedBox(height: 30),

              if (!_isScanning)
                Column(
                  children: [
                    _buildActionButton(
                      icon: Icons.photo_library,
                      label: 'Choose from Gallery',
                      color: Colors.blueAccent,
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      icon: Icons.camera_alt,
                      label: 'Take a Photo',
                      color: Colors.deepPurple,
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
