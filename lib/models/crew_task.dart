enum TaskStatus { open, assigned, onMyWay, completed }

class CrewTask {
  CrewTask({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.time,
    required this.volunteersNeeded,
    this.highPriority = false,
    this.notes = '',
    this.status = TaskStatus.open,
    this.assignees = const [],
  });
  final String id, title, description, location, time, notes;
  final bool highPriority;
  int volunteersNeeded;
  TaskStatus status;
  List<String> assignees;
  bool get isMine => assignees.contains('Marcia');
  String get statusLabel => switch (status) {
    TaskStatus.open => 'Open',
    TaskStatus.assigned => 'Assigned',
    TaskStatus.onMyWay => 'On my way',
    TaskStatus.completed => 'Completed',
  };
}
