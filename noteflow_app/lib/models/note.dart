import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'link_attachment.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
class Note with _$Note {
  const Note._();

  const factory Note({
    required String id,
    required String title,
    @Default('') String bodyJson,
    @Default([]) List<String> categoryIds,
    @Default([]) List<String> tags,
    @Default([]) List<LinkAttachment> links,
    @Default([]) List<String> attachmentUrls,
    @Default(false) bool isPinned,
    @Default(false) bool isArchived,
    @Default({}) Map<String, String> contextFields,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  factory Note.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Note(
      id:             doc.id,
      title:          (d['title'] as String?) ?? '',
      bodyJson:       (d['bodyJson'] as String?) ?? '',
      categoryIds:    List<String>.from(d['categoryIds'] as List? ?? []),
      tags:           List<String>.from(d['tags'] as List? ?? []),
      links:          ((d['links'] as List?) ?? [])
          .map((e) => LinkAttachment.fromMap(e as Map<String, dynamic>))
          .toList(),
      attachmentUrls: List<String>.from(d['attachmentUrls'] as List? ?? []),
      isPinned:       (d['isPinned'] as bool?) ?? false,
      isArchived:     (d['isArchived'] as bool?) ?? false,
      contextFields:  Map<String, String>.from(d['contextFields'] as Map? ?? {}),
      createdAt:      _tsToDate(d['createdAt']) ?? DateTime.now(),
      updatedAt:      _tsToDate(d['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    final m = toJson()..remove('id');
    m['links']     = links.map((l) => l.toMap()).toList();
    m['createdAt'] = Timestamp.fromDate(createdAt);
    m['updatedAt'] = Timestamp.fromDate(updatedAt);
    return m;
  }
}

DateTime? _tsToDate(dynamic v) {
  if (v == null) return null;
  if (v is Timestamp) return v.toDate();
  if (v is String) return DateTime.tryParse(v);
  return null;
}
