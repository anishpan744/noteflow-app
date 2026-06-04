import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/design/tokens.dart';
import '../../core/utils/debouncer.dart';
import '../../core/widgets/color_flag_chip.dart';
import '../../data/repositories/task_repository.dart';
import '../../models/enums.dart';
import '../../models/sub_task.dart';
import '../../models/task.dart';
import '../categories/category_providers.dart';
import 'recurrence_picker_widget.dart';
import 'task_providers.dart';

class TaskEditorScreen extends ConsumerStatefulWidget {
  const TaskEditorScreen({super.key, required this.taskId});
  final String taskId;

  @override
  ConsumerState<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends ConsumerState<TaskEditorScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  final _subCtrl   = TextEditingController();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  Task? _task;
  bool _initialized   = false;
  bool _recurOpen     = false;
  bool _saving        = false;
  bool _saved         = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl.addListener(_onChanged);
    _descCtrl.addListener(_onChanged);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _subCtrl.dispose();
    super.dispose();
  }

  void _initTask(Task task) {
    if (_initialized) return;
    _initialized = true;
    _task = task;
    _titleCtrl.text = task.title;
    _descCtrl.text  = task.description;
    _recurOpen = task.recurrence != null;
  }

  void _onChanged() {
    if (!_initialized) return;
    setState(() { _saving = true; _saved = false; });
    _debouncer.run(_save);
  }

  Future<void> _save() async {
    if (!mounted || _task == null) return;
    final updated = _task!.copyWith(
      title:       _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      updatedAt:   DateTime.now(),
    );
    _task = updated;
    await ref.read(taskControllerProvider.notifier).save(updated);
    if (mounted) setState(() { _saving = false; _saved = true; });
  }

  void _patch(Task updated) {
    _task = updated;
    ref.read(taskControllerProvider.notifier).save(updated);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Load existing task on first build
    final existing = ref.watch(
      StreamProvider.autoDispose<Task?>((ref) =>
          ref.watch(taskRepositoryProvider).watchById(widget.taskId)),
    ).valueOrNull;

    if (existing != null && !_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _initTask(existing));
      });
    } else if (!_initialized && _task == null) {
      _initialized = true;
      final now = DateTime.now();
      _task = Task(
        id: widget.taskId, title: '', createdAt: now, updatedAt: now,
      );
    }

    final tt   = Theme.of(context).textTheme;
    final task = _task;
    final cats = ref.watch(categoriesProvider).valueOrNull ?? [];

    return Scaffold(
      backgroundColor: kBg0,
      appBar: AppBar(
        backgroundColor: kBg0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: kTextPrimary),
          onPressed: () {
            _debouncer.dispose();
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        title: Text(_titleCtrl.text.isEmpty ? 'New Task' : _titleCtrl.text,
            style: tt.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          if (_saving || _saved)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text(_saving ? 'Saving…' : 'Saved ✓',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'JetBrainsMono',
                      color: _saving ? kTextMuted : kTeal,
                    )),
              ),
            ),
          IconButton(
            icon: const Icon(PhosphorIconsRegular.trash, color: kCrimson, size: 20),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: task == null
          ? const Center(
              child: CircularProgressIndicator(color: kViolet, strokeWidth: 1.5))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              children: [
                // Title
                TextField(
                  controller: _titleCtrl,
                  style: const TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: kTextPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Task title',
                    hintStyle: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: kTextMuted,
                    ),
                    border: InputBorder.none,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 8),

                // Description
                TextField(
                  controller: _descCtrl,
                  style: tt.bodyMedium,
                  maxLines: 3,
                  minLines: 1,
                  decoration: const InputDecoration(
                    hintText: 'Add a description…',
                    hintStyle: TextStyle(color: kTextMuted, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 16),

                // Date + time row
                Row(
                  children: [
                    Expanded(
                      child: _PillButton(
                        icon: PhosphorIconsRegular.calendarBlank,
                        label: task.dueDate != null
                            ? DateFormat('MMM d, yyyy').format(task.dueDate!)
                            : 'Set date',
                        active: task.dueDate != null,
                        onTap: () => _pickDate(context, task),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PillButton(
                        icon: PhosphorIconsRegular.clock,
                        label: task.dueTime ?? 'Set time',
                        active: task.dueTime != null,
                        onTap: () => _pickTime(context, task),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Priority
                Text('Priority', style: tt.labelMedium?.copyWith(color: kTextMuted)),
                const SizedBox(height: 8),
                _PrioritySelector(
                  value: task.priority,
                  onChanged: (p) => _patch(task.copyWith(priority: p)),
                ),
                const SizedBox(height: 20),

                // Status
                Text('Status', style: tt.labelMedium?.copyWith(color: kTextMuted)),
                const SizedBox(height: 8),
                _StatusSelector(
                  value: task.status,
                  onChanged: (s) => _patch(task.copyWith(status: s)),
                ),
                const SizedBox(height: 20),

                // Categories
                if (cats.isNotEmpty) ...[
                  Text('Categories',
                      style: tt.labelMedium?.copyWith(color: kTextMuted)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: cats.map((c) {
                      final selected = task.categoryIds.contains(c.id);
                      Color color;
                      try {
                        color = Color(int.parse(
                            'FF${c.colorHex.replaceAll('#', '')}', radix: 16));
                      } catch (_) {
                        color = kViolet;
                      }
                      return ColorFlagChip(
                        label: c.name,
                        color: color,
                        selected: selected,
                        small: true,
                        onTap: () {
                          final ids = List<String>.from(task.categoryIds);
                          selected ? ids.remove(c.id) : ids.add(c.id);
                          _patch(task.copyWith(categoryIds: ids));
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],

                // Sub-tasks
                _SubTasksSection(
                  task: task,
                  controller: _subCtrl,
                  onToggle: (id) => ref
                      .read(taskControllerProvider.notifier)
                      .toggleSubTask(task, id),
                  onAdd: (title) {
                    ref
                        .read(taskControllerProvider.notifier)
                        .addSubTask(task, title);
                    _subCtrl.clear();
                  },
                  onDelete: (id) {
                    final subs = task.subTasks
                        .where((s) => s.id != id)
                        .toList();
                    _patch(task.copyWith(subTasks: subs));
                  },
                ),
                const SizedBox(height: 20),

                // Recurrence
                Row(
                  children: [
                    Text('Repeat',
                        style: tt.headlineSmall?.copyWith(fontSize: 16)),
                    const Spacer(),
                    Switch(
                      value: _recurOpen,
                      activeColor: kViolet,
                      onChanged: (on) {
                        setState(() => _recurOpen = on);
                        if (!on) _patch(task.copyWith(recurrence: null));
                      },
                    ),
                  ],
                ),
                if (_recurOpen)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: RecurrencePickerWidget(
                      initial: task.recurrence,
                      onChanged: (r) => _patch(task.copyWith(recurrence: r)),
                    ),
                  ),
              ],
            ),
    );
  }

  Future<void> _pickDate(BuildContext context, Task task) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: task.dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) _patch(task.copyWith(dueDate: picked));
  }

  Future<void> _pickTime(BuildContext context, Task task) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final hh = picked.hour.toString().padLeft(2, '0');
      final mm = picked.minute.toString().padLeft(2, '0');
      _patch(task.copyWith(dueTime: '$hh:$mm'));
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kBg2,
        title: Text('Delete task?', style: Theme.of(ctx).textTheme.titleMedium),
        content: Text('This action cannot be undone.',
            style: Theme.of(ctx).textTheme.bodySmall),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: kTextSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: kCrimson)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      // ignore: use_build_context_synchronously
      final nav = Navigator.of(context);
      await ref.read(taskControllerProvider.notifier).delete(widget.taskId);
      if (mounted) nav.pop();
    }
  }
}

// ── Pill button ───────────────────────────────────────────────────────────────

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });
  final PhosphorIconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: kBg2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? kNeon.withValues(alpha: 0.5) : kGlassBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: active ? kNeon : kTextMuted),
            const SizedBox(width: 8),
            Flexible(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: active ? kTextPrimary : kTextSecondary,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Priority selector ─────────────────────────────────────────────────────────

class _PrioritySelector extends StatelessWidget {
  const _PrioritySelector({required this.value, required this.onChanged});
  final TaskPriority value;
  final ValueChanged<TaskPriority> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TaskPriority.values.map((p) {
        final sel = p == value;
        final (label, color) = switch (p) {
          TaskPriority.none     => ('None', kTextMuted),
          TaskPriority.low      => ('Low', kTeal),
          TaskPriority.medium   => ('Med', kAmber),
          TaskPriority.high     => ('High', kViolet),
          TaskPriority.critical => ('Crit', kCrimson),
        };
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(p),
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: sel ? color.withValues(alpha: 0.18) : kBg2,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: sel ? color : kGlassBorder),
              ),
              child: Center(
                child: Text(label,
                    style: TextStyle(
                      fontSize: 11,
                      color: sel ? color : kTextSecondary,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                    )),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Status selector ───────────────────────────────────────────────────────────

class _StatusSelector extends StatelessWidget {
  const _StatusSelector({required this.value, required this.onChanged});
  final TaskStatus value;
  final ValueChanged<TaskStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TaskStatus.values.map((s) {
          final sel = s == value;
          final (label, color) = switch (s) {
            TaskStatus.notStarted => ('Not Started', kTextMuted),
            TaskStatus.inProgress => ('In Progress', kNeon),
            TaskStatus.blocked    => ('Blocked', kAmber),
            TaskStatus.done       => ('Done', kTeal),
            TaskStatus.cancelled  => ('Cancelled', kCrimson),
          };
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(s),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: sel ? color.withValues(alpha: 0.18) : kBg2,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sel ? color : kGlassBorder),
                ),
                child: Text(label,
                    style: TextStyle(
                      fontSize: 12,
                      color: sel ? color : kTextSecondary,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                    )),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Sub-tasks section ─────────────────────────────────────────────────────────

class _SubTasksSection extends StatelessWidget {
  const _SubTasksSection({
    required this.task,
    required this.controller,
    required this.onToggle,
    required this.onAdd,
    required this.onDelete,
  });
  final Task task;
  final TextEditingController controller;
  final void Function(String subTaskId) onToggle;
  final void Function(String title) onAdd;
  final void Function(String subTaskId) onDelete;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kBg1,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGlassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Sub-tasks', style: tt.headlineSmall?.copyWith(fontSize: 16)),
              const Spacer(),
              if (task.subTasks.isNotEmpty)
                Text(
                  '${task.subTasks.where((s) => s.isCompleted).length}/${task.subTasks.length}',
                  style: const TextStyle(fontSize: 12, color: kTextMuted),
                ),
            ],
          ),
          if (task.subTasks.isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: task.subTaskProgress,
                minHeight: 4,
                backgroundColor: kBg3,
                valueColor: const AlwaysStoppedAnimation(kNeon),
              ),
            ),
          ],
          const SizedBox(height: 8),
          ...task.subTasks.map((s) => _subRow(s)),
          // Add field
          Row(
            children: [
              const Icon(PhosphorIconsRegular.plus, size: 16, color: kTextMuted),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: tt.bodySmall,
                  decoration: const InputDecoration(
                    hintText: 'Add sub-task…',
                    hintStyle: TextStyle(color: kTextMuted, fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: (v) {
                    if (v.trim().isNotEmpty) onAdd(v.trim());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _subRow(SubTask s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onToggle(s.id),
            child: Icon(
              s.isCompleted
                  ? PhosphorIconsFill.checkSquare
                  : PhosphorIconsRegular.square,
              size: 20,
              color: s.isCompleted ? kTeal : kTextMuted,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              s.title,
              style: TextStyle(
                fontSize: 13,
                color: s.isCompleted ? kTextMuted : kTextPrimary,
                decoration:
                    s.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onDelete(s.id),
            child: const Icon(PhosphorIconsRegular.x,
                size: 14, color: kTextMuted),
          ),
        ],
      ),
    );
  }
}
