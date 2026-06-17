// import_task.dart
// 导入任务实体

/// 导入状态
enum ImportStatus {
  pending,
  parsing,
  saving,
  completed,
  failed,
}

/// 导入任务实体
class ImportTask {
  final String id;
  final String filePath;
  final String fileName;
  final String fileType;
  final ImportStatus status;
  final double progress;
  final String? errorMessage;

  const ImportTask({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.fileType,
    this.status = ImportStatus.pending,
    this.progress = 0.0,
    this.errorMessage,
  });

  /// 复制并更新
  ImportTask copyWith({
    String? id,
    String? filePath,
    String? fileName,
    String? fileType,
    ImportStatus? status,
    double? progress,
    String? errorMessage,
  }) {
    return ImportTask(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: errorMessage,
    );
  }
}
