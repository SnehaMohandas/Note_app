// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class Task {
//   final String name;
//   final DateTime dueDate;

//   Task({required this.name, required this.dueDate});
// }

// final List<Task> tasks = [
//   Task(name: 'Task 1', dueDate: DateTime.now().add(Duration(days: 3))),
//   Task(name: 'Task 2', dueDate: DateTime.now().add(Duration(days: 5))),
//   // Add more tasks as needed
// ];
// Future<void> _initAudioRecorder() async {
//   try {
//     await _audioRecorder.openRecorder();
//   } catch (e) {
//     print('Error initializing audio recorder: $e');
//   }
// }

// FlutterTts flutterTts = FlutterTts();
// FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();

// class AddTaskScreen extends StatefulWidget {
//   @override
//   _AddTaskScreenState createState() => _AddTaskScreenState();
// }

// class _AddTaskScreenState extends State<AddTaskScreen> {
//   TextEditingController _taskNameController = TextEditingController();
//   bool _isRecording = false;
//   @override
//   void initState() {
//     super.initState();
//     _initAudioRecorder();
//     //_audioRecorder.openRecorder();
//   }

//   @override
//   void dispose() {
//     _audioRecorder.closeRecorder();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add New Task'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _taskNameController,
//               decoration: InputDecoration(labelText: 'Task Name'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Start/Stop recording
//                 if (_isRecording) {
//                   print("object");
//                   _stopRecording();
//                 } else {
//                   _startRecording();
//                 }
//               },
//               child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Save the task with both text and audio
//                 _saveTask();
//               },
//               child: Text('Save Task'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _startRecording() async {
//     try {
//       await _audioRecorder.startRecorder(
//         toFile: 'path_to_save_recording.wav',
//         codec: Codec.pcm16WAV,
//       );
//       setState(() {
//         _isRecording = true;
//       });
//     } catch (err) {
//       print('Error starting recording: $err');
//     }
//   }

//   void _stopRecording() async {
//     try {
//       await _audioRecorder.stopRecorder();
//       setState(() {
//         _isRecording = false;
//       });
//     } catch (err) {
//       print('Error stopping recording: $err');
//     }
//   }

//   void _saveTask() {
//     String taskName = _taskNameController.text.trim();
//     if (taskName.isNotEmpty) {
//       // Save the task with both text and audio
//       Task newTask = Task(name: taskName, dueDate: DateTime.now());
//       tasks.add(newTask);
//       Navigator.pop(context); // Close the AddTaskScreen
//     } else {
//       // Show an error message, task name is required
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Task name is required'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }
// }
//=======================

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:notes_app/provider/speech_text_provider.dart';

//===============
class AddNoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Input Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<SpeechProvider>(
              builder: (context, speechProvider, child) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: speechProvider.titleController,
                        onChanged: (value) {
                          speechProvider.title = value;
                        },
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
                      },
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16.0),
            Consumer<SpeechProvider>(
              builder: (context, speechProvider, child) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: speechProvider.descriptionController,
                        onChanged: (value) {
                          speechProvider.description = value;
                        },
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
                      },
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
                onPressed: () {
                  Provider.of<SpeechProvider>(context, listen: false)
                      .saveToHive(context);
                },
                child: Text("Add"))
          ],
        ),
      ),
    );
  }
}
