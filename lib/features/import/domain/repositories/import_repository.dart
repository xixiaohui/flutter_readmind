// import_repository.dart
// Import Repository 接口（domain 层）

/// 书籍元数据
class BookMetadata {
  final String title;
  final String? author;
  final String? description;
  final String? language;
  final String? publisher;
  final String? isbn;
  final String? coverPath;
  final int? totalPages;
  final int fileSize;

  const BookMetadata({
    required this.title,
    this.author,
    this.description,
    this.language,
    this.publisher,
    this.isbn,
    this.coverPath,
    this.totalPages,
    required this.fileSize,
  });
}

/// 导入结果
class ImportResult {
  final String filePath;
  final String fileName;
  final String fileType;
  final BookMetadata metadata;
  final bool success;
  final String? errorMessage;

  const ImportResult({
    required this.filePath,
    required this.fileName,
    required this.fileType,
    required this.metadata,
    this.success = true,
    this.errorMessage,
  });

  /// 失败结果
  factory ImportResult.failure({
    required String filePath,
    required String fileName,
    required String fileType,
    required String errorMessage,
  }) {
    return ImportResult(
      filePath: filePath,
      fileName: fileName,
      fileType: fileType,
      metadata: const BookMetadata(title: '', fileSize: 0),
      success: false,
      errorMessage: errorMessage,
    );
  }
}

/// Import Repository 抽象接口
abstract class ImportRepository {
  /// 导入文件
  Future<ImportResult> importFile(String filePath);

  /// 解析 EPUB 文件
  Future<BookMetadata> parseEpub(String filePath);

  /// 解析 TXT 文件
  Future<BookMetadata> parseTxt(String filePath);

  /// 解析 PDF 文件
  Future<BookMetadata> parsePdf(String filePath);

  /// 检测文件类型
  String detectFileType(String filePath);

  /// 获取文件大小
  Future<int> getFileSize(String filePath);
}
