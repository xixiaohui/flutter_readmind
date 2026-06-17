// get_book_content_use_case.dart
// 获取书籍内容 Use Case

import '../../../../core/use_case/use_case.dart';
import '../../domain/entities/book_content.dart';
import '../../domain/repositories/reader_repository.dart';

/// 获取书籍内容参数
class GetContentParams {
  final String filePath;
  final String fileType;
  final int bookId;

  const GetContentParams({
    required this.filePath,
    required this.fileType,
    required this.bookId,
  });
}

/// 获取书籍内容 Use Case
class GetBookContentUseCase implements UseCase<BookContent, GetContentParams> {
  final ReaderRepository _repository;

  GetBookContentUseCase(this._repository);

  @override
  Future<BookContent> call(GetContentParams params) async {
    return _repository.getBookContent(
        params.filePath, params.fileType, params.bookId);
  }
}
