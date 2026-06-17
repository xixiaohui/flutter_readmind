// note_repository_impl.dart
// Note Repository 实现（data 层）

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/note_dao.dart';
import '../../domain/repositories/note_repository.dart';

/// Note Repository 实现
class NoteRepositoryImpl implements NoteRepository {
  final NoteDao _dao;

  NoteRepositoryImpl(this._dao);

  @override
  Future<List<NoteData>> getAllNotes() async {
    final notes = await _dao.getAllNotes();
    return notes.map(_toNoteData).toList();
  }

  @override
  Future<NoteData?> getNoteById(int id) async {
    final note = await _dao.getNoteById(id);
    if (note == null) return null;
    return _toNoteData(note);
  }

  @override
  Future<NoteData?> getNoteByHighlightId(int highlightId) async {
    final note = await _dao.getNoteByHighlightId(highlightId);
    if (note == null) return null;
    return _toNoteData(note);
  }

  @override
  Future<int> insertNote(NoteData note) async {
    return _dao.insertNote(NotesCompanion.insert(
      highlightId: note.highlightId,
      content: note.content,
    ));
  }

  @override
  Future<bool> updateNote(NoteData note) async {
    return _dao.updateNote(NotesCompanion(
      id: Value(note.id),
      highlightId: Value(note.highlightId),
      content: Value(note.content),
    ));
  }

  @override
  Future<int> deleteNote(int id) async {
    return _dao.deleteNote(id);
  }

  /// 将数据库记录映射为 NoteData
  NoteData _toNoteData(Note note) {
    return NoteData(
      id: note.id,
      highlightId: note.highlightId,
      content: note.content,
    );
  }
}
