import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/const.dart';
import 'package:notes_app/note_g.dart';
import 'package:notes_app/provider/edit_task.dart';
import 'package:notes_app/provider/notes_provider.dart';
import 'package:notes_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/add_task.dart';
import 'package:notes_app/provider/speech_text_provider.dart';
import 'package:notes_app/textpainter.dart';
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: themeNotifier.getTheme(),
        home: HomeScreen(),
      ),
    );
  }
}
// notes_screen.dart

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notesProvider.initializeNotes();
    });

    return Consumer<NotesProvider>(builder: (context, value, child) {
      // Provider.of<NotesProvider>(context, listen: false).initializeNotes();
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddNoteScreen();
            }));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(title: Text("notes")),
        body: Column(
          children: [
            Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) {
                return
                    // Switch(
                    //   value: themeNotifier.isDarkMode,
                    //   onChanged: (value) {
                    //     themeNotifier.onThemeChanged(value, themeNotifier);
                    //   },
                    // );

                    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Light"),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: Switch(
                        key: Key(themeNotifier.isDarkMode.toString()),
                        value: themeNotifier.isDarkMode,
                        onChanged: (value) {
                          themeNotifier.onThemeChanged(value, themeNotifier);
                        },
                        trackOutlineColor:
                            MaterialStatePropertyAll(Colors.transparent),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.amber[100],
                        activeTrackColor: Color.fromARGB(144, 123, 148, 187),
                        activeColor: const Color.fromARGB(97, 0, 0, 0),
                        //inactiveThumbColor: Color.fromARGB(97, 0, 0, 0)

                        activeThumbImage:
                            AssetImage('assets/images/dark_mode.png'),
                        inactiveThumbImage: AssetImage(
                          'assets/images/light_mode.png',
                        ),
                      ),
                    ),
                    Text("Dark"),
                  ],
                );
              },
            ),
            TextField(
              onChanged: (query) {
                notesProvider.setSearchQuery(query);
              },
              decoration: InputDecoration(
                hintText: 'Search notes...',
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notesProvider.filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = notesProvider.filteredNotes[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.description),
                    leading: IconButton(
                        onPressed: () {
                          showDeleteDialogue(context, note.id);

                          // Close the EditScreen
                          // Navigator.pop(context);
                        },
                        icon: Icon(Icons.delete)),
                    trailing: Tooltip(
                      message: 'Read note number ${index + 1}',
                      // hint: 'Read note number ${index + 1}',
                      child: IconButton(
                        onPressed: () {
                          speakText(
                              'Note ${index + 1}: ${note.title}   ${note.description}');
                        },
                        icon: Icon(Icons.volume_up_outlined),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return EditScreen(editingNote: note);
                      }));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  FlutterTts flutterTts = FlutterTts();

  void speakText(String text) async {
    await flutterTts.speak(text);
  }

  void showDeleteDialogue(BuildContext context, String noteid) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Are you sure want to Delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set the background color here
              ),
              onPressed: () async {
                Provider.of<NotesProvider>(context, listen: false).deleteNote(
                  noteid,
                );
                Navigator.pop(context);
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
