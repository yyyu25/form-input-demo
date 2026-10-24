import 'package:flutter/material.dart';
import 'package:form_input_demo/models/users.dart';

class AssignUserDropDown extends StatelessWidget {
  const AssignUserDropDown({super.key, this.initialValue, this.onChanged});

  final User? initialValue;
  final ValueChanged<User?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<User>(
      initialValue: initialValue == null
          ? null
          : User.users.firstWhere(
              (user) => user.userID == initialValue!.userID,
            ),
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Assign to user',
        border: OutlineInputBorder(),
      ),
      hint: const Text('Select a user'),
      items: User.users
          .map(
            (user) =>
                DropdownMenuItem<User>(value: user, child: Text(user.fullName)),
          )
          .toList(),
      onChanged: (user) => onChanged?.call(user),
    );
  }
}
