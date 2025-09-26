import 'package:flutter/material.dart';
import 'notes_home_screen.dart';
import 'note_editor_screen.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData.dark(),
      home: const NotesHomeScreen(),
      routes: {'/edit': (_) => const NoteEditorScreen()},
    );
  }
}
