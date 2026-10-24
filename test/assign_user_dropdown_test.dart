import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_input_demo/models/users.dart';
import 'package:form_input_demo/widgets/assign_user_dropdown.dart';

void main() {
  testWidgets('Shows ten names and returns the selected User object', (
    tester,
  ) async {
    User? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AssignUserDropDown(onChanged: (user) => selected = user),
        ),
      ),
    );
    final dropdown = tester.widget<DropdownButton<User>>(
      find.byType(DropdownButton<User>),
    );
    expect(dropdown.items, hasLength(10));
    for (final item in dropdown.items!) {
      expect((item.child as Text).data, item.value!.fullName);
    }
    final expectedUser = dropdown.items![1].value;
    await tester.tap(find.byType(DropdownButtonFormField<User>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('James Smith').last);
    await tester.pumpAndSettle();
    expect(identical(selected, expectedUser), isTrue);
    expect(selected!.userID, 1001);
  });
}
