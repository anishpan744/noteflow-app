import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'link_attachment.dart';
import 'recurrence.dart';
import 'sub_task.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const Task._();

  const factory Task({
    required String id,
    required String title,
    @Default('') String description,
    @Default([]) List<String> categoryIds,
    DateTime? dueDate,
    String? dueTime,
    @Default(TaskPriority.none) TaskPriority priority,
    @Default(TaskStatus.notStarted) TaskStatus status,
    @Default([]) List<SubTask> subTasks,
    @Default([]) List<LinkAttachment> links,
    Recurrence? recurrence,
    @Default([]) List<int> reminders,
    @Default({}) Map<String, String> contextFields,
    @Default(false) bool isMasterRecurring,
    String? masterTaskId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  factory Task.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Task(
      id:               doc.id,
      title:            (d['title'] as String?) ?? '',
      description:      (d['description'] as String?) ?? '',
      categoryIds:      List<String>.from(d['categoryIds'] as List? ?? []),
      dueDate:          _tsToDate(d['dueDate']),
      dueTime:          d['dueTime'] as String?,
      priority:         TaskPriority.values.firstWhere(
          (e) => e.name == (d['priority'] ?? 'none'),
          orElse: () => TaskPriority.none),
      status:           TaskStatus.values.firstWhere(
          (e) => e.name == (d['status'] ?? 'notStarted'),
          orElse: () => TaskStatus.notStarted),
      subTasks:         ((d['subTasks'] as List?) ?? [])
          .map((e) => SubTask.fromMap(e as Map<String, dynamic>))
          .toList(),
      links:            ((d['links'] as List?) ?? [])
          .map((e) => LinkAttachment.fromMap(e as Map<String, dynamic>))
          .toList(),
      recurrence:       d['recurrence'] != null
          ? Recurrence.fromMap(d['recurrence'] as Map<String, dynamic>)
          : null,
      reminders:        List<int>.from(d['reminders'] as List? ?? []),
      contextFields:    Map<String, String>.from(d['contextFields'] as Map? ?? {}),
      isMasterRecurring: (d['isMasterRecurring'] as bool?) ?? false,
      masterTaskId:     d['masterTaskId'] as String?,
      createdAt:        _tsToDate(d['createdAt']) ?? DateTime.now(),
      updatedAt:        _tsToDate(d['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    final m = toJson()..remove('id');
    m['subTasks']  = subTasks.map((s) => s.toMap()).toList();
    m['links']     = links.map((l) => l.toMap()).toList();
    m['recurrence']= recurrence?.toMap();
    m['createdAt'] = Timestamp.fromDate(createdAt);
    m['updatedAt'] = Timestamp.fromDate(updatedAt);
    if (dueDate != null) m['dueDate'] = Timestamp.fromDate(dueDate!);
    return m;
  }

  double get subTaskProgress {
    if (subTasks.isEmpty) return 0;
    return subTasks.where((s) => s.isCompleted).length / subTasks.length;
  }

  bool get isOverdue {
    if (dueDate == null) return false;
    if (status == TaskStatus.done || status == TaskStatus.cancelled) return false;
    return dueDate!.isBefore(DateTime.now());
  }
}

DateTime? _tsToDate(dynamic v) {
  if (v == null) return null;
  if (v is Timestamp) return v.toDate();
  if (v is String) return DateTime.tryParse(v);
  return null;
}
