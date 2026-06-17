// search_result.dart
// 搜索结果实体

/// 搜索结果类型
enum SearchResultType {
  book,
  highlight,
  note,
}

/// 搜索结果实体
class SearchResult {
  final String id;
  final SearchResultType type;
  final String title;
  final String snippet;
  final String? subtitle;

  const SearchResult({
    required this.id,
    required this.type,
    required this.title,
    required this.snippet,
    this.subtitle,
  });
}
