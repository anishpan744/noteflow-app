import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'recurrence.freezed.dart';
part 'recurrence.g.dart';

@freezed
class Recurrence with _$Recurrence {
  const Recurrence._();

  const factory Recurrence({
    required RecurrenceType type,
    @Default(1) int interval,
    @Default([]) List<int> daysOfWeek,
    int? dayOfMonth,
    int? monthOfYear,
    @Default(RecurrenceEnd.noEnd) RecurrenceEnd endCondition,
    DateTime? endDate,
    int? endAfterCount,
    @Default(0) int instanceCount,
  }) = _Recurrence;

  factory Recurrence.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceFromJson(json);

  factory Recurrence.fromMap(Map<String, dynamic> d) => Recurrence(
        type: RecurrenceType.values.firstWhere(
            (e) => e.name == (d['type'] ?? 'daily'),
            orElse: () => RecurrenceType.daily),
        interval:      (d['interval'] as int?) ?? 1,
        daysOfWeek:    List<int>.from(d['daysOfWeek'] as List? ?? []),
        dayOfMonth:    d['dayOfMonth'] as int?,
        monthOfYear:   d['monthOfYear'] as int?,
        endCondition:  RecurrenceEnd.values.firstWhere(
            (e) => e.name == (d['endCondition'] ?? 'noEnd'),
            orElse: () => RecurrenceEnd.noEnd),
        endDate:       _tsToDate(d['endDate']),
        endAfterCount: d['endAfterCount'] as int?,
        instanceCount: (d['instanceCount'] as int?) ?? 0,
      );

  Map<String, dynamic> toMap() {
    final m = toJson();
    if (endDate != null) m['endDate'] = Timestamp.fromDate(endDate!);
    return m;
  }
}

DateTime? _tsToDate(dynamic v) {
  if (v == null) return null;
  if (v is Timestamp) return v.toDate();
  if (v is String) return DateTime.tryParse(v);
  return null;
}
