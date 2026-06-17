// search_page.dart
// 搜索页面

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/search_result.dart';
import '../controllers/search_controller.dart';

/// 搜索页面
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(searchControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.search,
            border: InputBorder.none,
          ),
          onChanged: (value) {
            ref.read(searchControllerProvider.notifier).search(value);
          },
        ),
        actions: [
          if (state.query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                ref.read(searchControllerProvider.notifier).clear();
              },
            ),
        ],
      ),
      body: _buildBody(state, l10n),
    );
  }

  Widget _buildBody(SearchState state, AppLocalizations l10n) {
    // 无搜索时显示历史
    if (state.query.isEmpty) {
      if (state.history.isEmpty) {
        return Center(
          child: Text(l10n.search),
        );
      }

      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Recent',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ...state.history.map((query) => ListTile(
                leading: const Icon(Icons.history),
                title: Text(query),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    ref
                        .read(searchControllerProvider.notifier)
                        .removeFromHistory(query);
                  },
                ),
                onTap: () {
                  _controller.text = query;
                  ref.read(searchControllerProvider.notifier).search(query);
                },
              )),
        ],
      );
    }

    // 加载中
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 无结果
    if (state.results.isEmpty) {
      return Center(
        child: Text('No results for "${state.query}"'),
      );
    }

    // 搜索结果
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final result = state.results[index];
        return _SearchResultCard(result: result);
      },
    );
  }
}

/// 搜索结果卡片
class _SearchResultCard extends StatelessWidget {
  final SearchResult result;

  const _SearchResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          _getIcon(result.type),
          size: 24,
        ),
        title: Text(
          result.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(result.snippet),
      ),
    );
  }

  IconData _getIcon(SearchResultType type) {
    switch (type) {
      case SearchResultType.book:
        return Icons.book;
      case SearchResultType.highlight:
        return Icons.highlight;
      case SearchResultType.note:
        return Icons.note;
    }
  }
}
