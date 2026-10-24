import 'package:flutter/material.dart';
import 'package:form_input_demo/models/tasks.dart';
import 'package:form_input_demo/widgets/display_form_card.dart';
import 'package:form_input_demo/widgets/form_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Form Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Task? _latestTask;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    final task = await showInputFormDialog(context);
                    if (!mounted || task == null) return;
                    setState(() => _latestTask = task);
                  }, // Navigate to form_dialog page.
                  child: const Text('New Form'),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              DisplayFormCard(
                task: _latestTask,
                onEdit: () async {
                  final task = await showInputFormDialog(
                    context,
                    existingTask: _latestTask,
                  );
                  if (!mounted || task == null) return;
                  setState(() => _latestTask = task);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
