import 'package:flutter/material.dart';
import 'package:form_input_demo/models/tasks.dart';
import 'package:form_input_demo/models/users.dart';
import 'package:form_input_demo/widgets/assign_user_dropdown.dart';
import 'package:form_input_demo/widgets/notification_checkbox.dart';
import 'package:form_input_demo/widgets/priority_radius_button.dart';

/// Returns the saved task, or null when the form is cancelled.
Future<Task?> showInputFormDialog(
  BuildContext context, {
  Map<String, dynamic> initialValues = const {},
  Widget? selectionFields,
  Task? existingTask,
}) {
  return showDialog<Task>(
    context: context,
    builder: (_) => InputFormDialog(
      initialValues: initialValues,
      existingTask: existingTask,
    ),
  );
}

class InputFormDialog extends StatefulWidget {
  const InputFormDialog({
    super.key,
    this.initialValues = const {},
    this.existingTask,
  });

  final Task? existingTask;

  final Map<String, dynamic> initialValues;

  @override
  State<InputFormDialog> createState() => _InputFormDialogState();
}

class _InputFormDialogState extends State<InputFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late Priority _priority;
  User? _assignedUser;
  late bool _email;
  late bool _sms;
  late bool _phone;

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      Task(
        taskID: widget.existingTask?.taskID,
        assignedUser: _assignedUser,
        taskName: _nameController.text.trim(),
        hourlyRate: double.parse(_amountController.text.trim()),
        priority: _priority,
        emailNotification: _email,
        smsNotification: _sms,
        phoneNotification: _phone,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    _assignedUser =
        task?.assignedUser ?? widget.initialValues['assignedUser'] as User?;
    _priority =
        task?.priority ??
        widget.initialValues['priority'] as Priority? ??
        Priority.low;
    _email =
        task?.emailNotification ??
        widget.initialValues['emailNotification'] as bool? ??
        false;
    _sms =
        task?.smsNotification ??
        widget.initialValues['smsNotification'] as bool? ??
        false;
    _phone =
        task?.phoneNotification ??
        widget.initialValues['phoneNotification'] as bool? ??
        false;
    _nameController = TextEditingController(
      text:
          task?.taskName ??
          widget.initialValues['name'] as String? ??
          'Sample Task',
    );
    _amountController = TextEditingController(
      text:
          task?.hourlyRate.toString() ??
          widget.initialValues['amount']?.toString() ??
          '5.00',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SizedBox(
        width: 368,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.existingTask == null ? 'Create Task' : 'Edit Task',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Fill in the task details below.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    final length = (value ?? '').trim().runes.length;
                    return length < 5 || length > 20
                        ? 'Enter 5–20 characters.'
                        : null;
                  },
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Task Name',
                    helperText: '5–20 characters',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  validator: (value) {
                    final rate = double.tryParse((value ?? '').trim());
                    return rate == null ||
                            !rate.isFinite ||
                            rate <= 3 ||
                            rate >= 10
                        ? 'Enter a rate greater than 3 and less than 10.'
                        : null;
                  },
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: r'Hourly Rate ($)',
                    helperText: r'More than $3.00 and less than $10.00',
                    helperMaxLines: 2,
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),
                PriorityRadiusButton(
                  initialValue: _priority,
                  onChanged: (value) => _priority = value,
                ),

                const SizedBox(height: 16),
                NotificationCheckbox(
                  email: _email,
                  sms: _sms,
                  phone: _phone,
                  onChanged: (email, sms, phone) {
                    _email = email;
                    _sms = sms;
                    _phone = phone;
                  },
                ),

                const SizedBox(height: 16),
                AssignUserDropDown(
                  initialValue: _assignedUser,
                  onChanged: (user) => _assignedUser = user,
                ),
                const SizedBox(height: 24),
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  spacing: 16,
                  overflowSpacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: _save,
                      child: const Text('Save Form'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
