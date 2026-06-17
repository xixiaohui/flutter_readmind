// theme_controller_test.dart
// 主题控制器测试

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_readmind/core/theme/app_theme_mode.dart';

void main() {
  group('AppThemeMode', () {
    test('toStorageString', () {
      expect(AppThemeMode.light.toStorageString(), 'light');
      expect(AppThemeMode.dark.toStorageString(), 'dark');
      expect(AppThemeMode.sepia.toStorageString(), 'sepia');
    });

    test('fromStorageString correct values', () {
      expect(AppThemeModeExtension.fromStorageString('light'), AppThemeMode.light);
      expect(AppThemeModeExtension.fromStorageString('dark'), AppThemeMode.dark);
      expect(AppThemeModeExtension.fromStorageString('sepia'), AppThemeMode.sepia);
    });

    test('fromStorageString defaults to light', () {
      expect(AppThemeModeExtension.fromStorageString(null), AppThemeMode.light);
      expect(AppThemeModeExtension.fromStorageString('unknown'), AppThemeMode.light);
    });
  });
}
