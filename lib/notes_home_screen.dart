import 'package:flutter/material.dart';

class NotesHomeScreen extends StatefulWidget {
  const NotesHomeScreen({Key? key}) : super(key: key);

  @override
  State<NotesHomeScreen> createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  final List<Map<String, dynamic>> _notes = [];

  void _navigateToEditor() async {
    final newNote = await Navigator.pushNamed(context, '/edit');

    print("Received note: $newNote"); // 🔍

    if (newNote != null && newNote is Map<String, dynamic>) {
      setState(() {
        _notes.insert(0, newNote);
      });
    }
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
          'Notes',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: isEmpty ? _buildEmptyState() : _buildNotesList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: _navigateToEditor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Widget when no notes are present
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

  /// Widget to show list of notes
  Widget _buildNotesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return GestureDetector(
            onTap: () {
              // In future: navigate to detail/edit
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: note['color'],
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
}
