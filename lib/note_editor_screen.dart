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

  int? _noteKey; // ✅ if editing, keep track of Hive key
  late Color _noteColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      // Editing existing note
      _noteKey = args['key'];
      _titleController.text = args['title'] ?? '';
      _contentController.text = args['content'] ?? '';
      _noteColor = args['color'] as Color;
    } else {
      // New note
      _noteColor = _getRandomColor();
    }
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) return;

    final box = Hive.box('notesBox');

    final note = {
      'title': title,
      'content': content,
      'color': _noteColor.value, // ✅ always save as int
      'created': DateTime.now().toIso8601String(),
    };

    if (_noteKey != null) {
      // ✅ Update existing note
      await box.put(_noteKey, note);
      Navigator.pop(context, {
        ...note,
        'key': _noteKey,
        'color': _noteColor, // pass back as Color
      });
    } else {
      // ✅ Add new note
      final newKey = await box.add(note);
      Navigator.pop(context, {
        ...note,
        'key': newKey,
        'color': _noteColor, // pass back as Color
      });
    }
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
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: _saveNote,
        child: const Icon(Icons.send, color: Colors.white),
      ),
    );
  }
}
