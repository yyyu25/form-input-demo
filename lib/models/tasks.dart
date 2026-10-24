import 'package:form_input_demo/widgets/priority_radius_button.dart';
import 'package:form_input_demo/models/users.dart';

class Task {
  static int taskNumber = 0;
  final int taskID;
  final String taskName;
  final double hourlyRate;
  final Priority priority;
  final User? assignedUser;
  final bool emailNotification;
  final bool smsNotification;
  final bool phoneNotification;

  Task({
    int? taskID,
    this.assignedUser,
    required this.taskName,
    required this.hourlyRate,
    required this.priority,
    required this.emailNotification,
    required this.smsNotification,
    required this.phoneNotification,
  }) : taskID = taskID ?? ++taskNumber;
}
