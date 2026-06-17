// highlight_use_cases.dart
// 高亮相关 Use Cases

import '../../../../core/use_case/use_case.dart';
import '../../../../features/shared/domain/repositories/highlight_repository.dart';

/// 创建高亮 Use Case
class CreateHighlightUseCase implements UseCase<HighlightData, HighlightData> {
  final HighlightRepository _repository;

  CreateHighlightUseCase(this._repository);

  @override
  Future<HighlightData> call(HighlightData highlight) async {
    await _repository.insertHighlight(highlight);
    return highlight;
  }
}

/// 获取书籍高亮 Use Case
class GetBookHighlightsUseCase
    implements UseCase<List<HighlightData>, int> {
  final HighlightRepository _repository;

  GetBookHighlightsUseCase(this._repository);

  @override
  Future<List<HighlightData>> call(int bookId) async {
    return _repository.getHighlightsByBookId(bookId);
  }
}

/// 删除高亮 Use Case
class DeleteHighlightUseCase implements UseCase<void, int> {
  final HighlightRepository _repository;

  DeleteHighlightUseCase(this._repository);

  @override
  Future<void> call(int highlightId) async {
    await _repository.deleteHighlight(highlightId);
  }
}
