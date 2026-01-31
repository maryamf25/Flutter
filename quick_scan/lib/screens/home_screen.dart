import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/scan_item.dart';
import '../services/hive_service.dart';
import 'scanner_screen.dart';
import 'onboarding_screen.dart';
import 'generator_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      appBar: AppBar(
        title: Text(
          'QuickScan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF3D3D3D),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Generate Code',
          onPressed: () => _openGenerator(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Quick Start Guide',
            onPressed: () => _showQuickStart(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear All',
            onPressed: () => _clearAllScans(context),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<ScanItem>>(
        valueListenable: HiveService.getBox().listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 100,
                    color: const Color(0xFFFDB623),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No scans yet',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to start scanning',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          final items = box.values.toList().reversed.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildScanCard(context, item);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'camera_scan',
        onPressed: () => _openScanner(context),
        icon: const Icon(Icons.qr_code_scanner),
        label: Text(
          'Scan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFFDB623),
        foregroundColor: const Color(0xFF2D2D2D),
      ),
    );
  }

  Widget _buildScanCard(BuildContext context, ScanItem item) {
    final bool isQRCode = item.format.toLowerCase().contains('qr');
    final IconData iconData = isQRCode ? Icons.qr_code_2 : Icons.barcode_reader;
    final Color iconColor = const Color(0xFFFDB623);
    final String typeLabel = isQRCode ? 'QR Code' : 'Barcode';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      color: const Color(0xFF3D3D3D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Slidable(
        key: ValueKey(item.key),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) => _deleteItem(context, item),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: ListTile(
          onTap: () => _handleItemTap(context, item),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$typeLabel • ${item.format.toUpperCase()}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: iconColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.code,
                style: GoogleFonts.robotoMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM dd, yyyy hh:mm a').format(item.timestamp),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openScanner(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (result != null && result is Map) {
      final code = result['code']?.toString();
      final format = result['format']?.toString();

      if (code != null && format != null) {
        await HiveService.addScan(code, format);

        if (context.mounted) {
          Fluttertoast.showToast(
            msg:
                "✓ ${format.toLowerCase().contains('qr') ? 'QR Code' : 'Barcode'} saved!",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      }
    }
  }

  void _handleItemTap(BuildContext context, ScanItem item) {
    _showContentDialog(context, item);
  }

  void _showContentDialog(BuildContext context, ScanItem item) {
    final bool isQRCode = item.format.toLowerCase().contains('qr');
    final String typeLabel = isQRCode ? 'QR Code' : 'Barcode';
    final String code = item.code;

    final bool isUrl =
        code.startsWith('http://') ||
        code.startsWith('https://') ||
        code.startsWith('www.');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3D3D3D),
        title: Row(
          children: [
            Icon(
              isQRCode ? Icons.qr_code_2 : Icons.barcode_reader,
              color: const Color(0xFFFDB623),
            ),
            const SizedBox(width: 8),
            Text(
              typeLabel,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.format.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFDB623),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SelectableText(
              item.code,
              style: GoogleFonts.robotoMono(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM dd, yyyy hh:mm a').format(item.timestamp),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: isUrl
                    ? ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          try {
                            String urlToLaunch = code;
                            if (code.startsWith('www.')) {
                              urlToLaunch = 'https://$code';
                            }
                            final Uri uri = Uri.parse(urlToLaunch);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                              Fluttertoast.showToast(
                                msg: "🌐 Opening link...",
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                              );
                            }
                          } catch (e) {
                            Fluttertoast.showToast(
                              msg: "❌ Could not open link",
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        },
                        icon: const Icon(Icons.open_in_browser, size: 18),
                        label: Text(
                          'Open',
                          style: GoogleFonts.poppins(fontSize: 11),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDB623),
                          foregroundColor: const Color(0xFF2D2D2D),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          try {
                            final searchUrl =
                                'https://www.google.com/search?q=${Uri.encodeComponent(code)}';
                            final Uri uri = Uri.parse(searchUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                              Fluttertoast.showToast(
                                msg: "🔍 Searching...",
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                              );
                            }
                          } catch (e) {
                            Fluttertoast.showToast(
                              msg: "❌ Could not search",
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        },
                        icon: const Icon(Icons.search, size: 18),
                        label: Text(
                          'Search',
                          style: GoogleFonts.poppins(fontSize: 11),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDB623),
                          foregroundColor: const Color(0xFF2D2D2D),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _copyToClipboard(context, item.code);
                  },
                  icon: const Icon(Icons.copy, size: 18),
                  label: Text('Copy', style: GoogleFonts.poppins(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFDB623),
                    side: const BorderSide(color: Color(0xFFFDB623)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _shareItem(item);
                  },
                  icon: const Icon(Icons.share, size: 18),
                  label: Text(
                    'Share',
                    style: GoogleFonts.poppins(fontSize: 11),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFDB623),
                    side: const BorderSide(color: Color(0xFFFDB623)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(
      msg: "✓ Copied to clipboard!",
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _shareItem(ScanItem item) {
    final String typeLabel = item.format.toLowerCase().contains('qr')
        ? 'QR Code'
        : 'Barcode';
    Share.share(
      'QuickScan - $typeLabel\n\nFormat: ${item.format}\nScanned: ${DateFormat('MMM dd, yyyy hh:mm a').format(item.timestamp)}\n\nData:\n${item.code}',
      subject: 'Scanned $typeLabel',
    );

    Fluttertoast.showToast(
      msg: "📤 Sharing scan...",
      backgroundColor: Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _deleteItem(BuildContext context, ScanItem item) {
    item.delete();
    Fluttertoast.showToast(
      msg: "✓ Scan deleted",
      backgroundColor: Colors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _clearAllScans(BuildContext context) {
    final int count = HiveService.getBox().length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3D3D3D),
        title: Text(
          'Clear All Scans?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Text(
          'This will permanently delete all $count scan${count != 1 ? 's' : ''} from your history.',
          style: GoogleFonts.poppins(color: Colors.grey[400]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey[400]),
            ),
          ),
          TextButton(
            onPressed: () {
              HiveService.getBox().clear();
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "✓ All scans cleared",
                backgroundColor: Colors.orange,
                textColor: Colors.white,
                toastLength: Toast.LENGTH_SHORT,
              );
            },
            child: Text(
              'Clear All',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickStart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  void _openGenerator(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GeneratorScreen()),
    );
  }
}
