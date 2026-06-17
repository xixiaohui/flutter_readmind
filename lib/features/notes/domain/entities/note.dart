// note.dart
// 笔记实体

/// 笔记实体
class Note {
  final int id;
  final int highlightId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.highlightId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 创建新笔记
  factory Note.create({
    required int highlightId,
    required String content,
  }) {
    final now = DateTime.now();
    return Note(
      id: 0,
      highlightId: highlightId,
      content: content,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 复制并更新
  Note copyWith({
    int? id,
    int? highlightId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      highlightId: highlightId ?? this.highlightId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
