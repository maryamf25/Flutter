import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode/barcode.dart' as bc;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey _qrKey = GlobalKey();
  final GlobalKey _barcodeKey = GlobalKey();

  String _generatedData = '';
  bool _isQRCode = true;
  String _selectedBarcodeType = 'Code 128';
  String? _validationError;

  final Map<String, bc.Barcode> _barcodeTypes = {
    'Code 128': bc.Barcode.code128(),
    'Code 39': bc.Barcode.code39(),
    'EAN-13': bc.Barcode.ean13(),
    'EAN-8': bc.Barcode.ean8(),
    'UPC-A': bc.Barcode.upcA(),
  };

  final Map<String, String> _barcodeHints = {
    'Code 128': 'Alphanumeric (e.g., ABC123)',
    'Code 39': 'Alphanumeric + special chars (e.g., ABC-123)',
    'EAN-13': '12 digits (e.g., 123456789012)',
    'EAN-8': '7 digits (e.g., 1234567)',
    'UPC-A': '11 or 12 digits (e.g., 12345678901)',
  };

  @override
  void initState() {
    super.initState();
    _textController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _textController.removeListener(_validateInput);
    _textController.dispose();
    super.dispose();
  }

  void _validateInput() {
    final text = _textController.text.trim();

    if (text.isEmpty) {
      setState(() => _validationError = null);
      return;
    }

    if (_isQRCode) {
      setState(() => _validationError = null);
      return;
    }

    String? error;
    try {
      switch (_selectedBarcodeType) {
        case 'EAN-13':
          if (!RegExp(r'^\d{12}$').hasMatch(text)) {
            error = 'Must be exactly 12 digits for EAN-13';
          }
          break;
        case 'EAN-8':
          if (!RegExp(r'^\d{7}$').hasMatch(text)) {
            error = 'Must be exactly 7 digits for EAN-8';
          }
          break;
        case 'UPC-A':
          if (!RegExp(r'^\d{11,12}$').hasMatch(text)) {
            error = 'Must be 11 or 12 digits';
          }
          break;
        case 'Code 39':
          if (!RegExp(
            r'^[A-Z0-9\-\.\$\/\+\%\s]+$',
          ).hasMatch(text.toUpperCase())) {
            error = 'Invalid characters for Code 39';
          }
          break;
      }
    } catch (e) {
      error = 'Invalid format';
    }

    setState(() => _validationError = error);
  }

  bool get _isInputValid {
    final text = _textController.text.trim();
    return text.isNotEmpty && _validationError == null;
  }

  String _addChecksumIfNeeded(String text) {
    switch (_selectedBarcodeType) {
      case 'EAN-13':
        if (text.length == 12) {
          return text + _calculateEAN13Checksum(text);
        }
        return text;
      case 'EAN-8':
        if (text.length == 7) {
          return text + _calculateEAN8Checksum(text);
        }
        return text;
      case 'UPC-A':
        if (text.length == 11) {
          return text + _calculateUPCAChecksum(text);
        }
        return text;
      case 'Code 39':
        return text.toUpperCase();
      default:
        return text;
    }
  }

  String _calculateEAN13Checksum(String code) {
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      int digit = int.parse(code[i]);
      sum += (i % 2 == 0) ? digit : digit * 3;
    }
    int checksum = (10 - (sum % 10)) % 10;
    return checksum.toString();
  }

  String _calculateEAN8Checksum(String data) {
    if (data.length != 7) throw ArgumentError('Data must be 7 digits');
    int sum = 0;
    for (int i = 0; i < 7; i++) {
      int digit = int.parse(data[i]);
      sum += (i % 2 == 0) ? digit * 3 : digit;
    }
    int checksum = (10 - (sum % 10)) % 10;
    return checksum.toString();
  }

  String _calculateUPCAChecksum(String code) {
    int sum = 0;
    for (int i = 0; i < 11; i++) {
      int digit = int.parse(code[i]);
      sum += (i % 2 == 0) ? digit * 3 : digit;
    }
    int checksum = (10 - (sum % 10)) % 10;
    return checksum.toString();
  }

  void _generateCode() {
    final text = _textController.text.trim();

    if (!_isInputValid) return;

    try {
      final finalData = _addChecksumIfNeeded(text);

      if (!_isQRCode) {
        _barcodeTypes[_selectedBarcodeType]!.make(
          finalData,
          width: 200,
          height: 80,
        );
      }

      setState(() {
        _generatedData = finalData;
      });

      Fluttertoast.showToast(
        msg: "✓ ${_isQRCode ? 'QR Code' : _selectedBarcodeType} generated!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      FocusScope.of(context).unfocus();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "✗ Error: ${e.toString()}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> _saveAndShareCode() async {
    if (_generatedData.isEmpty) {
      Fluttertoast.showToast(
        msg: "⚠ Generate a code first",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final key = _isQRCode ? _qrKey : _barcodeKey;
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('Unable to capture code. Please try again.');
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to convert image');
      }

      final pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/${_isQRCode ? 'qr_code' : 'barcode'}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Generated ${_isQRCode ? 'QR Code' : 'Barcode'}: $_generatedData',
      );

      Fluttertoast.showToast(
        msg: "✓ Code shared successfully",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "✗ Error sharing: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _copyToClipboard() {
    if (_generatedData.isEmpty) {
      Fluttertoast.showToast(
        msg: "⚠ No data to copy",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    Clipboard.setData(ClipboardData(text: _generatedData));
    Fluttertoast.showToast(
      msg: "✓ Copied to clipboard",
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      appBar: AppBar(
        title: Text(
          'Generate Code',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF3D3D3D),
        foregroundColor: Colors.white,
        actions: [
          if (_generatedData.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: 'Copy Data',
              onPressed: _copyToClipboard,
            ),
          if (_generatedData.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Share',
              onPressed: _saveAndShareCode,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF3D3D3D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      label: 'QR Code',
                      icon: Icons.qr_code_2,
                      isSelected: _isQRCode,
                      onTap: () {
                        setState(() {
                          _isQRCode = true;
                          _generatedData = '';
                          _textController.clear();
                          _validationError = null;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildToggleButton(
                      label: 'Barcode',
                      icon: Icons.barcode_reader,
                      isSelected: !_isQRCode,
                      onTap: () {
                        setState(() {
                          _isQRCode = false;
                          _generatedData = '';
                          _textController.clear();
                          _validationError = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (!_isQRCode) ...[
              Text(
                'Barcode Type',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D3D3D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: _selectedBarcodeType,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF3D3D3D),
                  underline: const SizedBox(),
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                  items: _barcodeTypes.keys.map((name) {
                    return DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBarcodeType = value!;
                      _generatedData = '';
                      _textController.clear();
                      _validationError = null;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            Text(
              'Enter Data',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              style: GoogleFonts.poppins(color: Colors.white),
              maxLines: 3,
              onChanged: (value) => _validateInput(),
              decoration: InputDecoration(
                hintText: _isQRCode
                    ? 'Enter any text, URL, or data...'
                    : _barcodeHints[_selectedBarcodeType],
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                filled: true,
                fillColor: const Color(0xFF3D3D3D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                errorText: _validationError,
                errorStyle: GoogleFonts.poppins(
                  color: Colors.red[300],
                  fontSize: 12,
                ),
                errorMaxLines: 2,
              ),
            ),

            const SizedBox(height: 20),

            if (!_isQRCode &&
                [
                  'EAN-13',
                  'EAN-8',
                  'UPC-A',
                ].contains(_selectedBarcodeType)) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(0xFF6C5CE7),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Checksum will be auto-calculated',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF6C5CE7),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            ElevatedButton.icon(
              onPressed: _isInputValid ? _generateCode : null,
              icon: const Icon(Icons.auto_awesome),
              label: Text(
                'Generate ${_isQRCode ? 'QR Code' : 'Barcode'}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isInputValid
                    ? const Color(0xFFFDB623)
                    : Colors.grey[700],
                foregroundColor: _isInputValid
                    ? const Color(0xFF2D2D2D)
                    : Colors.grey[500],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey[700],
                disabledForegroundColor: Colors.grey[500],
              ),
            ),

            const SizedBox(height: 32),

            if (_generatedData.isNotEmpty) ...[
              Text(
                'Generated ${_isQRCode ? 'QR Code' : _selectedBarcodeType}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: _isQRCode
                      ? RepaintBoundary(
                          key: _qrKey,
                          child: QrImageView(
                            data: _generatedData,
                            version: QrVersions.auto,
                            size: 250,
                            backgroundColor: Colors.white,
                          ),
                        )
                      : RepaintBoundary(
                          key: _barcodeKey,
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16),
                            child: BarcodeWidget(
                              barcode: _barcodeTypes[_selectedBarcodeType]!,
                              data: _generatedData,
                              width: 280,
                              height: 120,
                              drawText: true,
                              style: GoogleFonts.robotoMono(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D3D3D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isQRCode ? Icons.qr_code_2 : Icons.barcode_reader,
                          color: const Color(0xFFFDB623),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Data:',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[400],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _generatedData,
                      style: GoogleFonts.robotoMono(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _copyToClipboard,
                      icon: const Icon(Icons.copy),
                      label: Text(
                        'Copy',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFDB623),
                        side: const BorderSide(color: Color(0xFFFDB623)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveAndShareCode,
                      icon: const Icon(Icons.share),
                      label: Text(
                        'Share',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFDB623),
                        foregroundColor: const Color(0xFF2D2D2D),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDB623) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF2D2D2D) : Colors.grey[400],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? const Color(0xFF2D2D2D) : Colors.grey[400],
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
