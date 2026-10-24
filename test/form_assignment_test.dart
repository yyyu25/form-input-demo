import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_input_demo/models/tasks.dart';
import 'package:form_input_demo/models/users.dart';
import 'package:form_input_demo/widgets/form_dialog.dart';
import 'package:form_input_demo/widgets/priority_radius_button.dart';

const initialValues = <String, dynamic>{
  'name': 'Study Task',
  'amount': 6.25,
  'priority': Priority.medium,
  'emailNotification': true,
  'smsNotification': false,
  'phoneNotification': true,
  'assignedUser': User(fullName: 'James Smith', userID: 1001),
};

Future<void> openForm(
  WidgetTester tester, {
  Map<String, dynamic> values = initialValues,
  ValueChanged<Task?>? onResult,
}) async {
  tester.view.physicalSize = const Size(1000, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: TextButton(
              onPressed: () async {
                final result = await showInputFormDialog(
                  context,
                  initialValues: values,
                );
                onResult?.call(result);
              },
              child: const Text('Open form'),
            ),
          );
        },
      ),
    ),
  );
  await tester.tap(find.text('Open form'));
  await tester.pumpAndSettle();
}

void Function() restoreConsole = () {};

List<String> captureConsole() {
  final messages = <String>[];
  final original = debugPrint;
  restoreConsole = () => debugPrint = original;
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null) messages.add(message);
  };
  addTearDown(() => debugPrint = original);
  return messages;
}

CheckboxListTile checkbox(WidgetTester tester, String label) => tester
    .widget<CheckboxListTile>(find.widgetWithText(CheckboxListTile, label));

void main() {
  testWidgets(
    'Initial Map populates both text controllers and every selection',
    (tester) async {
      await openForm(tester);
      final fields = tester
          .widgetList<TextFormField>(find.byType(TextFormField))
          .toList();
      expect(fields[0].controller!.text, 'Study Task');
      expect(fields[1].controller!.text, '6.25');
      final radios = tester.widgetList<RadioMenuButton<Priority>>(
        find.byType(RadioMenuButton<Priority>),
      );
      expect(radios.map((radio) => radio.value), Priority.values);
      expect(
        radios.every((radio) => radio.groupValue == Priority.medium),
        isTrue,
      );
      expect(checkbox(tester, 'Email Notifications').value, isTrue);
      expect(checkbox(tester, 'SMS Notifications').value, isFalse);
      expect(checkbox(tester, 'Phone Notifications').value, isTrue);
      final dropdown = tester.widget<DropdownButton<User>>(
        find.byType(DropdownButton<User>),
      );
      expect(dropdown.items, hasLength(10));
      expect(
        dropdown.items!.map((item) => item.value!.userID).toSet(),
        hasLength(10),
      );
      for (final item in dropdown.items!) {
        expect((item.child as Text).data, item.value!.fullName);
      }
      expect(dropdown.value!.userID, 1001);
    },
  );

  for (final input in [
    '',
    'abc',
    '3.00',
    '10.00',
    '2.99',
    '10.01',
    'NaN',
    'Infinity',
  ]) {
    testWidgets(
      'Rejects invalid hourly rate "$input" without saving or printing',
      (tester) async {
        final messages = captureConsole();
        var returned = false;
        await openForm(tester, onResult: (_) => returned = true);
        await tester.enterText(find.byType(TextFormField).at(1), input);
        await tester.tap(find.text('Save Form'));
        await tester.pumpAndSettle();
        expect(
          find.text('Enter a rate greater than 3 and less than 10.'),
          findsOneWidget,
        );
        expect(find.byType(InputFormDialog), findsOneWidget);
        expect(returned, isFalse);
        expect(messages, isEmpty);
        restoreConsole();
      },
    );
  }

  for (final input in ['', '    ', 'abcd', 'abcdefghijklmnopqrstu']) {
    testWidgets('Rejects invalid task name "$input"', (tester) async {
      await openForm(tester);
      await tester.enterText(find.byType(TextFormField).at(0), input);
      await tester.tap(find.text('Save Form'));
      await tester.pumpAndSettle();
      expect(find.text('Enter 5–20 characters.'), findsOneWidget);
      expect(find.byType(InputFormDialog), findsOneWidget);
    });
  }

  for (final sample in [('abcde', '3.01'), ('abcdefghijklmnopqrst', '9.99')]) {
    testWidgets(
      'Accepts name length ${sample.$1.length} and rate ${sample.$2}',
      (tester) async {
        final messages = captureConsole();
        Task? result;
        await openForm(tester, onResult: (task) => result = task);
        await tester.enterText(find.byType(TextFormField).at(0), sample.$1);
        await tester.enterText(find.byType(TextFormField).at(1), sample.$2);
        await tester.tap(find.text('Save Form'));
        await tester.pumpAndSettle();
        expect(result!.taskName, sample.$1);
        expect(result!.hourlyRate, double.parse(sample.$2));
        expect(result!.hourlyRate, isA<double>());
        expect(messages, hasLength(1));
        restoreConsole();
      },
    );
  }

  testWidgets(
    'Changed controls save typed values and print all seven Map entries',
    (tester) async {
      final messages = captureConsole();
      Task? result;
      await openForm(tester, onResult: (task) => result = task);
      await tester.enterText(
        find.byType(TextFormField).at(0),
        '  Final Task  ',
      );
      await tester.enterText(find.byType(TextFormField).at(1), '7.50');
      await tester.tap(find.text('High'));
      await tester.pumpAndSettle();
      for (final label in [
        'Email Notifications',
        'SMS Notifications',
        'Phone Notifications',
      ]) {
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.byType(DropdownButtonFormField<User>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('John Doe').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save Form'));
      await tester.pumpAndSettle();
      expect(result!.taskName, 'Final Task');
      expect(result!.hourlyRate, 7.5);
      expect(result!.priority, Priority.high);
      expect(result!.emailNotification, isFalse);
      expect(result!.smsNotification, isTrue);
      expect(result!.phoneNotification, isFalse);
      expect(result!.assignedUser, same(User.users.first));

      expect(messages, [
        <String, dynamic>{
          'name': 'Final Task',
          'amount': 7.5,
          'priority': Priority.high,
          'emailNotification': false,
          'smsNotification': true,
          'phoneNotification': false,
          'assignedUser': User.users.first,
        }.toString(),
      ]);
      restoreConsole();
    },
  );

  for (final action in ['Save Form', 'Cancel']) {
    testWidgets('$action disposes both text controllers when dialog closes', (
      tester,
    ) async {
      final messages = captureConsole();
      var returned = false;
      Task? result;
      await openForm(
        tester,
        onResult: (task) {
          returned = true;
          result = task;
        },
      );
      final controllers = tester
          .widgetList<TextFormField>(find.byType(TextFormField))
          .map((field) => field.controller!)
          .toList();
      await tester.tap(find.text(action));
      await tester.pumpAndSettle();
      expect(returned, isTrue);
      expect(find.byType(InputFormDialog), findsNothing);
      for (final controller in controllers) {
        expect(() => controller.addListener(() {}), throwsFlutterError);
      }
      if (action == 'Cancel') {
        expect(result, isNull);
        expect(messages, isEmpty);
        restoreConsole();
      } else {
        expect(result, isNotNull);
        restoreConsole();
      }
    });
  }
}
