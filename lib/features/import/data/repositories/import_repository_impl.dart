// import_repository_impl.dart
// Import Repository 实现（data 层）

import 'dart:io';
import 'dart:math';
import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/book_dao.dart';
import '../../domain/repositories/import_repository.dart';
import '../datasources/epub_parser.dart';
import '../datasources/txt_parser.dart';
import '../datasources/pdf_parser.dart';

/// Import Repository 实现
class ImportRepositoryImpl implements ImportRepository {
  final BookDao _bookDao;

  final EpubParser _epubParser;
  final TxtParser _txtParser;
  final PdfParser _pdfParser;

  ImportRepositoryImpl(
    this._bookDao, {
    EpubParser? epubParser,
    TxtParser? txtParser,
    PdfParser? pdfParser,
  })  : _epubParser = epubParser ?? EpubParser(),
        _txtParser = txtParser ?? TxtParser(),
        _pdfParser = pdfParser ?? PdfParser();

  @override
  Future<ImportResult> importFile(String filePath) async {
    try {
      final fileType = detectFileType(filePath);
      BookMetadata metadata;

      switch (fileType) {
        case 'epub':
          metadata = await parseEpub(filePath);
          break;
        case 'txt':
          metadata = await parseTxt(filePath);
          break;
        case 'pdf':
          metadata = await parsePdf(filePath);
          break;
        default:
          throw FormatException('不支持的文件类型: $fileType');
      }

      // 保存到数据库
      await _bookDao.insertBook(BooksCompanion.insert(
        uuid: _generateUuid(),
        title: metadata.title,
        author: Value(metadata.author),
        description: Value(metadata.description),
        language: Value(metadata.language),
        publisher: Value(metadata.publisher),
        isbn: Value(metadata.isbn),
        filePath: filePath,
        fileType: fileType,
        fileSize: Value(metadata.fileSize),
        totalPages: Value(metadata.totalPages),
        coverPath: Value(metadata.coverPath),
      ));

      final fileName = filePath.split(Platform.pathSeparator).last;

      return ImportResult(
        filePath: filePath,
        fileName: fileName,
        fileType: fileType,
        metadata: metadata,
      );
    } catch (e) {
      final fileName = filePath.split(Platform.pathSeparator).last;
      return ImportResult.failure(
        filePath: filePath,
        fileName: fileName,
        fileType: detectFileType(filePath),
        errorMessage: e.toString(),
      );
    }
  }

  @override
  Future<BookMetadata> parseEpub(String filePath) async {
    return _epubParser.parse(filePath);
  }

  @override
  Future<BookMetadata> parseTxt(String filePath) async {
    return _txtParser.parse(filePath);
  }

  @override
  Future<BookMetadata> parsePdf(String filePath) async {
    return _pdfParser.parse(filePath);
  }

  @override
  String detectFileType(String filePath) {
    if (EpubParser.isEpubFile(filePath)) return 'epub';
    if (TxtParser.isTxtFile(filePath)) return 'txt';
    if (PdfParser.isPdfFile(filePath)) return 'pdf';
    throw FormatException('未知文件类型: $filePath');
  }

  @override
  Future<int> getFileSize(String filePath) async {
    final file = File(filePath);
    final stat = await file.stat();
    return stat.size;
  }

  /// 生成 UUID
  String _generateUuid() {
    final random = Random();
    return '${random.nextInt(0xFFFFFFFF)}-${random.nextInt(0xFFFF)}-${random.nextInt(0xFFFF)}-${random.nextInt(0xFFFF)}-${random.nextInt(0xFFFFFFFF)}';
  }
}
