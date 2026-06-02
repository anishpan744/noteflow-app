// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      categoryIds: (json['categoryIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      dueTime: json['dueTime'] as String?,
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']) ??
          TaskPriority.none,
      status: $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
          TaskStatus.notStarted,
      subTasks: (json['subTasks'] as List<dynamic>?)
              ?.map((e) => SubTask.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      links: (json['links'] as List<dynamic>?)
              ?.map((e) => LinkAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recurrence: json['recurrence'] == null
          ? null
          : Recurrence.fromJson(json['recurrence'] as Map<String, dynamic>),
      reminders: (json['reminders'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      contextFields: (json['contextFields'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      isMasterRecurring: json['isMasterRecurring'] as bool? ?? false,
      masterTaskId: json['masterTaskId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'categoryIds': instance.categoryIds,
      'dueDate': instance.dueDate?.toIso8601String(),
      'dueTime': instance.dueTime,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'subTasks': instance.subTasks,
      'links': instance.links,
      'recurrence': instance.recurrence,
      'reminders': instance.reminders,
      'contextFields': instance.contextFields,
      'isMasterRecurring': instance.isMasterRecurring,
      'masterTaskId': instance.masterTaskId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$TaskPriorityEnumMap = {
  TaskPriority.none: 'none',
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
  TaskPriority.critical: 'critical',
};

const _$TaskStatusEnumMap = {
  TaskStatus.notStarted: 'notStarted',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.blocked: 'blocked',
  TaskStatus.done: 'done',
  TaskStatus.cancelled: 'cancelled',
};
