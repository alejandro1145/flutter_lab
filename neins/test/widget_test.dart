import 'package:flutter_test/flutter_test.dart';
import 'package:neins/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NeinsApp());
    expect(find.byType(NeinsApp), findsOneWidget);
  });
}