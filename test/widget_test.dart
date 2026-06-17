// widget_test.dart
// ReadMeet Quotes 应用测试

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide isNotNull;

import 'package:flutter_readmind/main.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('ReadMeet App Tests', () {
    testWidgets('App launches with ProviderScope and MaterialApp',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: ReadMeetApp()),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App has bottom navigation with 4 tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: ReadMeetApp()),
      );

      expect(find.byType(NavigationBar), findsOneWidget);

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.destinations.length, 4);
    });

    testWidgets('App supports theme configuration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: ReadMeetApp()),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
    });

    testWidgets('App title is correct', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: ReadMeetApp()),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'ReadMeet Quotes');
    });

    testWidgets('App debug mode is disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: ReadMeetApp()),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, false);
    });
  });
}
