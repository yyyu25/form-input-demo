import 'package:flutter/material.dart';
import 'package:form_input_demo/models/tasks.dart';

class DisplayFormCard extends StatelessWidget {
  const DisplayFormCard({super.key, this.task, this.onEdit});

  final VoidCallback? onEdit;

  final Task? task;

  @override
  Widget build(BuildContext context) {
    final savedTask = task;
    final notifications = [
      if (savedTask?.emailNotification == true) 'Email',
      if (savedTask?.smsNotification == true) 'SMS',
      if (savedTask?.phoneNotification == true) 'Phone',
    ];

    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: Card.outlined(
        margin: const EdgeInsets.only(top: 16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Submitted Task', style: textTheme.titleMedium),
                  ),
                  if (savedTask != null && onEdit != null)
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (savedTask == null) ...[
                Text('No task submitted yet', style: textTheme.bodyLarge),
                const SizedBox(height: 8),
                const Text('Click New Task to create one.'),
              ] else ...[
                Text(
                  savedTask.taskName,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${savedTask.hourlyRate.toStringAsFixed(2)} / hour',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _detail(context, 'priority', savedTask.priority.name),
                const SizedBox(height: 20),
                _detail(
                  context,
                  'Assigned User',
                  savedTask.assignedUser?.fullName ?? 'Unassigned',
                ),
                const SizedBox(height: 20),
                Text('Notifications', style: textTheme.labelLarge),
                const SizedBox(height: 8),
                if (notifications.isEmpty)
                  const Text('None')
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: notifications
                        .map((notification) => Chip(label: Text(notification)))
                        .toList(),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _detail(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
