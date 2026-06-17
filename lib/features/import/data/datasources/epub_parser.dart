// epub_parser.dart
// EPUB 文件解析器

import 'dart:io';
import 'dart:math';

import '../../domain/repositories/import_repository.dart';

/// EPUB 解析器
class EpubParser {
  /// 解析 EPUB 文件
  Future<BookMetadata> parse(String filePath) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw FormatException('文件不存在: $filePath');
    }

    // EPUB 本质是 ZIP 文件，检查文件头
    final bytes = await file.readAsBytes();
    if (bytes.length < 4) {
      throw FormatException('文件太小，不是有效的 EPUB');
    }

    // ZIP 文件以 PK 开头 (0x50 0x4B)
    if (bytes[0] != 0x50 || bytes[1] != 0x4B) {
      throw FormatException('无效的 EPUB 文件');
    }

    final fileStat = await file.stat();
    final fileName = filePath.split(Platform.pathSeparator).last;
    final title = fileName.replaceAll('.epub', '').replaceAll('_', ' ');

    return BookMetadata(
      title: title,
      author: null,
      description: null,
      language: 'en',
      publisher: null,
      isbn: null,
      coverPath: null,
      totalPages: max(1, fileStat.size ~/ 4000),
      fileSize: fileStat.size,
    );
  }

  /// 检测是否为 EPUB 文件
  static bool isEpubFile(String filePath) {
    return filePath.toLowerCase().endsWith('.epub');
  }
}
