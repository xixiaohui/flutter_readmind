// app_database.dart
// Drift 数据库主类

import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';

import 'tables/books_table.dart';
import 'tables/book_chapters_table.dart';
import 'tables/reading_progress_table.dart';
import 'tables/highlights_table.dart';
import 'tables/notes_table.dart';
import 'tables/tags_table.dart';
import 'tables/highlight_tags_table.dart';
import 'tables/generated_posters_table.dart';
import 'tables/favorites_table.dart';
import 'tables/collections_table.dart';
import 'tables/collection_items_table.dart';
import 'tables/bookmarks_table.dart';
import 'tables/search_history_table.dart';
import 'tables/user_settings_table.dart';
import 'tables/purchase_status_table.dart';
import 'tables/analytics_events_table.dart';
import 'tables/sync_queue_table.dart';
import 'tables/app_metadata_table.dart';

import 'database_io.dart' if (dart.library.html) 'database_web.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Books,
    BookChapters,
    ReadingProgress,
    Highlights,
    Notes,
    Tags,
    HighlightTags,
    GeneratedPosters,
    Favorites,
    Collections,
    CollectionItems,
    Bookmarks,
    SearchHistory,
    UserSettings,
    PurchaseStatus,
    AnalyticsEvents,
    SyncQueue,
    AppMetadata,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(createConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.alterTable(
              TableMigration(
                generatedPosters,
                newColumns: [
                  generatedPosters.quoteText,
                  generatedPosters.bookTitle,
                  generatedPosters.author,
                ],
              ),
            );
          }
        },
      );

  /// 安全初始化（Web 平台降级处理）
  static AppDatabase? safeInit() {
    try {
      return AppDatabase();
    } catch (e) {
      if (kIsWeb) {
        debugPrint('Web database init skipped: $e');
        return null;
      }
      rethrow;
    }
  }
}

AppDatabase? constructDb() {
  return AppDatabase.safeInit();
}
