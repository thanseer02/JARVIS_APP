import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis_mini/main.dart';

void main() {
  testWidgets('JARVIS App initialization smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JarvisApp());
    expect(find.byType(JarvisApp), findsOneWidget);
    // Advance time incrementally past splash delay timers without pumpAndSettle hanging on repeat animations
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 500));
  });
}
