import 'package:flutter/foundation.dart';

import '../models/crew_task.dart';

class CrewStore extends ChangeNotifier {
  final List<CrewTask> tasks = [
    CrewTask(
      id: '1',
      title: 'Conservation Village Setup',
      description: 'Help set up tables, signage, and conservation partner booths before the gates open.',
      location: 'Conservation Village',
      time: '10:30 AM',
      volunteersNeeded: 4,
      highPriority: true,
      notes: 'Meet Lindsey at Volunteer HQ before heading over.',
      status: TaskStatus.assigned,
      assignees: ['Marcia', 'Alex'],
    ),
    CrewTask(
      id: '2',
      title: 'Restock Volunteer Water',
      description:
          'Bring fresh water and refill coolers to keep our crew hydrated.',
      location: 'Volunteer HQ',
      time: '11:15 AM',
      volunteersNeeded: 2,
    ),
    CrewTask(
      id: '3',
      title: 'Beach Cleanup Supplies',
      description: 'Organize gloves, collection bags, and reusable buckets for the beach cleanup.',
      location: 'South Beach Entrance',
      time: '12:00 PM',
      volunteersNeeded: 3,
    ),
    CrewTask(
      id: '4',
      title: 'Welcome Conservation Partners',
      description: 'Welcome our partners and help them find their booths.',
      location: 'North Gate',
      time: '9:30 AM',
      volunteersNeeded: 0,
      status: TaskStatus.onMyWay,
      assignees: ['Jordan', 'Sam'],
    ),
    CrewTask(
      id: '5',
      title: 'Morning Shoreline Sweep',
      description: 'Collect litter along the shoreline with the morning crew.',
      location: 'South Beach',
      time: '8:00 AM',
      volunteersNeeded: 0,
      status: TaskStatus.completed,
      assignees: ['Taylor'],
    ),
  ];
  int createdCount = 0;
  int get completedCount =>
      tasks.where((t) => t.status == TaskStatus.completed).length - 1;
  void add(CrewTask task) {
    tasks.insert(0, task);
    createdCount++;
    notifyListeners();
  }

  void accept(CrewTask task) {
    if (task.isMine ||
        task.volunteersNeeded == 0 ||
        task.status == TaskStatus.completed) {
      return;
    }
    task.assignees = [...task.assignees, 'Marcia'];
    task.volunteersNeeded--;
    task.status = TaskStatus.assigned;
    notifyListeners();
  }

  void updateStatus(CrewTask task, TaskStatus status) {
    task.status = status;
    notifyListeners();
  }
}
