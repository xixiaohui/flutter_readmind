// backup_service.dart
// JSON 备份导出/导入服务

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../features/shared/domain/repositories/book_repository.dart';
import '../../features/shared/domain/repositories/highlight_repository.dart';
import '../../features/shared/domain/repositories/note_repository.dart';

/// 备份数据模型
class BackupData {
  final String version;
  final String exportDate;
  final List<Map<String, dynamic>> books;
  final List<Map<String, dynamic>> highlights;
  final List<Map<String, dynamic>> notes;

  const BackupData({
    required this.version,
    required this.exportDate,
    required this.books,
    required this.highlights,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'exportDate': exportDate,
        'books': books,
        'highlights': highlights,
        'notes': notes,
      };
}

/// 备份服务
class BackupService {
  /// 导出备份 JSON
  Future<String> exportToJson(
    BookRepository bookRepo,
    HighlightRepository highlightRepo,
    NoteRepository noteRepo,
  ) async {
    final books = await bookRepo.getAllBooks();
    final highlights = await highlightRepo.getAllHighlights();
    final notes = await noteRepo.getAllNotes();

    final backup = BackupData(
      version: '1.0.0',
      exportDate: DateTime.now().toIso8601String(),
      books: books
          .map((b) => {
                'title': b.title,
                'author': b.author,
                'fileType': b.fileType,
                'filePath': b.filePath,
                'language': b.language,
              })
          .toList(),
      highlights: highlights
          .map((h) => {
                'selectedText': h.selectedText,
                'highlightColor': h.highlightColor,
                'bookId': h.bookId,
                'startOffset': h.startOffset,
                'endOffset': h.endOffset,
              })
          .toList(),
      notes: notes
          .map((n) => {
                'content': n.content,
                'highlightId': n.highlightId,
              })
          .toList(),
    );

    return const JsonEncoder.withIndent('  ').convert(backup.toJson());
  }

  /// 保存备份到文件
  Future<String> saveToFile(String jsonContent) async {
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${dir.path}/backups');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final fileName =
        'readmeet_backup_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File('${backupDir.path}/$fileName');
    await file.writeAsString(jsonContent);
    return file.path;
  }

  /// 从文件恢复备份
  Future<void> restoreFromFile(
    String filePath,
    BookRepository bookRepo,
  ) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FormatException('备份文件不存在: $filePath');
    }

    final content = await file.readAsString();
    final data = json.decode(content) as Map<String, dynamic>;

    // 恢复书籍
    final books = data['books'] as List<dynamic>? ?? [];
    for (final book in books) {
      final b = book as Map<String, dynamic>;
      await bookRepo.insertBook(BookData(
        id: 0,
        uuid: DateTime.now().millisecondsSinceEpoch.toString(),
        title: b['title'] as String? ?? '',
        author: b['author'] as String?,
        language: b['language'] as String?,
        filePath: b['filePath'] as String? ?? '',
        fileType: b['fileType'] as String? ?? '',
      ));
    }
  }

  /// 获取所有备份文件
  Future<List<FileSystemEntity>> getBackupFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${dir.path}/backups');
    if (!await backupDir.exists()) return [];

    return backupDir
        .listSync()
        .where((f) => f.path.endsWith('.json'))
        .toList()
      ..sort((a, b) => b.path.compareTo(a.path));
  }
}
