import 'package:flutter/material.dart';

class NotificationCheckbox extends StatefulWidget {
  const NotificationCheckbox({
    super.key,
    this.email = false,
    this.sms = false,
    this.phone = false,
    this.onChanged,
  });

  final bool email;
  final bool sms;
  final bool phone;
  final void Function(bool email, bool sms, bool phone)? onChanged;

  @override
  State<NotificationCheckbox> createState() => _NotificationCheckboxState();
}

class _NotificationCheckboxState extends State<NotificationCheckbox> {
  late bool _emailNotifications = widget.email;
  late bool _smsNotifications = widget.sms;
  late bool _phoneNotifications = widget.phone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Notification Preferences:'),
          const SizedBox(height: 8),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Email Notifications'),
            value: _emailNotifications,
            onChanged: (value) {
              setState(() {
                _emailNotifications = value ?? false;
              });
              widget.onChanged?.call(
                _emailNotifications,
                _smsNotifications,
                _phoneNotifications,
              );
            },
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('SMS Notifications'),
            value: _smsNotifications,
            onChanged: (value) {
              setState(() {
                _smsNotifications = value ?? false;
              });
              widget.onChanged?.call(
                _emailNotifications,
                _smsNotifications,
                _phoneNotifications,
              );
            },
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Phone Notifications'),
            value: _phoneNotifications,
            onChanged: (value) {
              setState(() {
                _phoneNotifications = value ?? false;
              });
              widget.onChanged?.call(
                _emailNotifications,
                _smsNotifications,
                _phoneNotifications,
              );
            },
          ),
        ],
      ),
    );
  }
}
