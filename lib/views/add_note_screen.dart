import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/utils/color_constant.dart';
import 'package:provider/provider.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:notes_app/provider/speech_text_provider.dart';

class AddNoteScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final speechProvider = Provider.of<SpeechProvider>(context);

    return PopScope(
      onPopInvoked: (didPop) {
        speechProvider.descriptionController.clear();
        speechProvider.titleController.clear();
        speechProvider.title = "";
        speechProvider.description = "";
        speechProvider.speech!.stop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Notes'),
          centerTitle: true,
        ),
        bottomSheet: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Semantics(
              label: "Add your note",
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    Provider.of<SpeechProvider>(context, listen: false)
                        .saveToHive(context);
                  }
                },
                child: Text(
                  "Add Note",
                  style: const TextStyle(
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
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Consumer<SpeechProvider>(
                    builder: (context, speechProvider, child) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Theme.of(context).highlightColor),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                  textCapitalization: TextCapitalization.words,
                                  controller: speechProvider.titleController,
                                  onChanged: (value) {
                                    speechProvider.title = value;
                                  },
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    hintText: 'Title',
                                    alignLabelWithHint: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Consumer<SpeechProvider>(
                                builder: (context, speechProvider, child) {
                                  return AvatarGlow(
                                    animate: speechProvider.isTitle,
                                    glowColor: Theme.of(context).highlightColor,
                                    duration:
                                        const Duration(milliseconds: 2000),
                                    repeat: true,
                                    child: IconButton(
                                      icon: const Icon(Icons.mic),
                                      onPressed: () {
                                        speechProvider.startListening('title');
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.0),
                  Consumer<SpeechProvider>(
                    builder: (context, speechProvider, child) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).highlightColor),
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
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Description field can't be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  textCapitalization: TextCapitalization.words,
                                  controller:
                                      speechProvider.descriptionController,
                                  onChanged: (value) {
                                    speechProvider.description = value;
                                  },
                                  maxLines: 8,
                                  minLines: 8,
                                  decoration: const InputDecoration(
                                    hintTextDirection: TextDirection.ltr,
                                    hintText: 'Description',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Consumer<SpeechProvider>(
                                builder: (context, speechProvider, child) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Tap here to record'),
                                      ),
                                      AvatarGlow(
                                        animate: speechProvider.isDescription,
                                        glowColor:
                                            Theme.of(context).highlightColor,
                                        duration:
                                            const Duration(milliseconds: 2000),
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
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.23),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
