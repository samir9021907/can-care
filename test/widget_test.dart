import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:canecare/app.dart';

void main() {
  testWidgets('CaneCare AI Splash Screen smoke test',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const CaneCareApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify CaneCare AI branding matching Figma Screen 1
    expect(find.text('CaneCare AI'), findsOneWidget);
    expect(
      find.text(
          'AI-Based Sugarcane Disease Detection\nUsing Leaf Image Analysis'),
      findsOneWidget,
    );
    expect(find.text('Healthy leaves,\nbetter harvest'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text("Built for Maharashtra's farmers"), findsOneWidget);
  });
}
