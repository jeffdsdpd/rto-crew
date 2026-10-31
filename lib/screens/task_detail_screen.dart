import 'package:flutter/material.dart';

import '../data/crew_store.dart';
import '../models/crew_task.dart';
import '../widgets/crew_widgets.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({
    super.key,
    required this.store,
    required this.task,
    required this.staff,
  });
  final CrewStore store;
  final CrewTask task;
  final bool staff;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) => Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              StatusBadge(task),
              if (task.highPriority) ...[
                const SizedBox(width: 12),
                const Text(
                  'HIGH PRIORITY',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Text(task.title, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 24),
          MetaLine(Icons.schedule, task.time),
          const SizedBox(height: 12),
          MetaLine(Icons.place_outlined, task.location),
          const SizedBox(height: 12),
          MetaLine(
            Icons.people_outline,
            '${task.volunteersNeeded} volunteers still needed',
          ),
          const SectionTitle('The task'),
          Text(task.description),
          if (task.notes.isNotEmpty) ...[
            const SectionTitle('Notes for volunteers'),
            Text(task.notes),
          ],
          const SectionTitle('Your crew'),
          Text(
            task.assignees.isEmpty
                ? 'No volunteers assigned yet.'
                : task.assignees.join(' • '),
          ),
          const SizedBox(height: 30),
          if (!staff && task.status != TaskStatus.completed)
            if (!task.isMine && task.volunteersNeeded > 0)
              FilledButton(
                onPressed: () => store.accept(task),
                child: const Text('I Can Help'),
              )
            else if (task.isMine) ...[
              if (task.status != TaskStatus.onMyWay)
                FilledButton.icon(
                  onPressed: () => store.updateStatus(task, TaskStatus.onMyWay),
                  icon: const Icon(Icons.directions_walk),
                  label: const Text("I'm On My Way"),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => store.updateStatus(task, TaskStatus.completed),
                icon: const Icon(Icons.check_circle_outline),
                label: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text('Mark Complete'),
                ),
              ),
            ],
          if (task.status == TaskStatus.completed)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('✓ Task complete. Thank you for making an impact!'),
              ),
            ),
        ],
      ),
    ),
  );
}
