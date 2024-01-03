// // note.dart
// import 'package:hive/hive.dart';

// class Note {
//   String id;
//   String title;
//   String description;

//   Note({required this.id,  required this.title, required this.description});
// }

// class NoteAdapter extends TypeAdapter<Note> {
//   @override
//   final int typeId = 0; // Unique identifier for your model class

//   @override
//   Note read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Note(
//       id: fields[0] as String,
//       title: fields[0] as String,
//       description: fields[1] as String,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, Note obj) {
//     writer
//       ..writeByte(2)
//       ..writeByte(0)
//       ..write(obj.title)

//       ..writeByte(1)
//       ..write(obj.description);
//   }
// }
//================
// note.dart
// import 'package:hive/hive.dart';

// class Note {
//   String id;
//   String title;
//   String description;
//   DateTime datetime; // New field

//   Note({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.datetime,
//   });
// }

// class NoteAdapter extends TypeAdapter<Note> {
//   @override
//   final int typeId = 0; // Unique identifier for your model class

//   @override
//   Note read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Note(
//       id: fields[0] as String,
//       title: fields[1] as String,
//       description: fields[2] as String,
//       datetime: fields[3] as DateTime, // Added datetime field
//     );
//   }

//   @override
//   void write(BinaryWriter writer, Note obj) {
//     writer
//       ..writeByte(4) // Updated the number of fields
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.title)
//       ..writeByte(2)
//       ..write(obj.description)
//       ..writeByte(3)
//       ..write(obj.datetime); // Added writing datetime field
//   }
// }

//===================
import 'package:hive_flutter/hive_flutter.dart';

class Note {
  String id;
  String title;
  String description;
  DateTime datetime; // New field

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.datetime,
  });
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    return Note(
      id: reader.read(),
      title: reader.read(),
      description: reader.read(),
      datetime: reader.read(), // Assuming Note has a datetime field
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.write(obj.id);
    writer.write(obj.title);
    writer.write(obj.description);
    writer.write(obj.datetime); // Writing datetime field
  }
}
