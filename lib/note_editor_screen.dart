import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) return;

    final note = {
      'title': title,
      'content': content,
      'color': _getRandomColor().value, // store as int
      'created': DateTime.now().toIso8601String(),
    };

    final box = Hive.box('notesBox');
    await box.add(note);

    Navigator.pop(context, note); // return to home with new note
  }

  Color _getRandomColor() {
    final colors = [
      Colors.pinkAccent.shade100,
      Colors.redAccent.shade100,
      Colors.lightGreenAccent.shade100,
      Colors.yellowAccent.shade100,
      Colors.cyanAccent.shade100,
      Colors.deepPurpleAccent.shade100,
      Colors.orangeAccent.shade100,
      Colors.blueAccent.shade100,
    ];
    colors.shuffle();
    return colors.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_red_eye, color: Colors.white),
            onPressed: () {
              // Preview logic (not implemented)
            },
          ),
          IconButton(
            icon: const Icon(Icons.save_alt, color: Colors.white),
            onPressed: _saveNote,
          ),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 28, color: Colors.white70),
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: _contentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Type something...',
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),
            _buildToolbar(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, right: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.teal,
              onPressed: _saveNote,
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          IconButton(
            icon: Icon(Icons.format_bold, color: Colors.white),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.format_italic, color: Colors.white),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.format_underline, color: Colors.white),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.link, color: Colors.white),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.format_list_bulleted, color: Colors.white),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.format_list_numbered, color: Colors.white),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.code, color: Colors.white),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.format_quote, color: Colors.white),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.title, color: Colors.white),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.image, color: Colors.white),
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
