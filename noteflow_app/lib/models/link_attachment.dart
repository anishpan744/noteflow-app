import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_attachment.freezed.dart';
part 'link_attachment.g.dart';

@freezed
class LinkAttachment with _$LinkAttachment {
  const LinkAttachment._();

  const factory LinkAttachment({
    required String url,
    String? title,
    String? description,
    String? imageUrl,
    String? siteName,
    String? favicon,
  }) = _LinkAttachment;

  factory LinkAttachment.fromJson(Map<String, dynamic> json) =>
      _$LinkAttachmentFromJson(json);

  factory LinkAttachment.fromMap(Map<String, dynamic> d) => LinkAttachment(
        url:         d['url'] as String,
        title:       d['title'] as String?,
        description: d['description'] as String?,
        imageUrl:    d['imageUrl'] as String?,
        siteName:    d['siteName'] as String?,
        favicon:     d['favicon'] as String?,
      );

  Map<String, dynamic> toMap() => toJson();
}
