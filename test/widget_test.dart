import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis_mini/main.dart';

void main() {
  testWidgets('JARVIS App initialization smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JarvisApp());
    expect(find.byType(JarvisApp), findsOneWidget);
  });
}
