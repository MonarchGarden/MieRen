import 'package:flutter_test/flutter_test.dart';
import 'package:mieren_app/main.dart';

void main() {
  testWidgets('MieRen App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MieRenApp());

    // Verify that app main title is rendered
    expect(find.text('MieRen'), findsWidgets);
  });
}
