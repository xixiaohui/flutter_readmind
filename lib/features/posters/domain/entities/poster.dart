// poster.dart
// 海报实体

/// 海报模板
enum PosterTemplate {
  minimal,
  paper,
  dark,
  cover;

  /// 模板显示名称
  String get displayName {
    switch (this) {
      case PosterTemplate.minimal:
        return 'Minimal';
      case PosterTemplate.paper:
        return 'Paper';
      case PosterTemplate.dark:
        return 'Dark';
      case PosterTemplate.cover:
        return 'Cover';
    }
  }
}

/// 海报比例
enum PosterRatio {
  square,    // 1:1
  portrait,  // 4:5
  story,     // 9:16
}

/// 海报实体
class Poster {
  final String id;
  final int highlightId;
  final String quoteText;
  final String? bookTitle;
  final String? author;
  final PosterTemplate template;
  final PosterRatio ratio;
  final String? imagePath;
  final DateTime createdAt;

  const Poster({
    required this.id,
    required this.highlightId,
    required this.quoteText,
    this.bookTitle,
    this.author,
    this.template = PosterTemplate.minimal,
    this.ratio = PosterRatio.square,
    this.imagePath,
    required this.createdAt,
  });

  /// 创建新海报
  factory Poster.create({
    required int highlightId,
    required String quoteText,
    String? bookTitle,
    String? author,
    PosterTemplate template = PosterTemplate.minimal,
    PosterRatio ratio = PosterRatio.square,
  }) {
    return Poster(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      highlightId: highlightId,
      quoteText: quoteText,
      bookTitle: bookTitle,
      author: author,
      template: template,
      ratio: ratio,
      createdAt: DateTime.now(),
    );
  }

  /// 复制并更新
  Poster copyWith({
    String? imagePath,
  }) {
    return Poster(
      id: id,
      highlightId: highlightId,
      quoteText: quoteText,
      bookTitle: bookTitle,
      author: author,
      template: template,
      ratio: ratio,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt,
    );
  }
}
