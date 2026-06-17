// poster_repository_impl.dart
// Poster Repository 实现（data 层）

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/generated_poster_dao.dart';
import '../../domain/entities/poster.dart';
import '../../domain/repositories/poster_repository.dart';

/// Poster Repository 实现
class PosterRepositoryImpl implements PosterRepository {
  final GeneratedPosterDao _dao;

  PosterRepositoryImpl(this._dao);

  @override
  Future<int> savePoster(Poster poster) async {
    return _dao.insertPoster(GeneratedPostersCompanion.insert(
      highlightId: poster.highlightId,
      quoteText: poster.quoteText,
      bookTitle: Value(poster.bookTitle),
      author: Value(poster.author),
      templateKey: Value(poster.template.name),
      ratio: Value(poster.ratio.name),
      imagePath: Value(poster.imagePath ?? ''),
    ));
  }

  @override
  Future<List<Poster>> getAllPosters() async {
    final rows = await _dao.getAllPosters();
    return rows.map(_toPoster).toList();
  }

  @override
  Future<int> deletePoster(String id) async {
    final rows = await _dao.getAllPosters();
    for (final row in rows) {
      // Match by highlightId stored as int, compare with poster.id parsed as int
      if (row.highlightId.toString() == id ||
          row.id.toString() == id) {
        return _dao.deletePoster(row.id);
      }
    }
    // Try parsing id as int for direct deletion
    final intId = int.tryParse(id);
    if (intId != null) {
      return _dao.deletePoster(intId);
    }
    return 0;
  }

  Poster _toPoster(GeneratedPoster row) {
    return Poster(
      id: row.id.toString(),
      highlightId: row.highlightId,
      quoteText: row.quoteText,
      bookTitle: row.bookTitle,
      author: row.author,
      template: _parseTemplate(row.templateKey),
      ratio: _parseRatio(row.ratio),
      imagePath: row.imagePath,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
    );
  }

  PosterTemplate _parseTemplate(String? key) {
    switch (key) {
      case 'paper':
        return PosterTemplate.paper;
      case 'dark':
        return PosterTemplate.dark;
      case 'cover':
        return PosterTemplate.cover;
      default:
        return PosterTemplate.minimal;
    }
  }

  PosterRatio _parseRatio(String? ratio) {
    switch (ratio) {
      case 'portrait':
        return PosterRatio.portrait;
      case 'story':
        return PosterRatio.story;
      default:
        return PosterRatio.square;
    }
  }
}
