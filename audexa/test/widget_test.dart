import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:voice_notes_app/main.dart';
import 'package:provider/provider.dart';
import 'package:voice_notes_app/providers/note_provider.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App loads and shows Voice Notes title',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NoteProvider()),
        ],
        child: const VoiceNotesApp(),
      ),
    );
    await tester.pump();
    expect(find.text('Voice Notes'), findsOneWidget);
  });
}
