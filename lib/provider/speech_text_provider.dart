import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/provider/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechProvider with ChangeNotifier {
  stt.SpeechToText? speech;
  bool _isListening = false;
  bool _isTitle = false;

  bool _isDescription = false;

  String _title = '';
  String _description = '';
  double _confidence = 1.0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  SpeechProvider() {
    speech = stt.SpeechToText();
    //_initialize();
  }

  bool get isListening => _isListening;
  String get title => _title;
  String get description => _description;
  bool get isTitle => _isTitle;
  bool get isDescription => _isDescription;

  TextEditingController get titleController => _titleController;
  TextEditingController get descriptionController => _descriptionController;
  double get confidence => _confidence;

  set title(String value) {
    _title = value;
    notifyListeners();
  }

  set description(String value) {
    _description = value;
    notifyListeners();
  }

  Future<void> startListening(String field) async {
    if (!_isListening) {
      bool available = await speech!.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'));

      if (available) {
        _isListening = true;
        if (field == "title") {
          _isDescription = false;
          _isTitle = true;
        } else {
          _isTitle = false;
          _isDescription = true;
        }
        notifyListeners();

        speech!.listen(
          onResult: (val) {
            if (val.recognizedWords.isNotEmpty) {
              if (field == 'title') {
                title = val.recognizedWords;
                titleController.text = title;
              } else if (field == 'description') {
                description = val.recognizedWords;
                descriptionController.text = description;
              }
            }
          },
        );
      }
      _timeoutTimer = Timer(Duration(seconds: 5), () {
        stopListening();
      });
    } else {
      _isListening = false;
      _isDescription = false;

      _isTitle = false;

      notifyListeners();
      speech!.stop();
    }
  }

  Timer? _timeoutTimer;
  void stopListening() {
    _isListening = false;
    _isDescription = false;
    _isTitle = false;
    notifyListeners();
    speech!.stop();

    // timeout timer if it's active
    if (_timeoutTimer != null && _timeoutTimer!.isActive) {
      _timeoutTimer!.cancel();
    }
  }

  List<Note> getSavedNotes() {
    final box = Hive.box<Note>('notes');
    return box.values.toList();
  }

//add notes
  void saveToHive(BuildContext context) {
    final box = Hive.box<Note>('notes');
    final noteId = DateTime.now().millisecondsSinceEpoch.toString();

    final note = Note(
        id: noteId,
        title: titleController.text,
        description: descriptionController.text,
        datetime: DateTime.now());
    box.put(noteId, note);

    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    notesProvider.setNotes(getSavedNotes());
    description = "";
    title = "";
    titleController.clear();
    descriptionController.clear();
    Navigator.pop(context);
  }
}
