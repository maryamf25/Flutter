import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:news_app/main.dart';
import 'package:news_app/providers/news_provider.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => NewsProvider(),
        child: const NewsApp(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
