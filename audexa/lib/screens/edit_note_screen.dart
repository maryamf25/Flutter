import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../models/voice_note.dart';

class EditNoteScreen extends StatefulWidget {
  final VoiceNote note;
  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    
    _animController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Edit Note",
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            letterSpacing: 1.2,
            color: isDark ? Colors.white : theme.colorScheme.primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: isDark ? Colors.white : theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _isSaving
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: theme.colorScheme.primary),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.check_circle_outline, color: theme.colorScheme.secondary, size: 28),
                  onPressed: () => _saveNote(context),
                )
        ],
      ),
      body: Stack(
        children: [
          // Background
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF2B133D),
                        const Color(0xFF121212),
                        const Color(0xFF1F1F1F),
                      ]
                    : [
                        const Color(0xFFE0C3FC),
                        const Color(0xFFF5F5F5),
                        const Color(0xFFF3E5F5),
                      ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : theme.colorScheme.primary.withValues(alpha: 0.1)),
                        boxShadow: isDark ? [] : [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _titleController,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                                letterSpacing: 0.5),
                            decoration: InputDecoration(
                              hintText: "Title",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26),
                            ),
                          ),
                          Divider(color: isDark ? Colors.white12 : theme.colorScheme.primary.withValues(alpha: 0.1), height: 32),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height * 0.3,
                            ),
                            child: TextField(
                              controller: _contentController,
                              maxLines: null,
                              style: TextStyle(
                                fontSize: 18, 
                                color: isDark ? Colors.white : Colors.black87,
                                height: 1.6,
                              ),
                              decoration: InputDecoration(
                                hintText: "Start typing...",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Info card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.secondary.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: theme.colorScheme.secondary, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Last updated: ${widget.note.updatedAt.toString().split('.')[0]}",
                              style: TextStyle(color: theme.colorScheme.secondary, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveNote(BuildContext context) async {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Title and content cannot be empty")),
      );
      return;
    }
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Provider.of<NoteProvider>(context, listen: false).updateNote(
      widget.note.id,
      _titleController.text,
      _contentController.text,
    );
    setState(() => _isSaving = false);
    Navigator.pop(context);
  }
}
