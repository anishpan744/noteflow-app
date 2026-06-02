// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurrence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecurrenceImpl _$$RecurrenceImplFromJson(Map<String, dynamic> json) =>
    _$RecurrenceImpl(
      type: $enumDecode(_$RecurrenceTypeEnumMap, json['type']),
      interval: (json['interval'] as num?)?.toInt() ?? 1,
      daysOfWeek: (json['daysOfWeek'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
      monthOfYear: (json['monthOfYear'] as num?)?.toInt(),
      endCondition:
          $enumDecodeNullable(_$RecurrenceEndEnumMap, json['endCondition']) ??
              RecurrenceEnd.noEnd,
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      endAfterCount: (json['endAfterCount'] as num?)?.toInt(),
      instanceCount: (json['instanceCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$RecurrenceImplToJson(_$RecurrenceImpl instance) =>
    <String, dynamic>{
      'type': _$RecurrenceTypeEnumMap[instance.type]!,
      'interval': instance.interval,
      'daysOfWeek': instance.daysOfWeek,
      'dayOfMonth': instance.dayOfMonth,
      'monthOfYear': instance.monthOfYear,
      'endCondition': _$RecurrenceEndEnumMap[instance.endCondition]!,
      'endDate': instance.endDate?.toIso8601String(),
      'endAfterCount': instance.endAfterCount,
      'instanceCount': instance.instanceCount,
    };

const _$RecurrenceTypeEnumMap = {
  RecurrenceType.daily: 'daily',
  RecurrenceType.weekly: 'weekly',
  RecurrenceType.monthly: 'monthly',
  RecurrenceType.quarterly: 'quarterly',
  RecurrenceType.halfYearly: 'halfYearly',
  RecurrenceType.annually: 'annually',
  RecurrenceType.custom: 'custom',
};

const _$RecurrenceEndEnumMap = {
  RecurrenceEnd.noEnd: 'noEnd',
  RecurrenceEnd.endByDate: 'endByDate',
  RecurrenceEnd.endAfterCount: 'endAfterCount',
};
