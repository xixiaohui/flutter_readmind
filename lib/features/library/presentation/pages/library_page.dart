// library_page.dart
// 书架页面 — 书籍展示、导入、删除

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/shared/domain/repositories/book_repository.dart';

/// 书架页面
class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final booksAsync = ref.watch(bookListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.library, style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: l10n.search,
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: booksAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return _EmptyLibrary(l10n: l10n);
          }
          return _BookGrid(books: books);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, size: 64,
                  color: Theme.of(context).colorScheme.secondary),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.webDatabaseUnavailable,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/import'),
        tooltip: l10n.import,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 空书架
class _EmptyLibrary extends StatelessWidget {
  final AppLocalizations l10n;
  const _EmptyLibrary({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 64,
              color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 16),
          Text(l10n.noBooks,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary)),
          const SizedBox(height: 8),
          Text(l10n.importBook, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// 书架网格
class _BookGrid extends ConsumerWidget {
  final List<BookData> books;
  const _BookGrid({required this.books});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,  // 2:3 封面比例，符合 UI_DESIGN
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return _BookCard(book: books[index]);
      },
    );
  }
}

/// 书籍卡片 — 经典书架风格
class _BookCard extends ConsumerWidget {
  final BookData book;
  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colors = _coverColors(book.fileType);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        context.push('/reader', extra: {
          'filePath': book.filePath,
          'fileType': book.fileType,
          'bookTitle': book.title,
          'bookId': book.id.toString(),
        });
      },
      onLongPress: () => _showDeleteDialog(context, ref, l10n),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(theme.brightness == Brightness.dark ? 30 : 12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 封面区 ──
            Expanded(
              flex: 72,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colors.$1, colors.$2],
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 背景图标（水印效果）
                    Positioned(
                      right: -16,
                      bottom: -16,
                      child: Icon(
                        _getFileIcon(book.fileType),
                        size: 96,
                        color: colors.$3.withAlpha(40),
                      ),
                    ),
                    // 主图标
                    Center(
                      child: Icon(
                        _getFileIcon(book.fileType),
                        size: 44,
                        color: colors.$3.withAlpha(140),
                      ),
                    ),
                    // 文件类型标签
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colors.$3.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          book.fileType.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: colors.$3.withAlpha(160),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ── 信息区 ──
            Expanded(
              flex: 28,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 书名
                    Expanded(
                      child: Text(book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.35)),
                    ),
                    // 作者 + 进度
                    Row(
                      children: [
                        if (book.author != null)
                          Expanded(
                            child: Text(book.author!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withAlpha(140))),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示删除确认对话框
  void _showDeleteDialog(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text('${l10n.confirm} ${book.title}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel)),
          TextButton(
            onPressed: () async {
              await ref
                  .read(bookRepositoryProvider)
                  .deleteBook(book.id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(l10n.delete,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType) {
      case 'epub': return Icons.menu_book;
      case 'txt': return Icons.text_snippet;
      case 'pdf': return Icons.picture_as_pdf;
      default: return Icons.book;
    }
  }

  /// 封面渐变色：(topLeft, bottomRight, accent)
  static (Color, Color, Color) _coverColors(String fileType) {
    switch (fileType) {
      case 'epub':
        return (
          const Color(0xFFE8E0F0),
          const Color(0xFFD6CCE6),
          const Color(0xFF6B4E9B),
        );
      case 'pdf':
        return (
          const Color(0xFFFBE0DD),
          const Color(0xFFF3CBC6),
          const Color(0xFFC2554A),
        );
      case 'txt':
        return (
          const Color(0xFFDFEDE8),
          const Color(0xFFCDDDD5),
          const Color(0xFF4A7C64),
        );
      default:
        return (
          const Color(0xFFE8E8ED),
          const Color(0xFFD6D6DE),
          const Color(0xFF636380),
        );
    }
  }
}

/// 书籍列表 Provider（使用 Stream 自动更新）
final bookListProvider = StreamProvider<List<BookData>>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.watchAllBooks();
});
