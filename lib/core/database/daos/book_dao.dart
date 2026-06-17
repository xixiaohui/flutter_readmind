// book_dao.dart
// Book 数据访问对象

import '../app_database.dart';

/// Book DAO (数据访问对象)
class BookDao {
  final AppDatabase db;

  BookDao(this.db);

  /// 获取所有书籍
  Future<List<Book>> getAllBooks() => db.select(db.books).get();

  /// 根据 ID 获取书籍
  Future<Book?> getBookById(int id) async {
    final query = db.select(db.books)..where((t) => t.id.equals(id));
    return query.getSingleOrNull();
  }

  /// 根据 UUID 获取书籍
  Future<Book?> getBookByUuid(String uuid) async {
    final query = db.select(db.books)..where((t) => t.uuid.equals(uuid));
    return query.getSingleOrNull();
  }

  /// 插入书籍
  Future<int> insertBook(BooksCompanion book) =>
      db.into(db.books).insert(book);

  /// 更新书籍
  Future<bool> updateBook(BooksCompanion book) =>
      db.update(db.books).replace(book);

  /// 删除书籍
  Future<int> deleteBook(int id) =>
      (db.delete(db.books)..where((t) => t.id.equals(id))).go();

  /// 监听所有书籍变化
  Stream<List<Book>> watchAllBooks() => db.select(db.books).watch();

  /// 根据文件类型获取书籍
  Future<List<Book>> getBooksByType(String fileType) async {
    final query = db.select(db.books)
      ..where((t) => t.fileType.equals(fileType));
    return query.get();
  }
}
