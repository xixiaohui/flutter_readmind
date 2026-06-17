// entity_test.dart
// 领域实体单元测试

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_readmind/features/import/domain/entities/import_task.dart';
import 'package:flutter_readmind/features/reader/domain/entities/reading_position.dart';
import 'package:flutter_readmind/features/highlights/domain/entities/highlight.dart';
import 'package:flutter_readmind/features/notes/domain/entities/note.dart';
import 'package:flutter_readmind/features/posters/domain/entities/poster.dart';

void main() {
  group('ImportTask', () {
    test('creates with default values', () {
      const task = ImportTask(
        id: '1',
        filePath: '/path/to/book.epub',
        fileName: 'book.epub',
        fileType: 'epub',
      );
      expect(task.status, ImportStatus.pending);
      expect(task.progress, 0.0);
      expect(task.errorMessage, isNull);
    });

    test('copyWith updates correctly', () {
      const task = ImportTask(
        id: '1',
        filePath: '/path',
        fileName: 'file',
        fileType: 'epub',
        status: ImportStatus.pending,
      );
      final updated = task.copyWith(status: ImportStatus.completed);
      expect(updated.status, ImportStatus.completed);
      expect(updated.id, '1');
    });

    test('ImportStatus enum has all values', () {
      expect(ImportStatus.values.length, 5);
      expect(ImportStatus.values, contains(ImportStatus.pending));
      expect(ImportStatus.values, contains(ImportStatus.completed));
      expect(ImportStatus.values, contains(ImportStatus.failed));
    });
  });

  group('ReadingPosition', () {
    test('initial creates with default values', () {
      final position = ReadingPosition.initial(42);
      expect(position.bookId, 42);
      expect(position.chapterIndex, 0);
      expect(position.pageNumber, 0);
      expect(position.progressPercent, 0.0);
    });

    test('copyWith updates correctly', () {
      final position = ReadingPosition.initial(42);
      final updated = position.copyWith(
        chapterIndex: 3,
        pageNumber: 15,
        progressPercent: 0.5,
      );
      expect(updated.bookId, 42);
      expect(updated.chapterIndex, 3);
      expect(updated.pageNumber, 15);
      expect(updated.progressPercent, 0.5);
    });
  });

  group('Highlight', () {
    test('create generates uuid and timestamps', () {
      final highlight = Highlight.create(
        bookId: 1,
        selectedText: 'Great quote',
        highlightColor: '#FFE28A',
        startOffset: 0,
        endOffset: 11,
      );
      expect(highlight.uuid, isNotEmpty);
      expect(highlight.selectedText, 'Great quote');
      expect(highlight.highlightColor, '#FFE28A');
      expect(highlight.bookId, 1);
    });
  });

  group('Note', () {
    test('create generates timestamps', () {
      final note = Note.create(
        highlightId: 1,
        content: 'Interesting thought',
      );
      expect(note.highlightId, 1);
      expect(note.content, 'Interesting thought');
    });

    test('copyWith updates correctly', () {
      final note = Note.create(highlightId: 1, content: 'Original');
      final updated = note.copyWith(content: 'Updated');
      expect(updated.content, 'Updated');
      expect(updated.highlightId, 1);
    });
  });

  group('Poster', () {
    test('create with defaults', () {
      final poster = Poster.create(
        highlightId: 1,
        quoteText: 'Genius is 1% inspiration',
        bookTitle: 'Great Book',
        author: 'Author Name',
      );
      expect(poster.quoteText, 'Genius is 1% inspiration');
      expect(poster.bookTitle, 'Great Book');
      expect(poster.template, PosterTemplate.minimal);
      expect(poster.ratio, PosterRatio.square);
    });

    test('PosterTemplate has 4 values', () {
      expect(PosterTemplate.values.length, 4);
    });

    test('PosterTemplate display names', () {
      expect(PosterTemplate.minimal.displayName, 'Minimal');
      expect(PosterTemplate.dark.displayName, 'Dark');
      expect(PosterTemplate.paper.displayName, 'Paper');
      expect(PosterTemplate.cover.displayName, 'Cover');
    });

    test('PosterRatio has 3 values', () {
      expect(PosterRatio.values.length, 3);
    });
  });
}
