import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_input_demo/main.dart';
import 'package:form_input_demo/models/users.dart';
import 'package:form_input_demo/widgets/display_form_card.dart';
import 'package:form_input_demo/widgets/priority_radius_button.dart';

void main() {
  testWidgets('Saving displays latest task and cancelling preserves it', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    expect(find.text('No task submitted yet'), findsOneWidget);
    await tester.tap(find.text('New Form'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'First Task');
    await tester.enterText(find.byType(TextFormField).at(1), '7.25');
    await tester.tap(find.text('High'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Email Notifications'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<User>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('James Smith').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Form'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
    expect(find.text('First Task'), findsOneWidget);
    expect(find.text('James Smith'), findsOneWidget);
    expect(find.text(r'$7.25 / hour'), findsOneWidget);
    expect(find.text('high'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    final original = tester
        .widget<DisplayFormCard>(find.byType(DisplayFormCard))
        .task!;
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Task'), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).at(0))
          .controller!
          .text,
      'First Task',
    );
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).at(1))
          .controller!
          .text,
      '7.25',
    );
    expect(
      tester
          .widget<DropdownButton<User>>(find.byType(DropdownButton<User>))
          .value,
      same(original.assignedUser),
    );
    expect(
      tester
          .widget<RadioMenuButton<Priority>>(
            find.widgetWithText(RadioMenuButton<Priority>, 'High'),
          )
          .groupValue,
      Priority.high,
    );
    expect(
      tester
          .widget<CheckboxListTile>(
            find.widgetWithText(CheckboxListTile, 'Email Notifications'),
          )
          .value,
      isTrue,
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'Changed Task');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<DisplayFormCard>(find.byType(DisplayFormCard)).task,
      same(original),
    );
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Edited Task');
    await tester.enterText(find.byType(TextFormField).at(1), '8.50');
    await tester.tap(find.text('Low'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Email Notifications'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<User>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('John Doe').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Form'));
    await tester.pumpAndSettle();
    final edited = tester
        .widget<DisplayFormCard>(find.byType(DisplayFormCard))
        .task!;
    expect(edited.taskID, original.taskID);
    expect(edited.taskName, 'Edited Task');
    expect(edited.hourlyRate, 8.5);
    expect(edited.priority, Priority.low);
    expect(edited.emailNotification, isFalse);
    expect(edited.assignedUser!.fullName, 'John Doe');
    expect(find.text('Edited Task'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
    await tester.tap(find.text('New Form'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Latest Task');
    await tester.tap(find.text('Save Form'));
    await tester.pumpAndSettle();
    expect(find.text('Latest Task'), findsOneWidget);
    expect(find.text('First Task'), findsNothing);
    expect(find.text('None'), findsOneWidget);
    await tester.tap(find.text('New Form'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Latest Task'), findsOneWidget);
  });

  testWidgets('Invalid task details cannot be saved', (tester) async {
    tester.view.physicalSize = const Size(1000, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('New Form'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), ' ');
    await tester.enterText(find.byType(TextFormField).at(1), 'NaN');
    await tester.tap(find.text('Save Form'));
    await tester.pumpAndSettle();
    expect(find.text('Enter 5–20 characters.'), findsOneWidget);
    expect(
      find.text('Enter a rate greater than 3 and less than 10.'),
      findsOneWidget,
    );
    expect(find.byType(Dialog), findsOneWidget);
  });
}
