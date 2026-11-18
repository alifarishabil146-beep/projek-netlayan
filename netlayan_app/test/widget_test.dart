import 'package:flutter_test/flutter_test.dart';
import 'package:netlayan_app/main.dart';

void main() {
  testWidgets('Netlayan app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NetlayanApp());
    expect(find.byType(NetlayanApp), findsOneWidget);
  });
}
