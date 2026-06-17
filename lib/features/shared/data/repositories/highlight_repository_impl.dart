// highlight_repository_impl.dart
// Highlight Repository 实现（data 层）

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/highlight_dao.dart';
import '../../domain/repositories/highlight_repository.dart';

/// Highlight Repository 实现
class HighlightRepositoryImpl implements HighlightRepository {
  final HighlightDao _dao;

  HighlightRepositoryImpl(this._dao);

  @override
  Future<List<HighlightData>> getAllHighlights() async {
    final highlights = await _dao.getAllHighlights();
    return highlights.map(_toHighlightData).toList();
  }

  @override
  Future<HighlightData?> getHighlightById(int id) async {
    final highlight = await _dao.getHighlightById(id);
    if (highlight == null) return null;
    return _toHighlightData(highlight);
  }

  @override
  Future<List<HighlightData>> getHighlightsByBookId(int bookId) async {
    final highlights = await _dao.getHighlightsByBookId(bookId);
    return highlights.map(_toHighlightData).toList();
  }

  @override
  Future<int> insertHighlight(HighlightData highlight) async {
    return _dao.insertHighlight(HighlightsCompanion.insert(
      uuid: highlight.uuid,
      bookId: highlight.bookId,
      selectedText: highlight.selectedText,
      highlightColor: Value(highlight.highlightColor),
      startOffset: highlight.startOffset,
      endOffset: highlight.endOffset,
    ));
  }

  @override
  Future<int> deleteHighlight(int id) async {
    return _dao.deleteHighlight(id);
  }

  @override
  Stream<List<HighlightData>> watchHighlightsByBookId(int bookId) {
    return _dao.watchHighlightsByBookId(bookId).map(
          (highlights) => highlights.map(_toHighlightData).toList(),
        );
  }

  /// 将数据库记录映射为 HighlightData
  HighlightData _toHighlightData(Highlight highlight) {
    return HighlightData(
      id: highlight.id,
      uuid: highlight.uuid,
      bookId: highlight.bookId,
      selectedText: highlight.selectedText,
      highlightColor: highlight.highlightColor,
      startOffset: highlight.startOffset,
      endOffset: highlight.endOffset,
    );
  }
}
