// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get categoryIds => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  String? get dueTime => throw _privateConstructorUsedError;
  TaskPriority get priority => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  List<SubTask> get subTasks => throw _privateConstructorUsedError;
  List<LinkAttachment> get links => throw _privateConstructorUsedError;
  Recurrence? get recurrence => throw _privateConstructorUsedError;
  List<int> get reminders => throw _privateConstructorUsedError;
  Map<String, String> get contextFields => throw _privateConstructorUsedError;
  bool get isMasterRecurring => throw _privateConstructorUsedError;
  String? get masterTaskId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      List<String> categoryIds,
      DateTime? dueDate,
      String? dueTime,
      TaskPriority priority,
      TaskStatus status,
      List<SubTask> subTasks,
      List<LinkAttachment> links,
      Recurrence? recurrence,
      List<int> reminders,
      Map<String, String> contextFields,
      bool isMasterRecurring,
      String? masterTaskId,
      DateTime createdAt,
      DateTime updatedAt});

  $RecurrenceCopyWith<$Res>? get recurrence;
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? categoryIds = null,
    Object? dueDate = freezed,
    Object? dueTime = freezed,
    Object? priority = null,
    Object? status = null,
    Object? subTasks = null,
    Object? links = null,
    Object? recurrence = freezed,
    Object? reminders = null,
    Object? contextFields = null,
    Object? isMasterRecurring = null,
    Object? masterTaskId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      categoryIds: null == categoryIds
          ? _value.categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueTime: freezed == dueTime
          ? _value.dueTime
          : dueTime // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      subTasks: null == subTasks
          ? _value.subTasks
          : subTasks // ignore: cast_nullable_to_non_nullable
              as List<SubTask>,
      links: null == links
          ? _value.links
          : links // ignore: cast_nullable_to_non_nullable
              as List<LinkAttachment>,
      recurrence: freezed == recurrence
          ? _value.recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as Recurrence?,
      reminders: null == reminders
          ? _value.reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<int>,
      contextFields: null == contextFields
          ? _value.contextFields
          : contextFields // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      isMasterRecurring: null == isMasterRecurring
          ? _value.isMasterRecurring
          : isMasterRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      masterTaskId: freezed == masterTaskId
          ? _value.masterTaskId
          : masterTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecurrenceCopyWith<$Res>? get recurrence {
    if (_value.recurrence == null) {
      return null;
    }

    return $RecurrenceCopyWith<$Res>(_value.recurrence!, (value) {
      return _then(_value.copyWith(recurrence: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
          _$TaskImpl value, $Res Function(_$TaskImpl) then) =
      __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      List<String> categoryIds,
      DateTime? dueDate,
      String? dueTime,
      TaskPriority priority,
      TaskStatus status,
      List<SubTask> subTasks,
      List<LinkAttachment> links,
      Recurrence? recurrence,
      List<int> reminders,
      Map<String, String> contextFields,
      bool isMasterRecurring,
      String? masterTaskId,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $RecurrenceCopyWith<$Res>? get recurrence;
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
      : super(_value, _then);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? categoryIds = null,
    Object? dueDate = freezed,
    Object? dueTime = freezed,
    Object? priority = null,
    Object? status = null,
    Object? subTasks = null,
    Object? links = null,
    Object? recurrence = freezed,
    Object? reminders = null,
    Object? contextFields = null,
    Object? isMasterRecurring = null,
    Object? masterTaskId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      categoryIds: null == categoryIds
          ? _value._categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueTime: freezed == dueTime
          ? _value.dueTime
          : dueTime // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      subTasks: null == subTasks
          ? _value._subTasks
          : subTasks // ignore: cast_nullable_to_non_nullable
              as List<SubTask>,
      links: null == links
          ? _value._links
          : links // ignore: cast_nullable_to_non_nullable
              as List<LinkAttachment>,
      recurrence: freezed == recurrence
          ? _value.recurrence
          : recurrence // ignore: cast_nullable_to_non_nullable
              as Recurrence?,
      reminders: null == reminders
          ? _value._reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<int>,
      contextFields: null == contextFields
          ? _value._contextFields
          : contextFields // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      isMasterRecurring: null == isMasterRecurring
          ? _value.isMasterRecurring
          : isMasterRecurring // ignore: cast_nullable_to_non_nullable
              as bool,
      masterTaskId: freezed == masterTaskId
          ? _value.masterTaskId
          : masterTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl extends _Task {
  const _$TaskImpl(
      {required this.id,
      required this.title,
      this.description = '',
      final List<String> categoryIds = const [],
      this.dueDate,
      this.dueTime,
      this.priority = TaskPriority.none,
      this.status = TaskStatus.notStarted,
      final List<SubTask> subTasks = const [],
      final List<LinkAttachment> links = const [],
      this.recurrence,
      final List<int> reminders = const [],
      final Map<String, String> contextFields = const {},
      this.isMasterRecurring = false,
      this.masterTaskId,
      required this.createdAt,
      required this.updatedAt})
      : _categoryIds = categoryIds,
        _subTasks = subTasks,
        _links = links,
        _reminders = reminders,
        _contextFields = contextFields,
        super._();

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String description;
  final List<String> _categoryIds;
  @override
  @JsonKey()
  List<String> get categoryIds {
    if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryIds);
  }

  @override
  final DateTime? dueDate;
  @override
  final String? dueTime;
  @override
  @JsonKey()
  final TaskPriority priority;
  @override
  @JsonKey()
  final TaskStatus status;
  final List<SubTask> _subTasks;
  @override
  @JsonKey()
  List<SubTask> get subTasks {
    if (_subTasks is EqualUnmodifiableListView) return _subTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subTasks);
  }

  final List<LinkAttachment> _links;
  @override
  @JsonKey()
  List<LinkAttachment> get links {
    if (_links is EqualUnmodifiableListView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_links);
  }

  @override
  final Recurrence? recurrence;
  final List<int> _reminders;
  @override
  @JsonKey()
  List<int> get reminders {
    if (_reminders is EqualUnmodifiableListView) return _reminders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reminders);
  }

  final Map<String, String> _contextFields;
  @override
  @JsonKey()
  Map<String, String> get contextFields {
    if (_contextFields is EqualUnmodifiableMapView) return _contextFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_contextFields);
  }

  @override
  @JsonKey()
  final bool isMasterRecurring;
  @override
  final String? masterTaskId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, categoryIds: $categoryIds, dueDate: $dueDate, dueTime: $dueTime, priority: $priority, status: $status, subTasks: $subTasks, links: $links, recurrence: $recurrence, reminders: $reminders, contextFields: $contextFields, isMasterRecurring: $isMasterRecurring, masterTaskId: $masterTaskId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._categoryIds, _categoryIds) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.dueTime, dueTime) || other.dueTime == dueTime) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._subTasks, _subTasks) &&
            const DeepCollectionEquality().equals(other._links, _links) &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            const DeepCollectionEquality()
                .equals(other._reminders, _reminders) &&
            const DeepCollectionEquality()
                .equals(other._contextFields, _contextFields) &&
            (identical(other.isMasterRecurring, isMasterRecurring) ||
                other.isMasterRecurring == isMasterRecurring) &&
            (identical(other.masterTaskId, masterTaskId) ||
                other.masterTaskId == masterTaskId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      const DeepCollectionEquality().hash(_categoryIds),
      dueDate,
      dueTime,
      priority,
      status,
      const DeepCollectionEquality().hash(_subTasks),
      const DeepCollectionEquality().hash(_links),
      recurrence,
      const DeepCollectionEquality().hash(_reminders),
      const DeepCollectionEquality().hash(_contextFields),
      isMasterRecurring,
      masterTaskId,
      createdAt,
      updatedAt);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(
      this,
    );
  }
}

abstract class _Task extends Task {
  const factory _Task(
      {required final String id,
      required final String title,
      final String description,
      final List<String> categoryIds,
      final DateTime? dueDate,
      final String? dueTime,
      final TaskPriority priority,
      final TaskStatus status,
      final List<SubTask> subTasks,
      final List<LinkAttachment> links,
      final Recurrence? recurrence,
      final List<int> reminders,
      final Map<String, String> contextFields,
      final bool isMasterRecurring,
      final String? masterTaskId,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$TaskImpl;
  const _Task._() : super._();

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  List<String> get categoryIds;
  @override
  DateTime? get dueDate;
  @override
  String? get dueTime;
  @override
  TaskPriority get priority;
  @override
  TaskStatus get status;
  @override
  List<SubTask> get subTasks;
  @override
  List<LinkAttachment> get links;
  @override
  Recurrence? get recurrence;
  @override
  List<int> get reminders;
  @override
  Map<String, String> get contextFields;
  @override
  bool get isMasterRecurring;
  @override
  String? get masterTaskId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
