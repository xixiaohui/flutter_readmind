// pdf_parser.dart
// PDF 文件解析器

import 'dart:io';
import 'dart:math';

import '../../domain/repositories/import_repository.dart';

/// PDF 解析器
class PdfParser {
  /// 解析 PDF 文件
  Future<BookMetadata> parse(String filePath) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw FormatException('文件不存在: $filePath');
    }

    // 检查文件是否为有效的 PDF（检查 %PDF 文件头）
    final bytes = await file.readAsBytes();
    if (bytes.length < 5) {
      throw FormatException('文件太小，不是有效的 PDF');
    }

    // PDF 文件头以 %PDF 开头
    final header = String.fromCharCodes(bytes.take(5));
    if (!header.startsWith('%PDF')) {
      throw FormatException('无效的 PDF 文件');
    }

    final fileStat = await file.stat();
    final fileName = filePath.split(Platform.pathSeparator).last;
    final title = fileName.replaceAll('.pdf', '').replaceAll('_', ' ');

    return BookMetadata(
      title: title,
      author: null,
      description: null,
      language: null,
      publisher: null,
      isbn: null,
      coverPath: null,
      totalPages: max(1, fileStat.size ~/ 100000),
      fileSize: fileStat.size,
    );
  }

  /// 检测是否为 PDF 文件
  static bool isPdfFile(String filePath) {
    return filePath.toLowerCase().endsWith('.pdf');
  }
}
