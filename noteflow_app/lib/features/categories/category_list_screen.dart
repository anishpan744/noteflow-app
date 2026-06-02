import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/design/tokens.dart';
import '../../core/design/animations.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/neon_button.dart';
import '../../models/category.dart';
import '../../models/enums.dart';
import 'category_form.dart';
import 'category_providers.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: kBg0,
      appBar: AppBar(
        backgroundColor: kBg0,
        title: Text('Categories', style: tt.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.plus, color: kNeon),
            onPressed: () => _showForm(context, ref, null),
          ),
        ],
      ),
      body: categoriesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: kNeon, strokeWidth: 1.5),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: tt.bodySmall?.copyWith(color: kCrimson)),
        ),
        data: (categories) {
          if (categories.isEmpty) return _EmptyState(onAdd: () => _showForm(context, ref, null));
          return _CategoryList(
            categories: categories,
            onEdit:    (c) => _showForm(context, ref, c),
            onDelete:  (c) => _confirmDelete(context, ref, c),
            onReorder: (ordered) =>
                ref.read(categoryControllerProvider.notifier).reorder(ordered),
          );
        },
      ),
    );
  }

  Future<void> _showForm(BuildContext context, WidgetRef ref, Category? existing) {
    return showModalBottomSheet(
      context:           context,
      isScrollControlled: true,
      backgroundColor:   Colors.transparent,
      builder: (_) => CategoryForm(existing: existing),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Category category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kBg2,
        title: Text('Delete "${category.name}"?', style: Theme.of(ctx).textTheme.titleMedium),
        content: Text(
          'This will remove the category from all notes and tasks.',
          style: Theme.of(ctx).textTheme.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: kTextSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: kCrimson)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(categoryControllerProvider.notifier).delete(category.id);
    }
  }
}

// ── Category list with drag-to-reorder ───────────────────────────────────────

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.categories,
    required this.onEdit,
    required this.onDelete,
    required this.onReorder,
  });

  final List<Category> categories;
  final void Function(Category) onEdit;
  final void Function(Category) onDelete;
  final void Function(List<Category>) onReorder;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: categories.length,
      onReorder: (oldIndex, newIndex) {
        final reordered = List<Category>.from(categories);
        if (newIndex > oldIndex) newIndex--;
        final item = reordered.removeAt(oldIndex);
        reordered.insert(newIndex, item);
        onReorder(reordered);
      },
      itemBuilder: (_, i) {
        final c = categories[i];
        return _CategoryTile(
          key:      ValueKey(c.id),
          category: c,
          onEdit:   () => onEdit(c),
          onDelete: () => onDelete(c),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  Color get _color {
    try {
      final hex = category.colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return kNeon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final color = _color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Drag handle
            Icon(PhosphorIconsRegular.dotsSixVertical,
                color: kTextMuted, size: 18),
            const SizedBox(width: 12),

            // Color dot
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6)
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Name + module badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.name, style: tt.titleMedium),
                  const SizedBox(height: 2),
                  _ModuleBadge(module: category.module),
                ],
              ),
            ),

            // Actions
            IconButton(
              icon: const Icon(PhosphorIconsRegular.pencilSimple,
                  color: kTextSecondary, size: 18),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(PhosphorIconsRegular.trash,
                  color: kCrimson, size: 18),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleBadge extends StatelessWidget {
  const _ModuleBadge({required this.module});
  final CategoryModule module;

  String get _label => switch (module) {
        CategoryModule.note   => 'Notes',
        CategoryModule.task   => 'Tasks',
        CategoryModule.shared => 'Both',
      };

  Color get _color => switch (module) {
        CategoryModule.note   => kNeon,
        CategoryModule.task   => kViolet,
        CategoryModule.shared => kTeal,
      };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kDurationFast,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 10,
          color: _color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(PhosphorIconsRegular.tag,
              color: kTextMuted, size: 64),
          const SizedBox(height: 16),
          Text('No categories yet', style: tt.titleMedium?.copyWith(color: kTextSecondary)),
          const SizedBox(height: 8),
          Text('Create your first category to organise notes and tasks.',
              style: tt.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          NeonButton(
            label: 'Create Category',
            icon: const Icon(PhosphorIconsRegular.plus),
            onTap: onAdd,
          ),
        ],
      ),
    );
  }
}
