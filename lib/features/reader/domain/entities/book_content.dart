// book_content.dart
// 书籍内容实体

/// 阅读模式
enum ReadingMode {
  pagination,
  scroll,
}

/// 字体家族
enum ReaderFontFamily {
  sansSerif,
  serif,
  monospace,
  wenkai,
}

/// 搜索结果匹配项
class SearchMatch {
  final int chapterIndex;
  final String chapterTitle;
  final int startOffset;
  final String contextText;

  const SearchMatch({
    required this.chapterIndex,
    required this.chapterTitle,
    required this.startOffset,
    required this.contextText,
  });
}

/// 书籍内容实体
class BookContent {
  final int bookId;
  final String title;
  final String? author;
  final String fileType;
  final String filePath;
  final List<Chapter> chapters;

  const BookContent({
    required this.bookId,
    required this.title,
    this.author,
    required this.fileType,
    required this.filePath,
    this.chapters = const [],
  });
}

/// 章节实体
class Chapter {
  final int index;
  final String title;
  final String content;

  const Chapter({
    required this.index,
    required this.title,
    required this.content,
  });
}
