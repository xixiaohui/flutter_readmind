// reader_repository.dart
// Reader Repository 接口（domain 层）

import '../entities/book_content.dart';
import '../entities/reading_position.dart';

/// Reader Repository 抽象接口
abstract class ReaderRepository {
  /// 获取书籍内容
  Future<BookContent> getBookContent(String filePath, String fileType, int bookId);

  /// 获取阅读位置
  Future<ReadingPosition> getReadingPosition(int bookId);

  /// 保存阅读位置
  Future<void> saveReadingPosition(ReadingPosition position);
}
