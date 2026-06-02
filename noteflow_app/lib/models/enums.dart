import 'package:json_annotation/json_annotation.dart';

enum CategoryModule {
  @JsonValue('note')    note,
  @JsonValue('task')    task,
  @JsonValue('shared')  shared,
}

enum TaskPriority {
  @JsonValue('none')      none,
  @JsonValue('low')       low,
  @JsonValue('medium')    medium,
  @JsonValue('high')      high,
  @JsonValue('critical')  critical,
}

enum TaskStatus {
  @JsonValue('notStarted')   notStarted,
  @JsonValue('inProgress')   inProgress,
  @JsonValue('blocked')      blocked,
  @JsonValue('done')         done,
  @JsonValue('cancelled')    cancelled,
}

enum RecurrenceType {
  @JsonValue('daily')       daily,
  @JsonValue('weekly')      weekly,
  @JsonValue('monthly')     monthly,
  @JsonValue('quarterly')   quarterly,
  @JsonValue('halfYearly')  halfYearly,
  @JsonValue('annually')    annually,
  @JsonValue('custom')      custom,
}

enum RecurrenceEnd {
  @JsonValue('noEnd')         noEnd,
  @JsonValue('endByDate')     endByDate,
  @JsonValue('endAfterCount') endAfterCount,
}
