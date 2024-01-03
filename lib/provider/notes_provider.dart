// notes_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/note_g.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  void setNotes(List<Note> notes) {
    _notes = notes;
    notifyListeners();
  }

  void initializeNotes() {
    setNotes(getSavedNotes());
  }

//get notes
  List<Note> getSavedNotes() {
    final box = Hive.box<Note>('notes');
    return box.values.toList();
  }

  void editNote(Note updatedNote) {
    print(updatedNote.id);
    // Get the Hive box
    final box = Hive.box<Note>('notes');
    print("boxx===>${box.values.first.id}");
    var existingNotess = box.get(box.values.first.id);

    print(existingNotess);

    // Get the existing note from the box
    Note existingNote = box.get(updatedNote.id)!;
    print("exxx==.>${existingNote}");

    // Update the properties of the existing note
    existingNote!.title = updatedNote.title;
    existingNote.description = updatedNote.description;

    // Save the updated note back to Hive
    box.put(existingNote.id, existingNote);

    // Notify listeners about the change
    notifyListeners();
  }

//update notes
  void updateNote(
      String taskId, String newTitle, String newDescription, DateTime newTime) {
    final box = Hive.box<Note>('notes');

    Note? noteToUpdate = box.get(taskId);

    if (noteToUpdate != null) {
      noteToUpdate.title = newTitle;
      noteToUpdate.description = newDescription;
      noteToUpdate.datetime = newTime;

      box.put(taskId.toString(), noteToUpdate);

      notifyListeners();
    } else {
      print("object");
    }
  }

  void deleteNote(String taskId) {
    final box = Hive.box<Note>('notes');

    box.delete(taskId);
    notifyListeners();
  }

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Note> get filteredNotes {
    return _notes
        .where((note) =>
            note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            note.description.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }
}
