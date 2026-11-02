import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:canecare/providers/scan_provider.dart';
import 'package:canecare/screens/image_preview_screen.dart';

void main() {
  test('ScanProvider onImageCaptured updates imagePath and selectedImage', () async {
    final scanProvider = ScanProvider();
    final dummyFile = XFile('test_leaf.jpg');

    await scanProvider.onImageCaptured(dummyFile);

    expect(scanProvider.selectedImage, isNotNull);
    expect(scanProvider.imagePath, 'test_leaf.jpg');
  });

  testWidgets('ImagePreviewScreen renders correctly with dynamic leaf file',
      (WidgetTester tester) async {
    final scanProvider = ScanProvider();
    await scanProvider.setDemoLeafImage('assets/images/leaf_in_viewfinder.png');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ScanProvider>.value(value: scanProvider),
        ],
        child: const MaterialApp(
          home: ImagePreviewScreen(),
        ),
      ),
    );

    await tester.pump();

    // Verify analyze button and subtext
    expect(find.text('Analyze Leaf'), findsOneWidget);
    expect(find.text('Retake'), findsOneWidget);
    expect(find.text('Make sure the leaf is clear and well-lit.'), findsOneWidget);
  });
}
