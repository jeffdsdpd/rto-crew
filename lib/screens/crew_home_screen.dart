import 'package:flutter/material.dart';

import '../data/crew_store.dart';
import '../models/crew_task.dart';
import '../theme/app_theme.dart';
import '../widgets/crew_widgets.dart';
import 'create_task_screen.dart';
import 'task_detail_screen.dart';

class CrewHomeScreen extends StatefulWidget {
  const CrewHomeScreen({super.key, required this.store, required this.staff});
  final CrewStore store;
  final bool staff;
  @override
  State<CrewHomeScreen> createState() => _CrewHomeScreenState();
}

class _CrewHomeScreenState extends State<CrewHomeScreen> {
  int _tab = 0;
  CrewStore get store => widget.store;
  bool get staff => widget.staff;
  void _open(CrewTask task) => Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => TaskDetailScreen(store: store, task: task, staff: staff),
    ),
  );
  Future<void> _create() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => CreateTaskScreen(store: store)),
    );
    if (mounted) setState(() => _tab = 0);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        toolbarHeight: staff && _tab == 0 ? 36 : null,
        title: Text(
          staff ? 'Staff Crew' : 'Volunteer Crew',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          tooltip: 'Switch experience',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFD4F2EF),
              child: Icon(Icons.waves, color: CrewColors.teal, size: 22),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            key: ValueKey('$staff-$_tab'),
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
            children: _content(),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: staff ? 64 : null,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorColor: const Color(0xFFD4F2EF),
        selectedIndex: _tab,
        onDestinationSelected: (v) => setState(() => _tab = v),
        destinations: staff
            ? const [
                NavigationDestination(
                  icon: Icon(Icons.space_dashboard_outlined),
                  selectedIcon: Icon(Icons.space_dashboard),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.checklist_rounded),
                  label: 'Tasks',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Volunteers',
                ),
                NavigationDestination(icon: Icon(Icons.waves), label: 'Impact'),
              ]
            : const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.checklist_rounded),
                  label: 'My Tasks',
                ),
                NavigationDestination(icon: Icon(Icons.waves), label: 'Impact'),
              ],
      ),
    ),
  );

  List<Widget> _content() {
    if ((staff && _tab == 3) || (!staff && _tab == 2)) return _impact();
    if (staff && _tab == 2) return _volunteers();
    if (staff && _tab == 1) {
      return [
        Text('Tasks', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        const Text('Every task is a chance to make waves.'),
        const SizedBox(height: 20),
        _createButton(),
        const SectionTitle('All Tasks'),
        ...store.tasks.map(_card),
      ];
    }
    if (!staff && _tab == 1) {
      return [
        Text('My Tasks', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        const Text('Your next steps for a healthier ocean.'),
        const SizedBox(height: 22),
        ..._myTasks(),
      ];
    }
    return staff ? _dashboard() : _volunteerHome();
  }

  Widget _createButton() => FilledButton.icon(
    onPressed: _create,
    icon: const Icon(Icons.add),
    label: const Text('Create Task'),
  );

  List<Widget> _dashboard() => [
    const OceanHeader(label: 'Staff Dashboard'),
    const SizedBox(height: 14),
    Text(
      'Good morning, Lindsey',
      style: Theme.of(context).textTheme.titleLarge,
    ),
    const SizedBox(height: 2),
    const Text("Here's what your crew needs today."),
    const SizedBox(height: 12),
    FilledButton(
      onPressed: _create,
      style: FilledButton.styleFrom(
        backgroundColor: CrewColors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Row(
        children: [
          Icon(Icons.add, size: 22),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'WHAT NEEDS TO GET DONE?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.mic_none_rounded, size: 22),
        ],
      ),
    ),
    const SizedBox(height: 12),
    _operationsSummary([
      (
        'OPEN',
        '${12 + store.createdCount - store.completedCount}',
        Icons.assignment_outlined,
      ),
      ('ACTIVE', '28', Icons.people_outline),
      (
        'IN PROGRESS',
        '${6 + store.tasks.where((t) => t.status == TaskStatus.onMyWay && t.isMine).length}',
        Icons.timelapse,
      ),
      ('DONE TODAY', '${17 + store.completedCount}', Icons.task_alt),
    ]),
    _dashboardTitle(
      'Needs Attention',
      subtitle: 'Tasks that still need people.',
    ),
    ...store.tasks
        .where(
          (t) => t.volunteersNeeded > 0 && t.status != TaskStatus.completed,
        )
        .map(
          (task) => DashboardTaskCard(task: task, onOpen: () => _open(task)),
        ),
    _dashboardTitle('Recently Assigned'),
    ...store.tasks
        .where((t) => t.assignees.isNotEmpty)
        .take(3)
        .map(
          (task) =>
              DashboardAssignmentCard(task: task, onOpen: () => _open(task)),
        ),
  ];

  Widget _dashboardTitle(String title, {String? subtitle}) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (subtitle != null)
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Color(0xFF526B7B)),
          ),
      ],
    ),
  );

  Widget _operationsSummary(List<(String, String, IconData)> items) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDCE8EC)),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0)
                  const VerticalDivider(width: 1, color: Color(0xFFDCE8EC)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      children: [
                        Icon(items[i].$3, size: 18, color: CrewColors.teal),
                        const SizedBox(height: 2),
                        Text(
                          items[i].$2,
                          style: const TextStyle(
                            fontSize: 24,
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                            color: CrewColors.navy,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          items[i].$1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF526B7B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );

  List<Widget> _volunteerHome() => [
    const OceanHeader(),
    const SizedBox(height: 26),
    Text('Hey Marcia!', style: Theme.of(context).textTheme.headlineLarge),
    const SizedBox(height: 6),
    const Text(
      'Ready to make an impact?',
      style: TextStyle(fontSize: 17, color: CrewColors.blue),
    ),
    const SectionTitle('My Tasks'),
    ..._myTasks(),
    const SectionTitle(
      'Available Tasks',
      subtitle: 'Find your next way to help.',
    ),
    ...store.tasks
        .where(
          (t) =>
              !t.isMine &&
              t.volunteersNeeded > 0 &&
              t.status != TaskStatus.completed,
        )
        .map(
          (task) => TaskCard(
            task: task,
            onOpen: () => _open(task),
            action: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  store.accept(task);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'You’re on the crew! Find this task in My Tasks.',
                      ),
                    ),
                  );
                },
                child: const Text('I Can Help'),
              ),
            ),
          ),
        ),
  ];

  List<Widget> _myTasks() {
    final tasks = store.tasks.where((t) => t.isMine).toList();
    if (tasks.isEmpty) {
      return [
        const Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'No tasks yet. Choose an available task to join the crew.',
            ),
          ),
        ),
      ];
    }
    return tasks
        .map(
          (task) => TaskCard(
            task: task,
            onOpen: () => _open(task),
            showNotes: true,
            action: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  onPressed: () => _open(task),
                  child: const Text('View Details'),
                ),
                if (task.status != TaskStatus.completed) ...[
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => store.updateStatus(
                      task,
                      task.status == TaskStatus.onMyWay
                          ? TaskStatus.completed
                          : TaskStatus.onMyWay,
                    ),
                    icon: Icon(
                      task.status == TaskStatus.onMyWay
                          ? Icons.check
                          : Icons.directions_walk,
                    ),
                    label: Text(
                      task.status == TaskStatus.onMyWay
                          ? 'Mark Complete'
                          : "I'm On My Way",
                    ),
                  ),
                ],
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _card(CrewTask task) =>
      TaskCard(task: task, onOpen: () => _open(task));

  Widget _stats(List<(String, String, IconData)> items) => LayoutBuilder(
    builder: (context, constraints) => Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items
          .map(
            (item) => SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(item.$3, color: CrewColors.teal, size: 23),
                      const SizedBox(height: 12),
                      Text(
                        item.$2,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        item.$1,
                        style: const TextStyle(
                          color: Color(0xFF526B7B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );

  List<Widget> _volunteers() {
    final names = store.tasks.expand((t) => t.assignees).toSet().toList()
      ..sort();
    return [
      Text('Volunteers', style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 8),
      const Text('Meet the people behind the impact.'),
      const SectionTitle('Crew Assignments'),
      ...names.map(
        (name) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFD4F2EF),
                        child: Text(
                          name[0],
                          style: const TextStyle(color: CrewColors.teal),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  ...store.tasks
                      .where((t) => t.assignees.contains(name))
                      .map(
                        (task) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(task.title),
                          subtitle: Text(task.statusLabel),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _open(task),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _impact() {
    final completed = store.tasks
        .where((t) => t.status == TaskStatus.completed && (staff || t.isMine))
        .toList();
    return [
      const OceanHeader(label: 'Small actions. Ocean-sized impact.'),
      const SectionTitle('Your Impact'),
      Text(
        staff
            ? 'Together, we make a difference.'
            : 'Thanks for showing up, Marcia.',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 20),
      _stats(
        staff
            ? [
                (
                  'Completed Today',
                  '${17 + store.completedCount}',
                  Icons.task_alt,
                ),
                ('Active Volunteers', '28', Icons.volunteer_activism_outlined),
              ]
            : [
                ('Tasks Completed', '${completed.length}', Icons.task_alt),
                (
                  'Tasks Joined',
                  '${store.tasks.where((t) => t.isMine).length}',
                  Icons.volunteer_activism_outlined,
                ),
              ],
      ),
      const SectionTitle('Completed Tasks'),
      if (completed.isEmpty)
        const Card(
          child: Padding(
            padding: EdgeInsets.all(22),
            child: Text(
              'Your impact starts with one task. Completed tasks will appear here.',
            ),
          ),
        ),
      ...completed.map(_card),
      const SizedBox(height: 20),
      const Text(
        'For the music. For the community. For our ocean.',
        textAlign: TextAlign.center,
        style: TextStyle(color: CrewColors.teal),
      ),
    ];
  }
}
