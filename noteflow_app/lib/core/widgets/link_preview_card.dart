import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../design/tokens.dart';
import 'glass_card.dart';

/// Data model for an OpenGraph link preview.
class LinkPreview {
  const LinkPreview({
    required this.url,
    this.title,
    this.description,
    this.imageUrl,
    this.siteName,
    this.favicon,
  });

  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? siteName;
  final String? favicon;

  String get displayDomain {
    try {
      return Uri.parse(url).host.replaceFirst('www.', '');
    } catch (_) {
      return url;
    }
  }
}

class LinkPreviewCard extends StatelessWidget {
  const LinkPreviewCard({
    super.key,
    required this.preview,
    this.onTap,
    this.onDelete,
  });

  final LinkPreview preview;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: EdgeInsets.zero,
        borderRadius: 12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview image
            if (preview.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: preview.imageUrl!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 140,
                    color: kBg2,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: kNeon,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(height: 140, color: kBg2),
                ),
              ),

            // Text content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Favicon
                  if (preview.favicon != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: preview.favicon!,
                        width: 16,
                        height: 16,
                        errorWidget: (_, __, ___) => const Icon(
                          Icons.link,
                          size: 16,
                          color: kTextMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Site name
                        Text(
                          preview.siteName ?? preview.displayDomain,
                          style: tt.labelSmall?.copyWith(color: kNeon),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        // Title
                        if (preview.title != null)
                          Text(
                            preview.title!,
                            style: tt.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        // Description
                        if (preview.description != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            preview.description!,
                            style: tt.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Delete button
                  if (onDelete != null)
                    GestureDetector(
                      onTap: onDelete,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.close, size: 16, color: kTextMuted),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
