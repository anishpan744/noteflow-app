import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/task_repository.dart';
import '../../models/enums.dart';
import '../../models/sub_task.dart';
import '../../models/task.dart';

// ── Calendar view mode ────────────────────────────────────────────────────────

enum CalendarView { day, week, month }

// ── State providers ───────────────────────────────────────────────────────────

final selectedDateProvider =
    StateProvider<DateTime>((_) => DateTime.now());

final calendarViewModeProvider =
    StateProvider<CalendarView>((_) => CalendarView.month);

// ── Stream providers ──────────────────────────────────────────────────────────

final tasksForDayProvider = StreamProvider.autoDispose
    .family<List<Task>, DateTime>((ref, date) {
  return ref.watch(taskRepositoryProvider).watchForDate(date);
});

final overdueTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(taskRepositoryProvider).watchOverdue();
});

final allTasksProvider = StreamProvider<List<Task>>((ref) {
  return ref.watch(taskRepositoryProvider).watchAll();
});

// ── Task controller ───────────────────────────────────────────────────────────

class TaskController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  TaskRepository get _repo => ref.read(taskRepositoryProvider);

  Future<void> create({
    required String title,
    String description       = '',
    List<String> categoryIds = const [],
    DateTime? dueDate,
    String? dueTime,
    TaskPriority priority    = TaskPriority.none,
    TaskStatus status        = TaskStatus.notStarted,
  }) async {
    final now = DateTime.now();
    final task = Task(
      id:          const Uuid().v4(),
      title:       title,
      description: description,
      categoryIds: categoryIds,
      dueDate:     dueDate,
      dueTime:     dueTime,
      priority:    priority,
      status:      status,
      createdAt:   now,
      updatedAt:   now,
    );
    state = await AsyncValue.guard(() => _repo.save(task));
  }

  Future<void> save(Task task) async {
    state = await AsyncValue.guard(
        () => _repo.save(task.copyWith(updatedAt: DateTime.now())));
  }

  Future<void> delete(String id) async {
    state = await AsyncValue.guard(() => _repo.delete(id));
  }

  Future<void> updateStatus(String id, TaskStatus status) async {
    state = await AsyncValue.guard(() => _repo.updateStatus(id, status));
  }

  Future<void> toggleSubTask(Task task, String subTaskId) async {
    final updated = task.copyWith(
      subTasks: task.subTasks.map((s) {
        return s.id == subTaskId ? s.copyWith(isCompleted: !s.isCompleted) : s;
      }).toList(),
      updatedAt: DateTime.now(),
    );
    state = await AsyncValue.guard(() => _repo.save(updated));
  }

  Future<void> addSubTask(Task task, String title) async {
    final sub = SubTask(
      id:        const Uuid().v4(),
      title:     title,
      sortOrder: task.subTasks.length,
    );
    final updated = task.copyWith(
      subTasks:  [...task.subTasks, sub],
      updatedAt: DateTime.now(),
    );
    state = await AsyncValue.guard(() => _repo.save(updated));
  }

  Future<void> reschedule(String id, DateTime? dueDate) async {
    state = await AsyncValue.guard(() => _repo.reschedule(id, dueDate));
  }
}

final taskControllerProvider =
    AsyncNotifierProvider<TaskController, void>(TaskController.new);
