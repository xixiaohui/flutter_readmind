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
        childAspectRatio: 0.7,
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

/// 书籍卡片
class _BookCard extends ConsumerWidget {
  final BookData book;
  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

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
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                alignment: Alignment.center,
                child: Icon(_getFileIcon(book.fileType), size: 48,
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  if (book.author != null) ...[
                    const SizedBox(height: 4),
                    Text(book.author!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ],
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
}

/// 书籍列表 Provider（使用 Stream 自动更新）
final bookListProvider = StreamProvider<List<BookData>>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.watchAllBooks();
});
