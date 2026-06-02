import 'dart:convert';
import 'package:drift/drift.dart';
import '../../models/enums.dart';
import '../../models/link_attachment.dart';
import '../../models/recurrence.dart';
import '../../models/sub_task.dart';
import '../../models/task.dart';
import 'app_database.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [TasksTable])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  // ── Queries ─────────────────────────────────────────────────────────────────

  Stream<List<Task>> watchAll() {
    return (select(tasksTable)
          ..where((t) => t.syncStatus.isNotValue('deleted'))
          ..orderBy([(t) => OrderingTerm.asc(t.dueDate)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Stream<Task?> watchById(String id) {
    return (select(tasksTable)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .map((r) => r == null ? null : _fromRow(r));
  }

  Stream<List<Task>> watchForDate(DateTime date) {
    final startMs = DateTime(date.year, date.month, date.day)
        .millisecondsSinceEpoch;
    final endMs = DateTime(date.year, date.month, date.day, 23, 59, 59)
        .millisecondsSinceEpoch;
    return (select(tasksTable)
          ..where((t) =>
              t.syncStatus.isNotValue('deleted') &
              t.dueDate.isBetweenValues(startMs, endMs)))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Stream<List<Task>> watchOverdue() {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    return (select(tasksTable)
          ..where((t) =>
              t.syncStatus.isNotValue('deleted') &
              t.dueDate.isSmallerThanValue(nowMs) &
              t.status.isNotIn(['done', 'cancelled'])))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<List<Task>> getPending() async {
    final rows = await (select(tasksTable)
          ..where((t) => t.syncStatus.equals('pending')))
        .get();
    return rows.map(_fromRow).toList();
  }

  // ── Mutations ────────────────────────────────────────────────────────────────

  Future<void> upsert(Task task) {
    return into(tasksTable).insertOnConflictUpdate(_toCompanion(task));
  }

  Future<void> deleteById(String id) {
    return (update(tasksTable)..where((t) => t.id.equals(id)))
        .write(const TasksTableCompanion(syncStatus: Value('deleted')));
  }

  Future<void> markSynced(String id) {
    return (update(tasksTable)..where((t) => t.id.equals(id)))
        .write(const TasksTableCompanion(syncStatus: Value('synced')));
  }

  Future<void> updateStatus(String id, TaskStatus status) {
    return (update(tasksTable)..where((t) => t.id.equals(id))).write(
      TasksTableCompanion(
        status:     Value(status.name),
        syncStatus: const Value('pending'),
      ),
    );
  }

  // ── Converters ───────────────────────────────────────────────────────────────

  Task _fromRow(TasksTableData r) => Task(
        id:               r.id,
        title:            r.title,
        description:      r.description,
        categoryIds:      List<String>.from(jsonDecode(r.categoryIds) as List),
        dueDate:          r.dueDate != null
            ? DateTime.fromMillisecondsSinceEpoch(r.dueDate!)
            : null,
        dueTime:          r.dueTime,
        priority:         TaskPriority.values.firstWhere(
            (e) => e.name == r.priority,
            orElse: () => TaskPriority.none),
        status:           TaskStatus.values.firstWhere(
            (e) => e.name == r.status,
            orElse: () => TaskStatus.notStarted),
        subTasks:         (jsonDecode(r.subTasks) as List)
            .map((e) => SubTask.fromMap(e as Map<String, dynamic>))
            .toList(),
        links:            (jsonDecode(r.links) as List)
            .map((e) => LinkAttachment.fromMap(e as Map<String, dynamic>))
            .toList(),
        recurrence:       r.recurrence != null
            ? Recurrence.fromMap(
                jsonDecode(r.recurrence!) as Map<String, dynamic>)
            : null,
        reminders:        List<int>.from(jsonDecode(r.reminders) as List),
        contextFields:    Map<String, String>.from(
            jsonDecode(r.contextFields) as Map),
        isMasterRecurring: r.isMasterRecurring,
        masterTaskId:     r.masterTaskId,
        createdAt:        DateTime.fromMillisecondsSinceEpoch(r.createdAt),
        updatedAt:        DateTime.fromMillisecondsSinceEpoch(r.updatedAt),
      );

  TasksTableCompanion _toCompanion(Task t) => TasksTableCompanion.insert(
        id:               t.id,
        title:            t.title,
        description:      Value(t.description),
        categoryIds:      Value(jsonEncode(t.categoryIds)),
        dueDate:          Value(t.dueDate?.millisecondsSinceEpoch),
        dueTime:          Value(t.dueTime),
        priority:         Value(t.priority.name),
        status:           Value(t.status.name),
        subTasks:         Value(jsonEncode(
            t.subTasks.map((s) => s.toMap()).toList())),
        links:            Value(jsonEncode(
            t.links.map((l) => l.toMap()).toList())),
        recurrence:       Value(
            t.recurrence != null ? jsonEncode(t.recurrence!.toMap()) : null),
        reminders:        Value(jsonEncode(t.reminders)),
        contextFields:    Value(jsonEncode(t.contextFields)),
        isMasterRecurring: Value(t.isMasterRecurring),
        masterTaskId:     Value(t.masterTaskId),
        createdAt:        t.createdAt.millisecondsSinceEpoch,
        updatedAt:        t.updatedAt.millisecondsSinceEpoch,
        syncStatus:       const Value('pending'),
      );
}
