import 'package:flutter/material.dart';

/// Opens a fresh form. A result will be returned when saving is implemented.
Future<Map<String, dynamic>?> showInputFormDialog(
  BuildContext context, {
  Map<String, dynamic> initialValues = const {},
  Widget? selectionFields,
}) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (_) => InputFormDialog(
      initialValues: initialValues,
      selectionFields: selectionFields,
    ),
  );
}

class InputFormDialog extends StatefulWidget {
  const InputFormDialog({
    super.key,
    this.initialValues = const {},
    this.selectionFields,
  });

  final Map<String, dynamic> initialValues;

  /// Optional space for YA's radio, checkbox and User dropdown widgets.
  final Widget? selectionFields;

  @override
  State<InputFormDialog> createState() => _InputFormDialogState();
}

class _InputFormDialogState extends State<InputFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialValues['name'] as String? ?? 'Sample User',
    );
    _amountController = TextEditingController(
      text: widget.initialValues['amount']?.toString() ?? '5.00',
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
                  'New Form',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter your details and preferences.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    helperText: '5–20 characters',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
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
                if (widget.selectionFields != null) ...[
                  const SizedBox(height: 16),
                  widget.selectionFields!,
                ],
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
                    // Validation and result-map submission are the next step.
                    const FilledButton(
                      onPressed: null,
                      child: Text('Save Form'),
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
