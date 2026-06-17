// import_book_use_case.dart
// 导入书籍 Use Case

import '../../../../core/use_case/use_case.dart';
import '../repositories/import_repository.dart';

/// 导入书籍 Use Case
class ImportBookUseCase implements UseCase<ImportResult, String> {
  final ImportRepository _repository;

  ImportBookUseCase(this._repository);

  @override
  Future<ImportResult> call(String filePath) async {
    return _repository.importFile(filePath);
  }
}
