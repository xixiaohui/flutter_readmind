// import_page.dart
// 导入页面

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/import_task.dart';
import '../controllers/import_controller.dart';

/// 导入页面
class ImportPage extends ConsumerWidget {
  const ImportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(importControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.import,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 导入按钮
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: state.isImporting
                    ? null
                    : () => _pickFile(context, ref),
                icon: state.isImporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.file_open),
                label: Text(
                  state.isImporting ? l10n.importing : l10n.selectFile,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 错误消息
            if (state.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.errorMessage!)),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // 导入历史
            Expanded(
              child: state.tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.import_contacts_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.selectFile,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {
                        final task = state.tasks[index];
                        return ListTile(
                          leading: Icon(
                            _getFileIcon(task.fileType),
                            size: 32,
                          ),
                          title: Text(task.fileName),
                          subtitle: Text(_getStatusText(task.status)),
                          trailing: Icon(
                            task.status == ImportStatus.completed
                                ? Icons.check_circle
                                : Icons.error,
                            color: task.status == ImportStatus.completed
                                ? Colors.green
                                : Colors.red,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// 打开文件选择器
  Future<void> _pickFile(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub', 'txt', 'pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.first.path;
      if (filePath != null) {
        ref.read(importControllerProvider.notifier).importFile(filePath);
      }
    }
  }

  /// 获取文件图标
  IconData _getFileIcon(String fileType) {
    switch (fileType) {
      case 'epub':
        return Icons.menu_book;
      case 'txt':
        return Icons.text_snippet;
      case 'pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.insert_drive_file;
    }
  }

  /// 获取状态文本
  String _getStatusText(ImportStatus status) {
    switch (status) {
      case ImportStatus.pending:
        return 'Pending';
      case ImportStatus.parsing:
        return 'Parsing...';
      case ImportStatus.saving:
        return 'Saving...';
      case ImportStatus.completed:
        return 'Completed';
      case ImportStatus.failed:
        return 'Failed';
    }
  }
}
