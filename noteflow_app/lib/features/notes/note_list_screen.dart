import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../core/design/animations.dart';
import '../../core/design/tokens.dart';
import '../../core/widgets/color_flag_chip.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/neon_button.dart';
import '../../features/categories/category_providers.dart';
import '../../models/note.dart';
import 'note_providers.dart';

class NoteListScreen extends ConsumerStatefulWidget {
  const NoteListScreen({super.key});

  @override
  ConsumerState<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends ConsumerState<NoteListScreen> {
  final _searchCtrl = TextEditingController();
  bool _searchExpanded = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt       = Theme.of(context).textTheme;
    final pinned   = ref.watch(pinnedNotesProvider).valueOrNull ?? [];
    final notes    = ref.watch(filteredNotesProvider);
    final isGrid   = ref.watch(noteViewGridProvider);
    final sort     = ref.watch(sortOrderProvider);

    return Scaffold(
      backgroundColor: kBg0,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  // Search bar
                  Expanded(
                    child: AnimatedContainer(
                      duration: kDurationMed,
                      curve: kCurveOut,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _searchExpanded ? kBg2 : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _searchExpanded ? kNeon.withValues(alpha: 0.4) : Colors.transparent,
                        ),
                      ),
                      child: _searchExpanded
                          ? TextField(
                              controller: _searchCtrl,
                              autofocus: true,
                              style: tt.bodyMedium,
                              decoration: InputDecoration(
                                hintText: 'Search notes…',
                                hintStyle: const TextStyle(color: kTextMuted),
                                prefixIcon: const Icon(PhosphorIconsRegular.magnifyingGlass,
                                    color: kNeon, size: 18),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _searchCtrl.clear();
                                    ref.read(noteSearchQueryProvider.notifier).state = '';
                                    setState(() => _searchExpanded = false);
                                  },
                                  child: const Icon(PhosphorIconsRegular.x,
                                      color: kTextMuted, size: 16),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onChanged: (v) =>
                                  ref.read(noteSearchQueryProvider.notifier).state = v,
                            )
                          : GestureDetector(
                              onTap: () => setState(() => _searchExpanded = true),
                              child: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  Text('Notes', style: tt.headlineMedium),
                                ],
                              ),
                            ),
                    ),
                  ),

                  // Sort button
                  if (!_searchExpanded) ...[
                    const SizedBox(width: 8),
                    _IconBtn(
                      icon: PhosphorIconsRegular.sortAscending,
                      onTap: () => _showSortSheet(context),
                      active: sort != NoteSortOrder.updatedDesc,
                    ),
                    const SizedBox(width: 4),
                    // Grid/List toggle
                    _IconBtn(
                      icon: isGrid
                          ? PhosphorIconsRegular.rows
                          : PhosphorIconsRegular.squaresFour,
                      onTap: () => ref
                          .read(noteViewGridProvider.notifier)
                          .state = !isGrid,
                    ),
                    const SizedBox(width: 4),
                    // Search icon
                    _IconBtn(
                      icon: PhosphorIconsRegular.magnifyingGlass,
                      onTap: () => setState(() => _searchExpanded = true),
                    ),
                  ],
                ],
              ),
            ),

            // ── Category filter strip ───────────────────────────────────────
            _CategoryFilterStrip(),

            // ── Content ────────────────────────────────────────────────────
            Expanded(
              child: pinned.isEmpty && notes.isEmpty
                  ? _EmptyState(onAdd: () => _newNote(context))
                  : _NoteContent(
                      pinned:  pinned,
                      notes:   notes,
                      isGrid:  isGrid,
                      onAdd:   () => _newNote(context),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _NewNoteFAB(onTap: () => _newNote(context)),
    );
  }

  void _newNote(BuildContext context) {
    final id = const Uuid().v4();
    context.push('/notes/$id/edit');
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kBg1,
      builder: (_) => _SortSheet(),
    );
  }
}

// ── Category filter strip ─────────────────────────────────────────────────────

class _CategoryFilterStrip extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider).valueOrNull ?? [];
    final selected   = ref.watch(selectedCategoryFilterProvider);

    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ColorFlagChip(
              label: 'All',
              color: kNeon,
              selected: selected == null,
              onTap: () => ref
                  .read(selectedCategoryFilterProvider.notifier)
                  .state = null,
            ),
          ),
          ...categories.map((c) {
            final color = _hexColor(c.colorHex);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ColorFlagChip(
                label: c.name,
                color: color,
                selected: selected == c.id,
                onTap: () => ref
                    .read(selectedCategoryFilterProvider.notifier)
                    .state = selected == c.id ? null : c.id,
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _hexColor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return kNeon;
    }
  }
}

// ── Note content ──────────────────────────────────────────────────────────────

class _NoteContent extends StatelessWidget {
  const _NoteContent({
    required this.pinned,
    required this.notes,
    required this.isGrid,
    required this.onAdd,
  });

  final List<Note> pinned;
  final List<Note> notes;
  final bool isGrid;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Pinned section
        if (pinned.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(children: [
                const Icon(PhosphorIconsFill.pushPin, color: kAmber, size: 14),
                const SizedBox(width: 6),
                Text('Pinned',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: kAmber)),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _NoteGrid(notes: pinned, isGrid: isGrid),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('All Notes',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: kTextMuted)),
            ),
          ),
        ],

        // All notes
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
          sliver: notes.isEmpty
              ? SliverToBoxAdapter(child: _EmptyState(onAdd: onAdd))
              : _NoteGrid(notes: notes, isGrid: isGrid),
        ),
      ],
    );
  }
}

class _NoteGrid extends StatelessWidget {
  const _NoteGrid({required this.notes, required this.isGrid});
  final List<Note> notes;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, i) => _NoteCard(note: notes[i]),
          childCount: notes.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, i) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _NoteCard(note: notes[i]),
        ),
        childCount: notes.length,
      ),
    );
  }
}

// ── Note card ─────────────────────────────────────────────────────────────────

class _NoteCard extends ConsumerWidget {
  const _NoteCard({required this.note});
  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt         = Theme.of(context).textTheme;
    final categories = ref.watch(categoriesProvider).valueOrNull ?? [];
    final noteCategories = categories
        .where((c) => note.categoryIds.contains(c.id))
        .toList();

    final borderColor = noteCategories.isNotEmpty
        ? _hexColor(noteCategories.first.colorHex)
        : kGlassBorder;

    return GestureDetector(
      onTap: () => context.push('/notes/${note.id}/edit'),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              left: BorderSide(color: borderColor, width: 3)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: GlassCard(
          borderRadius: 14,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                note.title.isEmpty ? 'Untitled' : note.title,
                style: tt.titleMedium?.copyWith(
                  fontFamily: 'Rajdhani',
                  fontSize: 16,
                  color: note.title.isEmpty ? kTextMuted : kTextPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Body preview
              Expanded(
                child: Text(
                  _bodyPreview(note.bodyJson),
                  style: tt.bodySmall,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Tags
              if (note.tags.isNotEmpty) ...[
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  children: note.tags
                      .take(3)
                      .map((t) => Text(
                            '#$t',
                            style: TextStyle(
                              fontSize: 11,
                              color: borderColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ))
                      .toList(),
                ),
              ],

              // Bottom row
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    _formatDate(note.updatedAt),
                    style: tt.labelSmall,
                  ),
                  const Spacer(),
                  if (note.links.isNotEmpty)
                    Icon(PhosphorIconsRegular.link, size: 12, color: kTextMuted),
                  if (note.isPinned) ...[
                    const SizedBox(width: 4),
                    const Icon(PhosphorIconsFill.pushPin, size: 12, color: kAmber),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _bodyPreview(String bodyJson) {
    if (bodyJson.isEmpty) return '';
    try {
      // Extract plain text from quill delta JSON
      final text = bodyJson
          .replaceAll(RegExp(r'\{"insert":"'), '')
          .replaceAll(RegExp(r'"[^}]*\}'), '')
          .replaceAll(RegExp(r'[{}\[\]"\\]'), '')
          .replaceAll('insert:', '')
          .replaceAll('\\n', '\n')
          .trim();
      return text.length > 200 ? text.substring(0, 200) : text;
    } catch (_) {
      return '';
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  Color _hexColor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return kNeon;
    }
  }
}

// ── Sort sheet ────────────────────────────────────────────────────────────────

class _SortSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(sortOrderProvider);
    final tt   = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sort by', style: tt.headlineMedium),
          const SizedBox(height: 16),
          ...NoteSortOrder.values.map((s) {
            final label = switch (s) {
              NoteSortOrder.updatedDesc => 'Last edited',
              NoteSortOrder.createdDesc => 'Date created',
              NoteSortOrder.titleAsc   => 'Title A–Z',
            };
            return ListTile(
              title: Text(label, style: tt.bodyMedium),
              trailing: s == sort
                  ? const Icon(PhosphorIconsRegular.check, color: kNeon)
                  : null,
              onTap: () {
                ref.read(sortOrderProvider.notifier).state = s;
                Navigator.pop(context);
              },
            );
          }),
        ],
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
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(PhosphorIconsRegular.notepad, color: kTextMuted, size: 64),
            const SizedBox(height: 16),
            Text('No notes yet', style: tt.titleMedium?.copyWith(color: kTextSecondary)),
            const SizedBox(height: 8),
            Text('Tap + to capture your first thought.',
                style: tt.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            NeonButton(
              label: 'New Note',
              icon: const Icon(PhosphorIconsRegular.plus),
              onTap: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}

// ── FAB ───────────────────────────────────────────────────────────────────────

class _NewNoteFAB extends StatelessWidget {
  const _NewNoteFAB({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return NeonButton(
      label: '',
      icon: const Icon(PhosphorIconsRegular.plus, size: 24),
      color: kNeon,
      onTap: onTap,
    );
  }
}

// ── Helper ────────────────────────────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap, this.active = false});
  final PhosphorIconData icon;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active ? kNeon.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: active ? kNeon : kTextSecondary, size: 20),
      ),
    );
  }
}
