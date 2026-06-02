import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_task.freezed.dart';
part 'sub_task.g.dart';

@freezed
class SubTask with _$SubTask {
  const SubTask._();

  const factory SubTask({
    required String id,
    required String title,
    @Default(false) bool isCompleted,
    @Default(0) int sortOrder,
  }) = _SubTask;

  factory SubTask.fromJson(Map<String, dynamic> json) =>
      _$SubTaskFromJson(json);

  factory SubTask.fromMap(Map<String, dynamic> d) => SubTask(
        id:          d['id'] as String,
        title:       d['title'] as String,
        isCompleted: (d['isCompleted'] as bool?) ?? false,
        sortOrder:   (d['sortOrder'] as int?) ?? 0,
      );

  Map<String, dynamic> toMap() => toJson();
}
