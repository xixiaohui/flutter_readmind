// txt_parser.dart
// TXT 文本文件解析器

import 'dart:io';
import 'dart:math';

import '../../domain/repositories/import_repository.dart';

/// TXT 解析器
class TxtParser {
  /// 解析 TXT 文件
  Future<BookMetadata> parse(String filePath) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw FormatException('文件不存在: $filePath');
    }

    final fileStat = await file.stat();
    final fileName = filePath.split(Platform.pathSeparator).last;

    // 读取文件内容
    final bytes = await file.readAsBytes();
    final content = _decodeContent(bytes);

    // 标题使用文件名（中文小说第一行通常是"第X回"等章回名，不是书名）
    final title = fileName
        .replaceAll('.txt', '')
        .replaceAll('.TXT', '')
        .replaceAll('_', ' ')
        .trim();

    // 估算页数
    final lineCount = content.split('\n').length;
    const linesPerPage = 40;
    final totalPages = max(1, lineCount ~/ linesPerPage);

    return BookMetadata(
      title: title,
      author: null,
      description: null,
      language: null,
      publisher: null,
      isbn: null,
      coverPath: null,
      totalPages: totalPages,
      fileSize: fileStat.size,
    );
  }

  /// 解码文件内容
  String _decodeContent(List<int> bytes) {
    // 尝试 UTF-8 解码
    try {
      return SystemEncoding().decode(bytes);
    } catch (_) {
      // 降级为 Latin-1（不会失败）
      return String.fromCharCodes(bytes);
    }
  }

  /// 检测是否为 TXT 文件
  static bool isTxtFile(String filePath) {
    return filePath.toLowerCase().endsWith('.txt');
  }
}
