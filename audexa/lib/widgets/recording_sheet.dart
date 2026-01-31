import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';

class RecordingSheet extends StatefulWidget {
  const RecordingSheet({super.key});

  @override
  State<RecordingSheet> createState() => _RecordingSheetState();
}

class _RecordingSheetState extends State<RecordingSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<String?> _promptForName(BuildContext context) async {
    final theme = Theme.of(context);
    String? noteName;
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final controller = TextEditingController();
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text('Name your recording',
                style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold)),
            content: TextField(
              controller: controller,
              autofocus: true,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: 'e.g. Meeting Notes',
                hintStyle: TextStyle(
                    color: theme.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.5)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.dividerColor)),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: theme.colorScheme.primary, width: 2)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel',
                    style: TextStyle(color: theme.colorScheme.secondary)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  noteName = controller.text.trim();
                  if (noteName!.isEmpty) return;
                  Navigator.of(context).pop(noteName);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            // Handle
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 32),

            Text(
              noteProvider.isListening ? "Listening..." : "Paused",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: noteProvider.isListening
                    ? theme.colorScheme.secondary
                    : (isDark ? Colors.white54 : Colors.black45),
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            // Visualizer
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(15, (index) {
                  return AnimatedContainer(
                    duration: Duration(
                        milliseconds: noteProvider.isListening
                            ? (150 + (index * 30))
                            : 500),
                    width: 6,
                    height: noteProvider.isListening
                        ? (Random().nextInt(60) + 15).toDouble()
                        : 4,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        if (noteProvider.isListening)
                          BoxShadow(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 32),

            // Transcript Box
            Expanded(
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.05)),
                  ),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Text(
                      noteProvider.currentText.isEmpty
                          ? "Say something, I'm listening..."
                          : noteProvider.currentText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: noteProvider.currentText.isEmpty
                            ? (isDark ? Colors.white24 : Colors.black26)
                            : theme.textTheme.bodyLarge?.color,
                        height: 1.5,
                        fontStyle: noteProvider.currentText.isEmpty
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  )),
            ),

            const SizedBox(height: 32),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel
                _buildActionButton(
                  icon: Icons.close_rounded,
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  iconColor: Colors.redAccent,
                  onTap: () {
                    noteProvider.stopListening();
                    Navigator.pop(context);
                  },
                ),

                // Main Record Button
                GestureDetector(
                  onTap: () {
                    if (noteProvider.isListening) {
                      noteProvider.stopListening();
                    } else {
                      noteProvider.startListening((val) {});
                    }
                  },
                  child: ScaleTransition(
                    scale: noteProvider.isListening
                        ? _pulseAnimation
                        : const AlwaysStoppedAnimation(1.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: noteProvider.isListening
                              ? [
                                  const Color(0xFFFF5252),
                                  const Color(0xFFFF1744)
                                ]
                              : [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.secondary
                                ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (noteProvider.isListening
                                    ? Colors.redAccent
                                    : theme.colorScheme.primary)
                                .withValues(alpha: 0.4),
                            blurRadius: 25,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        noteProvider.isListening
                            ? Icons.stop_rounded
                            : Icons.mic_rounded,
                        color: theme.colorScheme.onPrimary,
                        size: 40,
                      ),
                    ),
                  ),
                ),

                // Save Button
                _isSaving
                    ? SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                            color: theme.colorScheme.secondary),
                      )
                    : _buildActionButton(
                        icon: Icons.check_rounded,
                        color:
                            theme.colorScheme.secondary.withValues(alpha: 0.1),
                        iconColor: theme.colorScheme.secondary,
                        onTap: () => _saveRecording(context),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: iconColor.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: iconColor, size: 30),
      ),
    );
  }

  Future<void> _saveRecording(BuildContext context) async {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final text = noteProvider.currentText.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nothing to save!")),
      );
      return;
    }

    final name = await _promptForName(context);
    if (name == null) return;

    setState(() => _isSaving = true);
    noteProvider.stopListening();
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      noteProvider.addNote(name, text);
      setState(() => _isSaving = false);
      Navigator.pop(context);
    }
  }
}
