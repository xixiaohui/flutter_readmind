// book_repository_impl.dart
// Book Repository 实现（data 层）

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/book_dao.dart';
import '../../domain/repositories/book_repository.dart';

/// Book Repository 实现
class BookRepositoryImpl implements BookRepository {
  final BookDao _dao;

  BookRepositoryImpl(this._dao);

  @override
  Future<List<BookData>> getAllBooks() async {
    final books = await _dao.getAllBooks();
    return books.map(_toBookData).toList();
  }

  @override
  Future<BookData?> getBookById(int id) async {
    final book = await _dao.getBookById(id);
    if (book == null) return null;
    return _toBookData(book);
  }

  @override
  Future<int> insertBook(BookData book) async {
    return _dao.insertBook(BooksCompanion.insert(
      uuid: book.uuid,
      title: book.title,
      author: Value(book.author),
      language: Value(book.language),
      filePath: book.filePath,
      fileType: book.fileType,
    ));
  }

  @override
  Future<int> deleteBook(int id) async {
    return _dao.deleteBook(id);
  }

  @override
  Stream<List<BookData>> watchAllBooks() {
    return _dao.watchAllBooks().map(
          (books) => books.map(_toBookData).toList(),
        );
  }

  @override
  Future<List<BookData>> getBooksByType(String fileType) async {
    final books = await _dao.getBooksByType(fileType);
    return books.map(_toBookData).toList();
  }

  /// 将数据库记录映射为 BookData
  BookData _toBookData(Book book) {
    return BookData(
      id: book.id,
      uuid: book.uuid,
      title: book.title,
      author: book.author,
      language: book.language,
      filePath: book.filePath,
      fileType: book.fileType,
    );
  }
}
