// import_controller.dart
// Import Controller (Riverpod)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/import_repository.dart';
import '../../domain/entities/import_task.dart';

/// 导入状态
class ImportState {
  final bool isImporting;
  final List<ImportTask> tasks;
  final String? errorMessage;

  const ImportState({
    this.isImporting = false,
    this.tasks = const [],
    this.errorMessage,
  });

  ImportState copyWith({
    bool? isImporting,
    List<ImportTask>? tasks,
    String? errorMessage,
  }) {
    return ImportState(
      isImporting: isImporting ?? this.isImporting,
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage,
    );
  }
}

/// Import Controller
class ImportController extends StateNotifier<ImportState> {
  final ImportRepository _repository;

  ImportController(this._repository) : super(const ImportState());

  /// 导入文件
  Future<void> importFile(String filePath) async {
    state = state.copyWith(isImporting: true, errorMessage: null);

    try {
      final result = await _repository.importFile(filePath);

      final task = ImportTask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        filePath: result.filePath,
        fileName: result.fileName,
        fileType: result.fileType,
        status: result.success ? ImportStatus.completed : ImportStatus.failed,
        errorMessage: result.errorMessage,
      );

      state = state.copyWith(
        isImporting: false,
        tasks: [task, ...state.tasks],
        errorMessage: result.errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isImporting: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 清除错误消息
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Import Controller Provider
final importControllerProvider =
    StateNotifierProvider<ImportController, ImportState>((ref) {
  final repository = ref.watch(importRepositoryProvider);
  return ImportController(repository);
});
