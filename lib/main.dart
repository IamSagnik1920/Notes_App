import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'notes_home_screen.dart';
import 'note_editor_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get app directory
  final appDir = await path_provider.getApplicationDocumentsDirectory();

  // Initialize Hive
  await Hive.initFlutter(appDir.path);

  // Open box
  await Hive.openBox('notesBox');

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
