// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LinkAttachmentImpl _$$LinkAttachmentImplFromJson(Map<String, dynamic> json) =>
    _$LinkAttachmentImpl(
      url: json['url'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      siteName: json['siteName'] as String?,
      favicon: json['favicon'] as String?,
    );

Map<String, dynamic> _$$LinkAttachmentImplToJson(
        _$LinkAttachmentImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'siteName': instance.siteName,
      'favicon': instance.favicon,
    };
