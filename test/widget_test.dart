import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trikayo/features/home/view/home_screen.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('HomeScreen displays welcome message', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Verify that the welcome message is displayed
      expect(find.text('Welcome to Trikayo'), findsOneWidget);
      expect(find.text('Your meal management and nutrition tracking app'), findsOneWidget);
    });

    testWidgets('HomeScreen displays feature cards', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Verify that feature cards are displayed
      expect(find.text('Catalog'), findsOneWidget);
      expect(find.text('Post Meal'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Paywall'), findsOneWidget);
    });

    testWidgets('HomeScreen has theme toggle button', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Verify that the theme toggle button is present
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });
  });
}
