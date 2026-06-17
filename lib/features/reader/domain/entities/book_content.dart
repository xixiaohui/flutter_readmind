// book_content.dart
// 书籍内容实体

/// 阅读模式
enum ReadingMode {
  pagination,
  scroll,
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
