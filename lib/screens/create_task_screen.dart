import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/crew_store.dart';
import '../models/crew_task.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key, required this.store});
  final CrewStore store;
  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController(),
      _description = TextEditingController(),
      _location = TextEditingController(),
      _count = TextEditingController(text: '2'),
      _notes = TextEditingController();
  TimeOfDay? _time;
  bool _high = false;
  @override
  void dispose() {
    for (final c in [_title, _description, _location, _count, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Create Task')),
    body: Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Make room for impact.',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Give your crew everything they need to get started.'),
          const SizedBox(height: 28),
          _field(_title, 'Task title'),
          _field(_description, 'What needs to be done?', lines: 3),
          _field(_location, 'Location'),
          FormField<TimeOfDay>(
            validator: (_) => _time == null ? 'Choose a start time' : null,
            builder: (field) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      final value = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 10, minute: 30),
                      );
                      if (value != null) {
                        setState(() => _time = value);
                        field.didChange(value);
                      }
                    },
                    icon: const Icon(Icons.schedule),
                    label: Text(
                      _time == null ? 'Start time' : _time!.format(context),
                    ),
                  ),
                  if (field.hasError)
                    Text(
                      field.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: TextFormField(
              controller: _count,
              decoration: const InputDecoration(
                labelText: 'Number of volunteers needed',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => (int.tryParse(v ?? '') ?? 0) < 1
                  ? 'Enter at least 1 volunteer'
                  : null,
            ),
          ),
          Text('Priority', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Normal')),
              ButtonSegment(
                value: true,
                label: Text('High'),
                icon: Icon(Icons.flag_outlined),
              ),
            ],
            selected: {_high},
            onSelectionChanged: (v) => setState(() => _high = v.first),
          ),
          const SizedBox(height: 20),
          _field(_notes, 'Notes for volunteers', lines: 3, required: false),
          FilledButton(onPressed: _submit, child: const Text('Create Task')),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
  Widget _field(
    TextEditingController controller,
    String label, {
    int lines = 1,
    bool required = true,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
      controller: controller,
      maxLines: lines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: label),
      validator: (v) => required && (v == null || v.trim().isEmpty)
          ? 'Please fill in this field'
          : null,
    ),
  );
  void _submit() {
    if (!_form.currentState!.validate()) return;
    widget.store.add(
      CrewTask(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: _title.text.trim(),
        description: _description.text.trim(),
        location: _location.text.trim(),
        time: _time!.format(context),
        volunteersNeeded: int.parse(_count.text),
        highPriority: _high,
        notes: _notes.text.trim(),
      ),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task created. Your crew is ready to help.'),
      ),
    );
  }
}
