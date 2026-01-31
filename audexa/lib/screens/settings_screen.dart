import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onDeleteAllNotes;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({
    Key? key,
    required this.onDeleteAllNotes,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Delete All Notes'),
            trailing: Icon(Icons.delete_forever, color: Colors.red),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete'),
                  content:
                      const Text('Are you sure you want to delete all notes?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                onDeleteAllNotes();
              }
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: onThemeChanged,
          ),
        ],
      ),
    );
  }
}
