// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'link_attachment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LinkAttachment _$LinkAttachmentFromJson(Map<String, dynamic> json) {
  return _LinkAttachment.fromJson(json);
}

/// @nodoc
mixin _$LinkAttachment {
  String get url => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get siteName => throw _privateConstructorUsedError;
  String? get favicon => throw _privateConstructorUsedError;

  /// Serializes this LinkAttachment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LinkAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LinkAttachmentCopyWith<LinkAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LinkAttachmentCopyWith<$Res> {
  factory $LinkAttachmentCopyWith(
          LinkAttachment value, $Res Function(LinkAttachment) then) =
      _$LinkAttachmentCopyWithImpl<$Res, LinkAttachment>;
  @useResult
  $Res call(
      {String url,
      String? title,
      String? description,
      String? imageUrl,
      String? siteName,
      String? favicon});
}

/// @nodoc
class _$LinkAttachmentCopyWithImpl<$Res, $Val extends LinkAttachment>
    implements $LinkAttachmentCopyWith<$Res> {
  _$LinkAttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LinkAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? siteName = freezed,
    Object? favicon = freezed,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      siteName: freezed == siteName
          ? _value.siteName
          : siteName // ignore: cast_nullable_to_non_nullable
              as String?,
      favicon: freezed == favicon
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LinkAttachmentImplCopyWith<$Res>
    implements $LinkAttachmentCopyWith<$Res> {
  factory _$$LinkAttachmentImplCopyWith(_$LinkAttachmentImpl value,
          $Res Function(_$LinkAttachmentImpl) then) =
      __$$LinkAttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String url,
      String? title,
      String? description,
      String? imageUrl,
      String? siteName,
      String? favicon});
}

/// @nodoc
class __$$LinkAttachmentImplCopyWithImpl<$Res>
    extends _$LinkAttachmentCopyWithImpl<$Res, _$LinkAttachmentImpl>
    implements _$$LinkAttachmentImplCopyWith<$Res> {
  __$$LinkAttachmentImplCopyWithImpl(
      _$LinkAttachmentImpl _value, $Res Function(_$LinkAttachmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of LinkAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? siteName = freezed,
    Object? favicon = freezed,
  }) {
    return _then(_$LinkAttachmentImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      siteName: freezed == siteName
          ? _value.siteName
          : siteName // ignore: cast_nullable_to_non_nullable
              as String?,
      favicon: freezed == favicon
          ? _value.favicon
          : favicon // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LinkAttachmentImpl extends _LinkAttachment {
  const _$LinkAttachmentImpl(
      {required this.url,
      this.title,
      this.description,
      this.imageUrl,
      this.siteName,
      this.favicon})
      : super._();

  factory _$LinkAttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$LinkAttachmentImplFromJson(json);

  @override
  final String url;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? imageUrl;
  @override
  final String? siteName;
  @override
  final String? favicon;

  @override
  String toString() {
    return 'LinkAttachment(url: $url, title: $title, description: $description, imageUrl: $imageUrl, siteName: $siteName, favicon: $favicon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkAttachmentImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.siteName, siteName) ||
                other.siteName == siteName) &&
            (identical(other.favicon, favicon) || other.favicon == favicon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, url, title, description, imageUrl, siteName, favicon);

  /// Create a copy of LinkAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LinkAttachmentImplCopyWith<_$LinkAttachmentImpl> get copyWith =>
      __$$LinkAttachmentImplCopyWithImpl<_$LinkAttachmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LinkAttachmentImplToJson(
      this,
    );
  }
}

abstract class _LinkAttachment extends LinkAttachment {
  const factory _LinkAttachment(
      {required final String url,
      final String? title,
      final String? description,
      final String? imageUrl,
      final String? siteName,
      final String? favicon}) = _$LinkAttachmentImpl;
  const _LinkAttachment._() : super._();

  factory _LinkAttachment.fromJson(Map<String, dynamic> json) =
      _$LinkAttachmentImpl.fromJson;

  @override
  String get url;
  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get imageUrl;
  @override
  String? get siteName;
  @override
  String? get favicon;

  /// Create a copy of LinkAttachment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LinkAttachmentImplCopyWith<_$LinkAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
