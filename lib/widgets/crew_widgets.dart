import 'package:flutter/material.dart';

import '../models/crew_task.dart';
import '../theme/app_theme.dart';

class OceanHeader extends StatelessWidget {
  const OceanHeader({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) => Container(
    height: 80,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    clipBehavior: Clip.hardEdge,
    decoration: BoxDecoration(
      color: CrewColors.navy,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Stack(
      children: [
        const Positioned(
          right: 24,
          top: -24,
          child: Icon(Icons.waves_rounded, size: 120, color: Color(0x1027D1D1)),
        ),
        Row(
          children: [
            const Icon(Icons.waves_rounded, color: Color(0xFF32D7D3), size: 30),
            const SizedBox(width: 10),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final showBadge =
                      label == 'Staff Dashboard' &&
                      constraints.maxWidth >=
                          205 * MediaQuery.textScalerOf(context).scale(1);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Flexible(
                            child: Text(
                              'RTO CREW',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                          if (showBadge) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF32D7D3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'STAFF',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: CrewColors.navy,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Text(
                        'Tortuga Music Festival',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFFC7E4EA),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 6),
            const SizedBox(
              width: 36,
              height: 44,
              child: Tooltip(
                message: 'Notifications',
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C9CC),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: CrewColors.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 13),
              child: Text(
                subtitle!,
                style: const TextStyle(color: Color(0xFF6D818D), fontSize: 13),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.task, {super.key});

  final CrewTask task;

  @override
  Widget build(BuildContext context) {
    final completed = task.status == TaskStatus.completed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: completed
            ? const Color(0xFFE2F5EC)
            : task.status == TaskStatus.onMyWay
            ? const Color(0xFFFFF1DC)
            : const Color(0xFFE6F7F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        task.statusLabel.toUpperCase(),
        style: TextStyle(
          color: completed
              ? const Color(0xFF277A59)
              : task.status == TaskStatus.onMyWay
              ? const Color(0xFF925B15)
              : CrewColors.teal,
          fontSize: 9.5,
          letterSpacing: .5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onOpen,
    this.action,
    this.showNotes = false,
  });

  final CrewTask task;
  final VoidCallback onOpen;
  final Widget? action;
  final bool showNotes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onOpen,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFDCE8EC)),
              boxShadow: [
                BoxShadow(
                  color: CrewColors.navy.withValues(alpha: .035),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Small visual task marker
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: task.highPriority
                            ? const Color(0xFFFFF1E7)
                            : const Color(0xFFE8F7F8),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(
                        task.highPriority
                            ? Icons.priority_high_rounded
                            : Icons.checklist_rounded,
                        color: task.highPriority
                            ? const Color(0xFFB76028)
                            : CrewColors.teal,
                        size: 21,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: CrewColors.navy,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              StatusBadge(task),
                              if (task.highPriority) ...[
                                const SizedBox(width: 7),
                                const Text(
                                  'HIGH PRIORITY',
                                  style: TextStyle(
                                    color: Color(0xFFA45424),
                                    fontSize: 9,
                                    letterSpacing: .4,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF8198A4),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: MetaLine(Icons.schedule_rounded, task.time),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MetaLine(Icons.place_outlined, task.location),
                    ),
                  ],
                ),

                if (task.volunteersNeeded > 0) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.groups_2_outlined,
                        size: 18,
                        color: CrewColors.teal,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '${task.volunteersNeeded} volunteers needed',
                        style: const TextStyle(
                          color: CrewColors.navy,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],

                if (showNotes && task.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F8F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      task.notes,
                      style: const TextStyle(
                        color: Color(0xFF526B7B),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],

                if (action != null) ...[const SizedBox(height: 14), action!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MetaLine extends StatelessWidget {
  const MetaLine(this.icon, this.text, {super.key});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: CrewColors.teal),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF526B7B),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class DashboardTaskCard extends StatelessWidget {
  const DashboardTaskCard({
    super.key,
    required this.task,
    required this.onOpen,
  });
  final CrewTask task;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: task.highPriority
              ? const Color(0xFFE9C6A9)
              : const Color(0xFFDCE8EC),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (task.highPriority) ...[
                    const Icon(
                      Icons.priority_high_rounded,
                      size: 18,
                      color: Color(0xFFB76028),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Color(0xFF8198A4),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 10,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  StatusBadge(task),
                  Text(
                    '${task.volunteersNeeded} still needed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: task.highPriority
                          ? const Color(0xFFA45424)
                          : CrewColors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: MetaLine(Icons.schedule_rounded, task.time)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: MetaLine(Icons.place_outlined, task.location),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class DashboardAssignmentCard extends StatelessWidget {
  const DashboardAssignmentCard({
    super.key,
    required this.task,
    required this.onOpen,
  });
  final CrewTask task;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.assignees.join(' & '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF526B7B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    StatusBadge(task),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF8198A4)),
            ],
          ),
        ),
      ),
    ),
  );
}
