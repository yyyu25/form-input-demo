import 'package:flutter/material.dart';

import 'widgets/form_dialog.dart';

// Standalone preview for this increment, separate from YA's Home page.
// Run: flutter run -t lib/form_dialog_preview.dart
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
      ),
      home: const _DialogPreview(),
    ),
  );
}

class _DialogPreview extends StatelessWidget {
  const _DialogPreview();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('form input')),
      body: Center(
        child: FilledButton(
          onPressed: () => showInputFormDialog(context),
          child: const Text('New Form'),
        ),
      ),
    );
  }
}
