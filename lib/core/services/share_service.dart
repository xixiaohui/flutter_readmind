// share_service.dart
// 分享和导出服务

import 'package:share_plus/share_plus.dart';

/// 分享服务抽象接口
abstract class ShareService {
  /// 分享文本
  Future<void> shareText(String text, {String? subject});

  /// 导出高亮为文本
  String exportHighlightsAsText(Map<String, List<String>> highlightsByBook);

  /// 导出笔记为文本
  String exportNotesAsText(Map<String, List<String>> notesByHighlight);
}

/// 分享服务实现
class ShareServiceImpl implements ShareService {
  @override
  Future<void> shareText(String text, {String? subject}) async {
    await Share.share(text, subject: subject ?? 'ReadMind');
  }

  @override
  String exportHighlightsAsText(Map<String, List<String>> highlightsByBook) {
    final buffer = StringBuffer();
    buffer.writeln('=== ReadMind - Highlights ===');
    buffer.writeln();
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln();

    for (final entry in highlightsByBook.entries) {
      buffer.writeln('--- ${entry.key} ---');
      buffer.writeln();
      for (final highlight in entry.value) {
        buffer.writeln('"$highlight"');
        buffer.writeln();
      }
    }

    return buffer.toString();
  }

  @override
  String exportNotesAsText(Map<String, List<String>> notesByHighlight) {
    final buffer = StringBuffer();
    buffer.writeln('=== ReadMind - Notes ===');
    buffer.writeln();
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln();

    int index = 1;
    for (final entry in notesByHighlight.entries) {
      buffer.writeln('Quote: "${entry.key}"');
      buffer.writeln();
      for (final note in entry.value) {
        buffer.writeln('Note $index: $note');
        buffer.writeln();
        index++;
      }
      buffer.writeln('---');
      buffer.writeln();
    }

    return buffer.toString();
  }
}

/// 创建分享文本
String createShareText({
  required String quoteText,
  String? bookTitle,
  String? author,
}) {
  final buffer = StringBuffer();
  buffer.writeln('"$quoteText"');

  if (bookTitle != null) {
    buffer.writeln();
    buffer.writeln('— $bookTitle');
  }

  if (author != null) {
    buffer.writeln(author);
  }

  buffer.writeln();
  buffer.writeln('Shared via ReadMind');

  return buffer.toString();
}
