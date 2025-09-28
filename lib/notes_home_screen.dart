import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({super.key});

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  final List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotesFromHive();
  }

  /// Load notes from Hive
  void _loadNotesFromHive() {
    final box = Hive.box('notesBox');
    final loadedNotes = box.keys
        .map((key) {
          final note = box.get(key);
          return {
            'key': key, // Hive key for edit/delete
            'title': note['title'] ?? '',
            'content': note['content'] ?? '',
            'color': note['color'] != null
                ? Color(note['color'] as int) // convert back to Color
                : Colors.white,
            'created': note['created'],
          };
        })
        .toList()
        .reversed
        .toList();

    setState(() {
      _notes
        ..clear()
        ..addAll(loadedNotes);
    });
  }

  /// Add or Edit
  void _navigateToEditor({Map<String, dynamic>? note}) async {
    final result = await Navigator.pushNamed(context, '/edit', arguments: note);

    if (result != null && result is Map<String, dynamic>) {
      final box = Hive.box('notesBox');

      if (note != null) {
        // ✅ Update existing note
        await box.put(note['key'], {
          'title': result['title'],
          'content': result['content'],
          'color': (result['color'] as Color).value, // store as int
          'created': note['created'],
        });
      } else {
        // ✅ Add new note
        await box.add({
          'title': result['title'],
          'content': result['content'],
          'color': (result['color'] as Color).value, // store as int
          'created': result['created'],
        });
      }

      _loadNotesFromHive(); // refresh UI
    }
  }

  /// Delete
  void _deleteNote(int key) async {
    final box = Hive.box('notesBox');
    await box.delete(key);
    _loadNotesFromHive();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = _notes.isEmpty;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'My Notes',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ),
      body: isEmpty ? _buildEmptyState() : _buildNotesList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _navigateToEditor(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/note_empty.png',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'Create your first note!',
              style: TextStyle(fontSize: 18, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return GestureDetector(
            onTap: () => _navigateToEditor(note: note), // Edit on tap
            onLongPress: () => _showNoteOptions(note), // Long press options
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: note['color'] as Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                note['title'],
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Dialog with Edit/Delete
  void _showNoteOptions(Map<String, dynamic> note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          "Note Options",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Choose an action",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToEditor(note: note);
            },
            child: const Text(
              "Edit",
              style: TextStyle(color: Colors.tealAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteNote(note['key']);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
