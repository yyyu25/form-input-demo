import 'package:flutter/material.dart';

enum Priority { low, medium, high }

class PriorityRadiusButton extends StatefulWidget {
  const PriorityRadiusButton({
    super.key,
    this.initialValue = Priority.low,
    this.onChanged,
  });

  final Priority initialValue;
  final ValueChanged<Priority>? onChanged;

  @override
  State<PriorityRadiusButton> createState() => _PriorityRadiusButtonState();
}

class _PriorityRadiusButtonState extends State<PriorityRadiusButton> {
  late Priority _priority = widget.initialValue;

  void _selectPriority(Priority? value) {
    if (value == null) return;

    setState(() {
      _priority = value;
    });
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Priority:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            RadioMenuButton<Priority>(
              value: Priority.low,
              groupValue: _priority,
              onChanged: _selectPriority,
              child: const Text('Low'),
            ),
            RadioMenuButton<Priority>(
              value: Priority.medium,
              groupValue: _priority,
              onChanged: _selectPriority,
              child: const Text('Medium'),
            ),
            RadioMenuButton<Priority>(
              value: Priority.high,
              groupValue: _priority,
              onChanged: _selectPriority,
              child: const Text('High'),
            ),
          ],
        ),
      ],
    );
  }
}
