import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../widgets/recording_sheet.dart';
import 'onboarding_guide.dart';
import 'edit_note_screen.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _listAnimController;

  @override
  void initState() {
    super.initState();
    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _listAnimController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
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
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, noteProvider),
                if (_isSearchVisible) _buildSearchField(noteProvider),
                Expanded(
                  child: noteProvider.isLoading
                      ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
                      : noteProvider.notes.isEmpty
                          ? _buildEmptyState()
                          : _buildNotesList(noteProvider),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildHeader(BuildContext context, NoteProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => _createShader(bounds, context),
            child: Text(
              "AUDEXA",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : theme.colorScheme.primary,
                letterSpacing: 4,
              ),
            ),
          ),
          Row(
            children: [
              _buildHeaderIcon(
                context: context,
                icon: Icons.help_outline_rounded,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => OnboardingGuide(onDone: () => Navigator.of(context).pop())),
                ),
              ),
              const SizedBox(width: 12),
              _buildHeaderIcon(
                context: context,
                icon: _isSearchVisible ? Icons.close_rounded : Icons.search_rounded,
                onTap: () {
                  setState(() {
                    _isSearchVisible = !_isSearchVisible;
                    if (!_isSearchVisible) {
                      _searchController.clear();
                      provider.setSearchQuery('');
                    }
                  });
                },
              ),
              const SizedBox(width: 12),
              _buildHeaderIcon(
                context: context,
                icon: Icons.settings_rounded,
                onTap: () {
                  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SettingsScreen(
                        onDeleteAllNotes: () {
                          provider.deleteAllNotes();
                        },
                        isDarkMode: themeProvider.isDarkMode,
                        onThemeChanged: (val) {
                          themeProvider.toggleTheme(val);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon({required BuildContext context, required IconData icon, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
      ),
    );
  }

  Widget _buildSearchField(NoteProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => provider.setSearchQuery(val),
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: "Search your thoughts...",
          hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26),
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary, size: 20),
          filled: true,
          fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mic_none_rounded, size: 80, color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1)),
          const SizedBox(height: 24),
          Text(
            "Silence is golden, but notes are better.",
            style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 16, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap 'Record' to begin.",
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(NoteProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      itemCount: provider.notes.length,
      itemBuilder: (context, index) {
        final note = provider.notes[index];
        return AnimatedBuilder(
          animation: _listAnimController,
          builder: (context, child) {
            final delay = index * 0.1;
            final start = delay.clamp(0.0, 1.0);
            final end = (delay + 0.5).clamp(0.0, 1.0);
            final curve = CurvedAnimation(
              parent: _listAnimController,
              curve: Interval(start, end, curve: Curves.easeOutQuart),
            );
            return FadeTransition(
              opacity: curve,
              child: Transform.translate(
                offset: Offset(0, 50 * (1 - curve.value)),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: _buildNoteCard(context, note, provider),
          ),
        );
      },
    );
  }

  Widget _buildNoteCard(BuildContext context, dynamic note, NoteProvider provider) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05)),
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditNoteScreen(note: note))),
              contentPadding: const EdgeInsets.all(20),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    DateFormat('MMM d').format(note.createdAt),
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  note.content,
                  style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: PopupMenuButton(
                icon: Icon(Icons.more_vert, color: isDark ? Colors.white38 : Colors.black26),
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text("Edit")),
                  const PopupMenuItem(value: 'delete', child: Text("Delete", style: TextStyle(color: Colors.redAccent))),
                ],
                onSelected: (val) async {
                  if (val == 'edit') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => EditNoteScreen(note: note)));
                  } else if (val == 'delete') {
                    final confirm = await _showDeleteDialog(context);
                    if (confirm == true) provider.deleteNote(note.id);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Delete Note?"),
          content: const Text("This action cannot be undone."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      height: 64,
      margin: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const RecordingSheet(),
          );
        },
        elevation: 10,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: isDark ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.mic_rounded, size: 28),
        label: const Text("RECORD", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
      ),
    );
  }

  Shader _createShader(Rect bounds, BuildContext context) {
    final theme = Theme.of(context);
    return LinearGradient(
      colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds);
  }
}
