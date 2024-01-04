import 'package:flutter/material.dart';

class TexttoSpeechProvider extends ChangeNotifier {
  int _currentlyPlayingIndex = -1;

  int get currentlyPlayingIndex => _currentlyPlayingIndex;

  void startPlaying(int index) {
    _currentlyPlayingIndex = index;
    notifyListeners();
  }

  void stopPlaying() {
    _currentlyPlayingIndex = -1;
    notifyListeners();
  }
}
