import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/note_g.dart';
import 'package:notes_app/provider/notes_provider.dart';
import 'package:notes_app/provider/speech_text_provider.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatelessWidget {
  final Note editingNote;

  // TextEditingController for title and description
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  EditScreen({required this.editingNote})
      : titleController = TextEditingController(text: editingNote.title),
        descriptionController =
            TextEditingController(text: editingNote.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title TextField
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                ),
                Consumer<SpeechProvider>(
                    builder: (context, speechProvider, child) {
                  return AvatarGlow(
                    animate: speechProvider.isTitle,
                    glowColor: Theme.of(context).primaryColor,
                    duration: const Duration(milliseconds: 2000),
                    repeat: true,
                    child: IconButton(
                      icon: Icon(Icons.mic),
                      onPressed: () {
                        speechProvider.startListening('title');
                      },
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: 16.0),

            // Description TextField
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                ),
                Consumer<SpeechProvider>(
                    builder: (context, speechProvider, child) {
                  return AvatarGlow(
                    animate: speechProvider.isDescription,
                    glowColor: Theme.of(context).primaryColor,
                    duration: const Duration(milliseconds: 2000),
                    repeat: true,
                    child: IconButton(
                      icon: Icon(Icons.mic),
                      onPressed: () {
                        speechProvider.startListening('description');
                      },
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: 16.0),

            // Save Button
            ElevatedButton(
              onPressed: () {
                // Create an updated note with the new values
                Note updatedNote = Note(
                    id: editingNote.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    datetime: DateTime.now());
                print(editingNote.id);

                // Call the editNote function on NotesProvider
                Provider.of<NotesProvider>(context, listen: false).updateNote(
                    editingNote.id,
                    titleController.text,
                    descriptionController.text,
                    DateTime.now());

                // Close the EditScreen
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
