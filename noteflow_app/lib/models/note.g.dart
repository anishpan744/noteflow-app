// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      bodyJson: json['bodyJson'] as String? ?? '',
      categoryIds: (json['categoryIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      links: (json['links'] as List<dynamic>?)
              ?.map((e) => LinkAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      attachmentUrls: (json['attachmentUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isPinned: json['isPinned'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      contextFields: (json['contextFields'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'bodyJson': instance.bodyJson,
      'categoryIds': instance.categoryIds,
      'tags': instance.tags,
      'links': instance.links,
      'attachmentUrls': instance.attachmentUrls,
      'isPinned': instance.isPinned,
      'isArchived': instance.isArchived,
      'contextFields': instance.contextFields,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
