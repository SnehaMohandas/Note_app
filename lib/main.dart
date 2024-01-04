import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/models/note_model_g.dart';
import 'package:notes_app/utils/theme_const.dart';
import 'package:notes_app/views/edit_note_screen.dart';
import 'package:notes_app/provider/notes_provider.dart';
import 'package:notes_app/provider/text_to_speech_rovider.dart';
import 'package:notes_app/provider/theme_provider.dart';
import 'package:notes_app/views/home_screen.dart';
import 'package:notes_app/views/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/provider/speech_text_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');
  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeNotifier(false, darkTheme),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SpeechProvider()),
        ChangeNotifierProvider(create: (context) => NotesProvider()),
        ChangeNotifierProvider(create: (context) => TexttoSpeechProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: themeNotifier.getTheme(),
        home: SplashScreen(),
      ),
    );
  }
}
