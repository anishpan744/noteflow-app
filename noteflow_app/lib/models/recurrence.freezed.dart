// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurrence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Recurrence _$RecurrenceFromJson(Map<String, dynamic> json) {
  return _Recurrence.fromJson(json);
}

/// @nodoc
mixin _$Recurrence {
  RecurrenceType get type => throw _privateConstructorUsedError;
  int get interval => throw _privateConstructorUsedError;
  List<int> get daysOfWeek => throw _privateConstructorUsedError;
  int? get dayOfMonth => throw _privateConstructorUsedError;
  int? get monthOfYear => throw _privateConstructorUsedError;
  RecurrenceEnd get endCondition => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  int? get endAfterCount => throw _privateConstructorUsedError;
  int get instanceCount => throw _privateConstructorUsedError;

  /// Serializes this Recurrence to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Recurrence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurrenceCopyWith<Recurrence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurrenceCopyWith<$Res> {
  factory $RecurrenceCopyWith(
          Recurrence value, $Res Function(Recurrence) then) =
      _$RecurrenceCopyWithImpl<$Res, Recurrence>;
  @useResult
  $Res call(
      {RecurrenceType type,
      int interval,
      List<int> daysOfWeek,
      int? dayOfMonth,
      int? monthOfYear,
      RecurrenceEnd endCondition,
      DateTime? endDate,
      int? endAfterCount,
      int instanceCount});
}

/// @nodoc
class _$RecurrenceCopyWithImpl<$Res, $Val extends Recurrence>
    implements $RecurrenceCopyWith<$Res> {
  _$RecurrenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recurrence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? interval = null,
    Object? daysOfWeek = null,
    Object? dayOfMonth = freezed,
    Object? monthOfYear = freezed,
    Object? endCondition = null,
    Object? endDate = freezed,
    Object? endAfterCount = freezed,
    Object? instanceCount = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RecurrenceType,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      daysOfWeek: null == daysOfWeek
          ? _value.daysOfWeek
          : daysOfWeek // ignore: cast_nullable_to_non_nullable
              as List<int>,
      dayOfMonth: freezed == dayOfMonth
          ? _value.dayOfMonth
          : dayOfMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      monthOfYear: freezed == monthOfYear
          ? _value.monthOfYear
          : monthOfYear // ignore: cast_nullable_to_non_nullable
              as int?,
      endCondition: null == endCondition
          ? _value.endCondition
          : endCondition // ignore: cast_nullable_to_non_nullable
              as RecurrenceEnd,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endAfterCount: freezed == endAfterCount
          ? _value.endAfterCount
          : endAfterCount // ignore: cast_nullable_to_non_nullable
              as int?,
      instanceCount: null == instanceCount
          ? _value.instanceCount
          : instanceCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecurrenceImplCopyWith<$Res>
    implements $RecurrenceCopyWith<$Res> {
  factory _$$RecurrenceImplCopyWith(
          _$RecurrenceImpl value, $Res Function(_$RecurrenceImpl) then) =
      __$$RecurrenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RecurrenceType type,
      int interval,
      List<int> daysOfWeek,
      int? dayOfMonth,
      int? monthOfYear,
      RecurrenceEnd endCondition,
      DateTime? endDate,
      int? endAfterCount,
      int instanceCount});
}

/// @nodoc
class __$$RecurrenceImplCopyWithImpl<$Res>
    extends _$RecurrenceCopyWithImpl<$Res, _$RecurrenceImpl>
    implements _$$RecurrenceImplCopyWith<$Res> {
  __$$RecurrenceImplCopyWithImpl(
      _$RecurrenceImpl _value, $Res Function(_$RecurrenceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Recurrence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? interval = null,
    Object? daysOfWeek = null,
    Object? dayOfMonth = freezed,
    Object? monthOfYear = freezed,
    Object? endCondition = null,
    Object? endDate = freezed,
    Object? endAfterCount = freezed,
    Object? instanceCount = null,
  }) {
    return _then(_$RecurrenceImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RecurrenceType,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      daysOfWeek: null == daysOfWeek
          ? _value._daysOfWeek
          : daysOfWeek // ignore: cast_nullable_to_non_nullable
              as List<int>,
      dayOfMonth: freezed == dayOfMonth
          ? _value.dayOfMonth
          : dayOfMonth // ignore: cast_nullable_to_non_nullable
              as int?,
      monthOfYear: freezed == monthOfYear
          ? _value.monthOfYear
          : monthOfYear // ignore: cast_nullable_to_non_nullable
              as int?,
      endCondition: null == endCondition
          ? _value.endCondition
          : endCondition // ignore: cast_nullable_to_non_nullable
              as RecurrenceEnd,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endAfterCount: freezed == endAfterCount
          ? _value.endAfterCount
          : endAfterCount // ignore: cast_nullable_to_non_nullable
              as int?,
      instanceCount: null == instanceCount
          ? _value.instanceCount
          : instanceCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurrenceImpl extends _Recurrence {
  const _$RecurrenceImpl(
      {required this.type,
      this.interval = 1,
      final List<int> daysOfWeek = const [],
      this.dayOfMonth,
      this.monthOfYear,
      this.endCondition = RecurrenceEnd.noEnd,
      this.endDate,
      this.endAfterCount,
      this.instanceCount = 0})
      : _daysOfWeek = daysOfWeek,
        super._();

  factory _$RecurrenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurrenceImplFromJson(json);

  @override
  final RecurrenceType type;
  @override
  @JsonKey()
  final int interval;
  final List<int> _daysOfWeek;
  @override
  @JsonKey()
  List<int> get daysOfWeek {
    if (_daysOfWeek is EqualUnmodifiableListView) return _daysOfWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daysOfWeek);
  }

  @override
  final int? dayOfMonth;
  @override
  final int? monthOfYear;
  @override
  @JsonKey()
  final RecurrenceEnd endCondition;
  @override
  final DateTime? endDate;
  @override
  final int? endAfterCount;
  @override
  @JsonKey()
  final int instanceCount;

  @override
  String toString() {
    return 'Recurrence(type: $type, interval: $interval, daysOfWeek: $daysOfWeek, dayOfMonth: $dayOfMonth, monthOfYear: $monthOfYear, endCondition: $endCondition, endDate: $endDate, endAfterCount: $endAfterCount, instanceCount: $instanceCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurrenceImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            const DeepCollectionEquality()
                .equals(other._daysOfWeek, _daysOfWeek) &&
            (identical(other.dayOfMonth, dayOfMonth) ||
                other.dayOfMonth == dayOfMonth) &&
            (identical(other.monthOfYear, monthOfYear) ||
                other.monthOfYear == monthOfYear) &&
            (identical(other.endCondition, endCondition) ||
                other.endCondition == endCondition) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.endAfterCount, endAfterCount) ||
                other.endAfterCount == endAfterCount) &&
            (identical(other.instanceCount, instanceCount) ||
                other.instanceCount == instanceCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      interval,
      const DeepCollectionEquality().hash(_daysOfWeek),
      dayOfMonth,
      monthOfYear,
      endCondition,
      endDate,
      endAfterCount,
      instanceCount);

  /// Create a copy of Recurrence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurrenceImplCopyWith<_$RecurrenceImpl> get copyWith =>
      __$$RecurrenceImplCopyWithImpl<_$RecurrenceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurrenceImplToJson(
      this,
    );
  }
}

abstract class _Recurrence extends Recurrence {
  const factory _Recurrence(
      {required final RecurrenceType type,
      final int interval,
      final List<int> daysOfWeek,
      final int? dayOfMonth,
      final int? monthOfYear,
      final RecurrenceEnd endCondition,
      final DateTime? endDate,
      final int? endAfterCount,
      final int instanceCount}) = _$RecurrenceImpl;
  const _Recurrence._() : super._();

  factory _Recurrence.fromJson(Map<String, dynamic> json) =
      _$RecurrenceImpl.fromJson;

  @override
  RecurrenceType get type;
  @override
  int get interval;
  @override
  List<int> get daysOfWeek;
  @override
  int? get dayOfMonth;
  @override
  int? get monthOfYear;
  @override
  RecurrenceEnd get endCondition;
  @override
  DateTime? get endDate;
  @override
  int? get endAfterCount;
  @override
  int get instanceCount;

  /// Create a copy of Recurrence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurrenceImplCopyWith<_$RecurrenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
