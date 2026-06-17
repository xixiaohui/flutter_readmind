// reader_repository_impl.dart
// Reader Repository 实现（data 层）

import 'dart:io';
import 'dart:math';
import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/reading_progress_dao.dart';
import '../../domain/entities/book_content.dart';
import '../../domain/entities/reading_position.dart';
import '../../domain/repositories/reader_repository.dart';

/// Reader Repository 实现
class ReaderRepositoryImpl implements ReaderRepository {
  final ReadingProgressDao _progressDao;

  ReaderRepositoryImpl(this._progressDao);

  @override
  Future<BookContent> getBookContent(
      String filePath, String fileType, int bookId) async {
    final file = File(filePath);
    final fileName = filePath.split(Platform.pathSeparator).last;

    if (!await file.exists()) {
      throw FormatException('文件不存在: $filePath');
    }

    switch (fileType) {
      case 'txt':
        return _loadTxtContent(file, fileName, bookId);
      case 'epub':
        return _loadEpubContent(file, fileName, bookId);
      case 'pdf':
        return _loadPdfContent(file, fileName, bookId);
      default:
        throw FormatException('不支持的文件类型: $fileType');
    }
  }

  /// 加载 TXT 内容
  Future<BookContent> _loadTxtContent(
      File file, String fileName, int bookId) async {
    final content = await file.readAsString();
    final chapters = _splitIntoChapters(content);
    final title = fileName.replaceAll('.txt', '').replaceAll('_', ' ');

    return BookContent(
      bookId: bookId,
      title: title,
      fileType: 'txt',
      filePath: file.path,
      chapters: chapters,
    );
  }

  /// 加载 EPUB 内容
  Future<BookContent> _loadEpubContent(
      File file, String fileName, int bookId) async {
    final content = await file.readAsString();
    final chapters = _splitIntoChapters(content);
    final title = fileName.replaceAll('.epub', '').replaceAll('_', ' ');

    return BookContent(
      bookId: bookId,
      title: title,
      fileType: 'epub',
      filePath: file.path,
      chapters: chapters,
    );
  }

  /// 加载 PDF 内容
  Future<BookContent> _loadPdfContent(
      File file, String fileName, int bookId) async {
    final content = await file.readAsString();
    final chapters = _splitIntoChapters(content);
    final title = fileName.replaceAll('.pdf', '').replaceAll('_', ' ');

    return BookContent(
      bookId: bookId,
      title: title,
      fileType: 'pdf',
      filePath: file.path,
      chapters: chapters,
    );
  }

  /// 将内容分割为章节
  List<Chapter> _splitIntoChapters(String content) {
    final chapters = <Chapter>[];
    final trimmedContent = content.trim();

    if (trimmedContent.isEmpty) {
      chapters.add(const Chapter(index: 0, title: 'Empty', content: ''));
      return chapters;
    }

    // 按换行符分割成页面
    final lines = trimmedContent.split('\n');
    const linesPerPage = 40;
    final totalPages = max(1, (lines.length / linesPerPage).ceil());

    for (int i = 0; i < totalPages; i++) {
      final start = i * linesPerPage;
      final end = min(start + linesPerPage, lines.length);
      final pageContent = lines.sublist(start, end).join('\n');

      chapters.add(Chapter(
        index: i,
        title: 'Page ${i + 1}',
        content: pageContent,
      ));
    }

    return chapters;
  }

  @override
  Future<ReadingPosition> getReadingPosition(int bookId) async {
    final progress = await _progressDao.getProgressByBookId(bookId);
    if (progress == null) {
      return ReadingPosition.initial(bookId);
    }

    return ReadingPosition(
      bookId: bookId,
      chapterIndex: progress.chapterIndex ?? 0,
      pageNumber: progress.pageNumber ?? 0,
      scrollPosition: progress.scrollPosition ?? 0.0,
      progressPercent: progress.progressPercent ?? 0.0,
      lastReadAt: DateTime.now(),
    );
  }

  @override
  Future<void> saveReadingPosition(ReadingPosition position) async {
    final existing = await _progressDao.getProgressByBookId(position.bookId);

    if (existing != null) {
      await _progressDao.updateProgress(ReadingProgressCompanion(
        id: Value(existing.id),
        bookId: Value(position.bookId),
        chapterIndex: Value(position.chapterIndex),
        pageNumber: Value(position.pageNumber),
        scrollPosition: Value(position.scrollPosition),
        progressPercent: Value(position.progressPercent),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ));
    } else {
      await _progressDao.insertProgress(ReadingProgressCompanion.insert(
        bookId: position.bookId,
        chapterIndex: Value(position.chapterIndex),
        pageNumber: Value(position.pageNumber),
        scrollPosition: Value(position.scrollPosition),
        progressPercent: Value(position.progressPercent),
      ));
    }
  }
}
