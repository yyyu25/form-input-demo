import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_input_demo/widgets/priority_radius_button.dart';

void main() {
  for (final width in [240.0, 300.0, 500.0]) {
    testWidgets('Priority options fit within $width pixels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: const PriorityRadiusButton(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      for (final label in ['Low', 'Medium', 'High']) {
        expect(
          tester.getRect(find.text(label)).right,
          lessThanOrEqualTo(width),
        );
      }
      await tester.tap(find.text('High'));
      await tester.pumpAndSettle();
      final high = tester.widget<RadioMenuButton<Priority>>(
        find.widgetWithText(RadioMenuButton<Priority>, 'High'),
      );
      expect(high.groupValue, Priority.high);
    });
  }
}
