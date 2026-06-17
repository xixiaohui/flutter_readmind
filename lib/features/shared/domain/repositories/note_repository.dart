// note_repository.dart
// Note Repository 接口（domain 层）

/// 笔记数据模型
class NoteData {
  final int id;
  final int highlightId;
  final String content;

  const NoteData({
    required this.id,
    required this.highlightId,
    required this.content,
  });
}

/// Note Repository 抽象接口
abstract class NoteRepository {
  /// 获取所有笔记
  Future<List<NoteData>> getAllNotes();

  /// 根据 ID 获取笔记
  Future<NoteData?> getNoteById(int id);

  /// 根据高亮 ID 获取笔记
  Future<NoteData?> getNoteByHighlightId(int highlightId);

  /// 插入笔记
  Future<int> insertNote(NoteData note);

  /// 更新笔记
  Future<bool> updateNote(NoteData note);

  /// 删除笔记
  Future<int> deleteNote(int id);
}
