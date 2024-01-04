import 'package:hive_flutter/adapters.dart';
import 'package:notes_app/models/note_model.dart';

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    return Note(
      id: reader.read(),
      title: reader.read(),
      description: reader.read(),
      datetime: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.write(obj.id);
    writer.write(obj.title);
    writer.write(obj.description);
    writer.write(obj.datetime);
  }
}
