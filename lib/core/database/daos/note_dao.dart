// note_dao.dart
// Note 数据访问对象

import '../app_database.dart';

/// Note DAO (数据访问对象)
class NoteDao {
  final AppDatabase db;

  NoteDao(this.db);

  /// 获取所有笔记
  Future<List<Note>> getAllNotes() => db.select(db.notes).get();

  /// 根据 ID 获取笔记
  Future<Note?> getNoteById(int id) async {
    final query = db.select(db.notes)
      ..where((t) => t.id.equals(id));
    return query.getSingleOrNull();
  }

  /// 根据高亮 ID 获取笔记
  Future<Note?> getNoteByHighlightId(int highlightId) async {
    final query = db.select(db.notes)
      ..where((t) => t.highlightId.equals(highlightId));
    return query.getSingleOrNull();
  }

  /// 插入笔记
  Future<int> insertNote(NotesCompanion note) =>
      db.into(db.notes).insert(note);

  /// 更新笔记
  Future<bool> updateNote(NotesCompanion note) =>
      db.update(db.notes).replace(note);

  /// 删除笔记
  Future<int> deleteNote(int id) =>
      (db.delete(db.notes)..where((t) => t.id.equals(id))).go();

  /// 删除高亮的所有笔记
  Future<int> deleteNotesByHighlightId(int highlightId) =>
      (db.delete(db.notes)
            ..where((t) => t.highlightId.equals(highlightId)))
          .go();
}
