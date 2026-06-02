// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Note _$NoteFromJson(Map<String, dynamic> json) {
  return _Note.fromJson(json);
}

/// @nodoc
mixin _$Note {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get bodyJson => throw _privateConstructorUsedError;
  List<String> get categoryIds => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<LinkAttachment> get links => throw _privateConstructorUsedError;
  List<String> get attachmentUrls => throw _privateConstructorUsedError;
  bool get isPinned => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  Map<String, String> get contextFields => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Note to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteCopyWith<Note> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteCopyWith<$Res> {
  factory $NoteCopyWith(Note value, $Res Function(Note) then) =
      _$NoteCopyWithImpl<$Res, Note>;
  @useResult
  $Res call(
      {String id,
      String title,
      String bodyJson,
      List<String> categoryIds,
      List<String> tags,
      List<LinkAttachment> links,
      List<String> attachmentUrls,
      bool isPinned,
      bool isArchived,
      Map<String, String> contextFields,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$NoteCopyWithImpl<$Res, $Val extends Note>
    implements $NoteCopyWith<$Res> {
  _$NoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? bodyJson = null,
    Object? categoryIds = null,
    Object? tags = null,
    Object? links = null,
    Object? attachmentUrls = null,
    Object? isPinned = null,
    Object? isArchived = null,
    Object? contextFields = null,
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
      bodyJson: null == bodyJson
          ? _value.bodyJson
          : bodyJson // ignore: cast_nullable_to_non_nullable
              as String,
      categoryIds: null == categoryIds
          ? _value.categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      links: null == links
          ? _value.links
          : links // ignore: cast_nullable_to_non_nullable
              as List<LinkAttachment>,
      attachmentUrls: null == attachmentUrls
          ? _value.attachmentUrls
          : attachmentUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      contextFields: null == contextFields
          ? _value.contextFields
          : contextFields // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
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
}

/// @nodoc
abstract class _$$NoteImplCopyWith<$Res> implements $NoteCopyWith<$Res> {
  factory _$$NoteImplCopyWith(
          _$NoteImpl value, $Res Function(_$NoteImpl) then) =
      __$$NoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String bodyJson,
      List<String> categoryIds,
      List<String> tags,
      List<LinkAttachment> links,
      List<String> attachmentUrls,
      bool isPinned,
      bool isArchived,
      Map<String, String> contextFields,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$NoteImplCopyWithImpl<$Res>
    extends _$NoteCopyWithImpl<$Res, _$NoteImpl>
    implements _$$NoteImplCopyWith<$Res> {
  __$$NoteImplCopyWithImpl(_$NoteImpl _value, $Res Function(_$NoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? bodyJson = null,
    Object? categoryIds = null,
    Object? tags = null,
    Object? links = null,
    Object? attachmentUrls = null,
    Object? isPinned = null,
    Object? isArchived = null,
    Object? contextFields = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$NoteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      bodyJson: null == bodyJson
          ? _value.bodyJson
          : bodyJson // ignore: cast_nullable_to_non_nullable
              as String,
      categoryIds: null == categoryIds
          ? _value._categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      links: null == links
          ? _value._links
          : links // ignore: cast_nullable_to_non_nullable
              as List<LinkAttachment>,
      attachmentUrls: null == attachmentUrls
          ? _value._attachmentUrls
          : attachmentUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      contextFields: null == contextFields
          ? _value._contextFields
          : contextFields // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
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
class _$NoteImpl extends _Note {
  const _$NoteImpl(
      {required this.id,
      required this.title,
      this.bodyJson = '',
      final List<String> categoryIds = const [],
      final List<String> tags = const [],
      final List<LinkAttachment> links = const [],
      final List<String> attachmentUrls = const [],
      this.isPinned = false,
      this.isArchived = false,
      final Map<String, String> contextFields = const {},
      required this.createdAt,
      required this.updatedAt})
      : _categoryIds = categoryIds,
        _tags = tags,
        _links = links,
        _attachmentUrls = attachmentUrls,
        _contextFields = contextFields,
        super._();

  factory _$NoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String bodyJson;
  final List<String> _categoryIds;
  @override
  @JsonKey()
  List<String> get categoryIds {
    if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryIds);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<LinkAttachment> _links;
  @override
  @JsonKey()
  List<LinkAttachment> get links {
    if (_links is EqualUnmodifiableListView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_links);
  }

  final List<String> _attachmentUrls;
  @override
  @JsonKey()
  List<String> get attachmentUrls {
    if (_attachmentUrls is EqualUnmodifiableListView) return _attachmentUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachmentUrls);
  }

  @override
  @JsonKey()
  final bool isPinned;
  @override
  @JsonKey()
  final bool isArchived;
  final Map<String, String> _contextFields;
  @override
  @JsonKey()
  Map<String, String> get contextFields {
    if (_contextFields is EqualUnmodifiableMapView) return _contextFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_contextFields);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Note(id: $id, title: $title, bodyJson: $bodyJson, categoryIds: $categoryIds, tags: $tags, links: $links, attachmentUrls: $attachmentUrls, isPinned: $isPinned, isArchived: $isArchived, contextFields: $contextFields, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.bodyJson, bodyJson) ||
                other.bodyJson == bodyJson) &&
            const DeepCollectionEquality()
                .equals(other._categoryIds, _categoryIds) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._links, _links) &&
            const DeepCollectionEquality()
                .equals(other._attachmentUrls, _attachmentUrls) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            const DeepCollectionEquality()
                .equals(other._contextFields, _contextFields) &&
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
      bodyJson,
      const DeepCollectionEquality().hash(_categoryIds),
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_links),
      const DeepCollectionEquality().hash(_attachmentUrls),
      isPinned,
      isArchived,
      const DeepCollectionEquality().hash(_contextFields),
      createdAt,
      updatedAt);

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      __$$NoteImplCopyWithImpl<_$NoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteImplToJson(
      this,
    );
  }
}

abstract class _Note extends Note {
  const factory _Note(
      {required final String id,
      required final String title,
      final String bodyJson,
      final List<String> categoryIds,
      final List<String> tags,
      final List<LinkAttachment> links,
      final List<String> attachmentUrls,
      final bool isPinned,
      final bool isArchived,
      final Map<String, String> contextFields,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$NoteImpl;
  const _Note._() : super._();

  factory _Note.fromJson(Map<String, dynamic> json) = _$NoteImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get bodyJson;
  @override
  List<String> get categoryIds;
  @override
  List<String> get tags;
  @override
  List<LinkAttachment> get links;
  @override
  List<String> get attachmentUrls;
  @override
  bool get isPinned;
  @override
  bool get isArchived;
  @override
  Map<String, String> get contextFields;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
