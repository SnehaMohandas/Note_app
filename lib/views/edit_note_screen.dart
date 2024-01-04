import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/provider/notes_provider.dart';
import 'package:notes_app/provider/speech_text_provider.dart';
import 'package:notes_app/utils/color_constant.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';

class EditScreen extends StatelessWidget {
  final Note editingNote;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  EditScreen({required this.editingNote})
      : titleController = TextEditingController(text: editingNote.title),
        descriptionController =
            TextEditingController(text: editingNote.description);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final speechProvider = Provider.of<SpeechProvider>(context);

    return PopScope(
      onPopInvoked: (didPop) async {
        speechProvider.descriptionController.clear();
        speechProvider.titleController.clear();
        speechProvider.speech!.stop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Note'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: Theme.of(context).highlightColor),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Title field can't be empty";
                                } else {
                                  return null;
                                }
                              },
                              maxLength: 30,
                              controller:
                                  speechProvider.titleController.text != ""
                                      ? speechProvider.titleController
                                      : titleController,
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                contentPadding: EdgeInsets.all(8),
                                alignLabelWithHint: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          AvatarGlow(
                            animate: speechProvider.isTitle,
                            glowColor: Theme.of(context).highlightColor,
                            duration: const Duration(milliseconds: 2000),
                            repeat: true,
                            child: IconButton(
                              icon: Icon(Icons.mic),
                              onPressed: () {
                                speechProvider.startListening('title');
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //   },
                  // ),
                  SizedBox(height: 16.0),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Theme.of(context).highlightColor),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              maxLines: 8,
                              minLines: 8,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Description field can't be empty";
                                } else {
                                  return null;
                                }
                              },
                              controller:
                                  speechProvider.descriptionController.text !=
                                          ""
                                      ? speechProvider.descriptionController
                                      : descriptionController,
                              decoration: const InputDecoration(
                                  hintTextDirection: TextDirection.ltr,
                                  hintText: 'Description',
                                  border: InputBorder.none,
                                  labelText: 'Description'),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Tap here to Record'),
                              ),
                              AvatarGlow(
                                animate: speechProvider.isDescription,
                                glowColor: Theme.of(context).highlightColor,
                                duration: const Duration(milliseconds: 2000),
                                repeat: true,
                                child: IconButton(
                                  icon: const Icon(Icons.mic),
                                  onPressed: () {
                                    speechProvider
                                        .startListening('description');
                                  },
                                ),
                              ),
                            ],
                          ),
                          // }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.23),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Consumer<SpeechProvider>(
          builder: (context, speechProvider, child) {
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Semantics(
                  label: "Update your Note",
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        Note updatedNote = Note(
                            id: editingNote.id,
                            title: titleController.text,
                            description: descriptionController.text,
                            datetime: DateTime.now());
                        print(editingNote.id);

                        TextEditingController updatedTitleController =
                            speechProvider.titleController.text != ""
                                ? speechProvider.titleController
                                : titleController;
                        TextEditingController updatedDescriptionController =
                            speechProvider.descriptionController.text != ""
                                ? speechProvider.descriptionController
                                : descriptionController;

                        Provider.of<NotesProvider>(context, listen: false)
                            .updateNote(
                                editingNote.id,
                                updatedTitleController.text,
                                updatedDescriptionController.text,
                                DateTime.now());

                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      "Update  Note",
                      style: TextStyle(
                        color: ColorConstant.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
