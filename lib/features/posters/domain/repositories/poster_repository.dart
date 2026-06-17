// poster_repository.dart
// Poster Repository 接口（domain 层）

import '../entities/poster.dart';

/// Poster Repository 抽象接口
abstract class PosterRepository {
  /// 保存海报
  Future<int> savePoster(Poster poster);

  /// 获取所有海报
  Future<List<Poster>> getAllPosters();

  /// 删除海报
  Future<int> deletePoster(String id);
}
