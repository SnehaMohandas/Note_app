import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/provider/notes_provider.dart';
import 'package:notes_app/provider/text_to_speech_rovider.dart';
import 'package:notes_app/provider/theme_provider.dart';
import 'package:notes_app/utils/color_constant.dart';
import 'package:notes_app/views/add_note_screen.dart';
import 'package:notes_app/views/edit_note_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notesProvider.initializeNotes();
    });

    return Consumer<NotesProvider>(builder: (context, value, child) {
      // Provider.of<NotesProvider>(context, listen: false).initializeNotes();
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text('Are you sure to exit Notes?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'No',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: ColorConstant.white,
                        ),
                      ))
                ],
              );
            },
          );
        },
        child: Scaffold(
          floatingActionButton: Semantics(
            label: "Add Notes",
            child: FloatingActionButton.extended(
              backgroundColor: Theme.of(context).primaryColor,
              label: const Text(
                "Add Note",
                style: TextStyle(fontSize: 15, color: ColorConstant.white),
              ),
              isExtended: true,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddNoteScreen();
                }));
              },
              // child: Text("Add Notes"),
            ),
          ),
          appBar: AppBar(
            title: const Text(
              "NOTES",
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Consumer<ThemeNotifier>(
                  builder: (context, themeNotifier, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Change your theme here",
                        ),
                        Semantics(
                          label: "Chnge your app theme",
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Switch(
                              key: Key(themeNotifier.isDarkMode.toString()),
                              value: themeNotifier.isDarkMode,
                              onChanged: (value) {
                                themeNotifier.onThemeChanged(
                                    value, themeNotifier);
                              },
                              trackOutlineColor: const MaterialStatePropertyAll(
                                  Colors.transparent),
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.amber[100],
                              activeTrackColor:
                                  const Color.fromARGB(144, 123, 148, 187),
                              activeColor: const Color.fromARGB(97, 0, 0, 0),
                              activeThumbImage: const AssetImage(
                                  'assets/images/dark_mode.png'),
                              inactiveThumbImage: const AssetImage(
                                'assets/images/light_mode.png',
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Container(
                  height: 50,
                  child: TextFormField(
                    onChanged: (query) {
                      notesProvider.setSearchQuery(query);
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      hintStyle: const TextStyle(fontSize: 13),
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Theme.of(context).cardColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Theme.of(context).highlightColor)),
                      hintText: 'Search notes...',
                    ),
                  ),
                ),
                notesProvider.filteredNotes.length == 0
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.height * 0.2,
                              child: Lottie.asset(
                                  "assets/animations/no_notes.json",
                                  fit: BoxFit.cover),
                            ),
                            Container(
                              child: const Center(
                                child: Text(
                                  "NO NOTES FOUND",
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.only(bottom: 45, top: 12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  crossAxisCount: 2),
                          itemCount: notesProvider.filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = notesProvider.filteredNotes[index];
                            final texttoSpeechProvider =
                                Provider.of<TexttoSpeechProvider>(context);

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return EditScreen(editingNote: note);
                                }));
                              },
                              child: Card(
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: Theme.of(context).cardColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat('MM dd yyyy')
                                                .format(note.datetime)
                                                .toString(),
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 127, 145, 127)),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.024,
                                          ),
                                          Text(
                                            note.title,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          Text(
                                            note.description,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Tooltip(
                                              message:
                                                  'Read note number ${index + 1}',
                                              child: Consumer<
                                                  TexttoSpeechProvider>(
                                                builder:
                                                    (context, value, child) {
                                                  return IconButton(
                                                    onPressed: () async {
                                                      texttoSpeechProvider
                                                          .startPlaying(index);

                                                      speakText(
                                                          'Note ${index + 1}: ${note.title}   ${note.description}',
                                                          context);

                                                      print(texttoSpeechProvider
                                                          .currentlyPlayingIndex);
                                                      print(index);
                                                    },
                                                    icon: texttoSpeechProvider
                                                                .currentlyPlayingIndex ==
                                                            index
                                                        ? const Icon(
                                                            Icons
                                                                .volume_up_outlined,
                                                            size: 22,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .volume_off_outlined,
                                                            size: 22,
                                                          ),
                                                  );
                                                },
                                              )),
                                          GestureDetector(
                                            onTap: () {
                                              showDeleteDialogue(
                                                  context, note.id);
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: Color.fromARGB(
                                                  255, 179, 47, 38),
                                              size: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }

  FlutterTts flutterTts = FlutterTts();

  void speakText(String text, BuildContext context) async {
    await flutterTts.speak(text);

    flutterTts.setCompletionHandler(() {
      Provider.of<TexttoSpeechProvider>(context, listen: false).stopPlaying();
    });
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
              child: Text(
                'No',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
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
