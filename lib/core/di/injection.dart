// injection.dart
// 依赖注入配置

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../database/app_database.dart';
import '../database/daos/book_dao.dart';
import '../database/daos/highlight_dao.dart';
import '../database/daos/note_dao.dart';
import '../database/daos/reading_progress_dao.dart';
import '../database/daos/tag_dao.dart';
import '../database/daos/generated_poster_dao.dart';
import '../network/network_info.dart';
import '../storage/local_storage_service.dart';
import '../theme/theme_controller.dart';
import '../theme/app_theme_mode.dart';

import '../../features/shared/domain/repositories/book_repository.dart';
import '../../features/shared/domain/repositories/highlight_repository.dart';
import '../../features/shared/domain/repositories/note_repository.dart';
import '../../features/shared/data/repositories/book_repository_impl.dart';
import '../../features/shared/data/repositories/highlight_repository_impl.dart';
import '../../features/shared/data/repositories/note_repository_impl.dart';
import '../../features/import/domain/repositories/import_repository.dart';
import '../../features/import/data/repositories/import_repository_impl.dart';
import '../../features/reader/domain/repositories/reader_repository.dart';
import '../../features/reader/data/repositories/reader_repository_impl.dart';
import '../../features/posters/domain/repositories/poster_repository.dart';
import '../../features/posters/data/repositories/poster_repository_impl.dart';
import '../services/share_service.dart';

/// 初始化依赖注入
Future<void> initInjection() async {
  await SharedPreferences.getInstance();
}

// --- 数据库 Provider ---

/// AppDatabase Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// --- DAO Providers ---

/// BookDao Provider
final bookDaoProvider = Provider<BookDao>((ref) {
  final db = ref.watch(databaseProvider);
  return BookDao(db);
});

/// HighlightDao Provider
final highlightDaoProvider = Provider<HighlightDao>((ref) {
  final db = ref.watch(databaseProvider);
  return HighlightDao(db);
});

/// NoteDao Provider
final noteDaoProvider = Provider<NoteDao>((ref) {
  final db = ref.watch(databaseProvider);
  return NoteDao(db);
});

/// ReadingProgressDao Provider
final readingProgressDaoProvider = Provider<ReadingProgressDao>((ref) {
  final db = ref.watch(databaseProvider);
  return ReadingProgressDao(db);
});

/// TagDao Provider
final tagDaoProvider = Provider<TagDao>((ref) {
  final db = ref.watch(databaseProvider);
  return TagDao(db);
});

/// GeneratedPosterDao Provider
final generatedPosterDaoProvider = Provider<GeneratedPosterDao>((ref) {
  final db = ref.watch(databaseProvider);
  return GeneratedPosterDao(db);
});

// --- Repository Providers ---

/// BookRepository Provider
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final dao = ref.watch(bookDaoProvider);
  return BookRepositoryImpl(dao);
});

/// HighlightRepository Provider
final highlightRepositoryProvider = Provider<HighlightRepository>((ref) {
  final dao = ref.watch(highlightDaoProvider);
  return HighlightRepositoryImpl(dao);
});

/// NoteRepository Provider
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final dao = ref.watch(noteDaoProvider);
  return NoteRepositoryImpl(dao);
});

// --- 核心服务 Provider ---

/// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('需要在应用启动时初始化'),
);

/// 本地存储服务 Provider
final localStorageServiceProvider = Provider<LocalStorageService>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    return LocalStorageServiceImpl(prefs);
  },
);

/// 网络信息 Provider
final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => NetworkInfoImpl(Connectivity()),
);

// --- Import Provider ---

/// ImportRepository Provider
final importRepositoryProvider = Provider<ImportRepository>((ref) {
  final bookDao = ref.watch(bookDaoProvider);
  return ImportRepositoryImpl(bookDao);
});

// --- Reader Provider ---

/// ReaderRepository Provider
final readerRepositoryProvider = Provider<ReaderRepository>((ref) {
  final progressDao = ref.watch(readingProgressDaoProvider);
  return ReaderRepositoryImpl(progressDao);
});

// --- Poster Repository Provider ---

/// PosterRepository Provider
final posterRepositoryProvider = Provider<PosterRepository>((ref) {
  final dao = ref.watch(generatedPosterDaoProvider);
  return PosterRepositoryImpl(dao);
});

// --- 主题控制器 Provider ---

// --- 分享服务 ---

/// 分享服务 Provider
final shareServiceProvider = Provider<ShareService>((ref) {
  return ShareServiceImpl();
});

/// 主题控制器 Provider
final themeControllerProvider =
    StateNotifierProvider<ThemeController, AppThemeMode>(
  (ref) => ThemeController(),
);
