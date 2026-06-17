// book_repository.dart
// Book Repository 接口（domain 层）

/// 书籍数据模型
class BookData {
  final int id;
  final String uuid;
  final String title;
  final String? author;
  final String? language;
  final String filePath;
  final String fileType;

  const BookData({
    required this.id,
    required this.uuid,
    required this.title,
    this.author,
    this.language,
    required this.filePath,
    required this.fileType,
  });
}

/// Book Repository 抽象接口
abstract class BookRepository {
  /// 获取所有书籍
  Future<List<BookData>> getAllBooks();

  /// 根据 ID 获取书籍
  Future<BookData?> getBookById(int id);

  /// 插入书籍
  Future<int> insertBook(BookData book);

  /// 删除书籍
  Future<int> deleteBook(int id);

  /// 监听所有书籍变化
  Stream<List<BookData>> watchAllBooks();

  /// 根据文件类型获取书籍
  Future<List<BookData>> getBooksByType(String fileType);
}
