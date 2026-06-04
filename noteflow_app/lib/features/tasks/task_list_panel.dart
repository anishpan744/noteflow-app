import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/design/tokens.dart';
import '../../models/category.dart';
import '../../models/enums.dart';
import '../../models/task.dart';
import '../categories/category_providers.dart';
import 'task_providers.dart';

/// Embedded panel showing the selected day's tasks, sorted by time then priority.
class TaskListPanel extends ConsumerWidget {
  const TaskListPanel({super.key, required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt        = Theme.of(context).textTheme;
    final tasksAsync = ref.watch(tasksForDayProvider(date));
    final cats      = ref.watch(categoriesProvider).valueOrNull ?? [];

    return Container(
      decoration: const BoxDecoration(
        color: kBg1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: kGlassBorder)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: kBg3,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Date header + count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(DateFormat('EEE, MMM d').format(date),
                    style: tt.headlineSmall),
                const SizedBox(width: 8),
                tasksAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (tasks) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: kViolet.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('${tasks.length}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: kViolet,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Task list
          Expanded(
            child: tasksAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                    color: kViolet, strokeWidth: 1.5),
              ),
              error: (e, _) => Center(
                child: Text('Error: $e',
                    style: tt.bodySmall?.copyWith(color: kCrimson)),
              ),
              data: (tasks) {
                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(PhosphorIconsRegular.checkCircle,
                            color: kTextMuted, size: 40),
                        const SizedBox(height: 8),
                        Text('No tasks for this day', style: tt.bodySmall),
                      ],
                    ),
                  );
                }
                final sorted = [...tasks]..sort(_byTimeThenPriority);
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                  itemCount: sorted.length,
                  itemBuilder: (_, i) =>
                      _TaskListItem(task: sorted[i], cats: cats),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _byTimeThenPriority(Task a, Task b) {
    final at = a.dueTime ?? '99:99';
    final bt = b.dueTime ?? '99:99';
    final cmp = at.compareTo(bt);
    if (cmp != 0) return cmp;
    return b.priority.index.compareTo(a.priority.index);
  }
}

// ── Task list item ────────────────────────────────────────────────────────────

class _TaskListItem extends ConsumerWidget {
  const _TaskListItem({required this.task, required this.cats});
  final Task task;
  final List<Category> cats;

  Color get _categoryColor {
    if (task.categoryIds.isEmpty) return kViolet;
    final cat = cats.where((c) => c.id == task.categoryIds.first).firstOrNull;
    if (cat == null) return kViolet;
    try {
      return Color(int.parse('FF${cat.colorHex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return kViolet;
    }
  }

  Color get _priorityColor => switch (task.priority) {
        TaskPriority.none     => kTextMuted,
        TaskPriority.low      => kTeal,
        TaskPriority.medium   => kAmber,
        TaskPriority.high     => kViolet,
        TaskPriority.critical => kCrimson,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt   = Theme.of(context).textTheme;
    final done = task.status == TaskStatus.done;
    final overdue = task.isOverdue;
    final barColor = overdue ? kCrimson : _categoryColor;

    return GestureDetector(
      onTap: () => context.push('/tasks/${task.id}/edit'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: kBg2,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: barColor, width: 3)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Status toggle
            GestureDetector(
              onTap: () {
                final next = done ? TaskStatus.notStarted : TaskStatus.done;
                ref
                    .read(taskControllerProvider.notifier)
                    .updateStatus(task.id, next);
              },
              child: Icon(
                done
                    ? PhosphorIconsFill.checkCircle
                    : PhosphorIconsRegular.circle,
                color: done ? kTeal : kTextMuted,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Title + subtask progress
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.titleSmall?.copyWith(
                      color: overdue
                          ? kCrimson
                          : (done ? kTextMuted : kTextPrimary),
                      decoration:
                          done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (task.subTasks.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: task.subTaskProgress,
                              minHeight: 3,
                              backgroundColor: kBg3,
                              valueColor:
                                  const AlwaysStoppedAnimation(kNeon),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${task.subTasks.where((s) => s.isCompleted).length}/${task.subTasks.length}',
                          style: const TextStyle(
                              fontSize: 10, color: kTextMuted),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Time chip
            if (task.dueTime != null) ...[
              const SizedBox(width: 8),
              Text(task.dueTime!,
                  style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: kTextMuted)),
            ],

            // Priority dot
            if (task.priority != TaskPriority.none) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _priorityColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],

            // Recurring badge
            if (task.recurrence != null) ...[
              const SizedBox(width: 6),
              const Icon(PhosphorIconsRegular.repeat,
                  size: 12, color: kTextMuted),
            ],
          ],
        ),
      ),
    );
  }
}
