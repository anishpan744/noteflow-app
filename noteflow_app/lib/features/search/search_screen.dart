import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/design/tokens.dart';
import '../../models/category.dart';
import '../../models/note.dart';
import '../../models/task.dart';
import '../categories/category_providers.dart';
import '../notes/note_providers.dart';
import '../tasks/task_providers.dart';

enum SearchFilter { all, notes, tasks }

const _kRecentKey = 'recent_searches';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';
  SearchFilter _filter = SearchFilter.all;
  String? _categoryId;
  List<String> _recent = [];

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _recent = prefs.getStringList(_kRecentKey) ?? []);
  }

  Future<void> _saveRecent(String q) async {
    final query = q.trim();
    if (query.isEmpty) return;
    final next = [query, ..._recent.where((r) => r != query)].take(8).toList();
    setState(() => _recent = next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kRecentKey, next);
  }

  Future<void> _clearRecent() async {
    setState(() => _recent = []);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kRecentKey);
  }

  @override
  Widget build(BuildContext context) {
    final tt    = Theme.of(context).textTheme;
    final notes = ref.watch(notesStreamProvider).valueOrNull ?? [];
    final tasks = ref.watch(allTasksProvider).valueOrNull ?? [];
    final cats  = ref.watch(categoriesProvider).valueOrNull ?? [];

    final q = _query.trim().toLowerCase();

    // Filter notes
    final noteHits = (q.isEmpty)
        ? <Note>[]
        : notes.where((n) {
            if (_categoryId != null && !n.categoryIds.contains(_categoryId)) {
              return false;
            }
            return n.title.toLowerCase().contains(q) ||
                _plain(n.bodyJson).toLowerCase().contains(q) ||
                n.tags.any((t) => t.toLowerCase().contains(q));
          }).toList();

    // Filter tasks
    final taskHits = (q.isEmpty)
        ? <Task>[]
        : tasks.where((t) {
            if (_categoryId != null && !t.categoryIds.contains(_categoryId)) {
              return false;
            }
            return t.title.toLowerCase().contains(q) ||
                t.description.toLowerCase().contains(q);
          }).toList();

    final showNotes = _filter != SearchFilter.tasks;
    final showTasks = _filter != SearchFilter.notes;

    return Scaffold(
      backgroundColor: kBg0,
      appBar: AppBar(
        backgroundColor: kBg0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: kTextPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Hero(
          tag: 'search-bar',
          child: Material(
            color: Colors.transparent,
            child: TextField(
              controller: _ctrl,
              autofocus: true,
              style: tt.bodyLarge,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search notes & tasks…',
                hintStyle: TextStyle(color: kTextMuted),
                border: InputBorder.none,
                filled: false,
              ),
              onChanged: (v) => setState(() => _query = v),
              onSubmitted: _saveRecent,
            ),
          ),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(PhosphorIconsRegular.x, color: kTextMuted),
              onPressed: () {
                _ctrl.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter row
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _filterChip('All', _filter == SearchFilter.all && _categoryId == null,
                    () => setState(() { _filter = SearchFilter.all; _categoryId = null; })),
                _filterChip('Notes', _filter == SearchFilter.notes,
                    () => setState(() => _filter = SearchFilter.notes)),
                _filterChip('Tasks', _filter == SearchFilter.tasks,
                    () => setState(() => _filter = SearchFilter.tasks)),
                ...cats.map((c) {
                  final color = _hex(c.colorHex);
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: () => setState(() =>
                          _categoryId = _categoryId == c.id ? null : c.id),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: _categoryId == c.id
                              ? color.withValues(alpha: 0.2)
                              : kBg2,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _categoryId == c.id ? color : kGlassBorder,
                          ),
                        ),
                        child: Text(c.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: _categoryId == c.id ? color : kTextSecondary,
                            )),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Body
          Expanded(
            child: q.isEmpty
                ? _recentView(tt)
                : _resultsView(tt, cats, showNotes ? noteHits : [],
                    showTasks ? taskHits : []),
          ),
        ],
      ),
    );
  }

  // ── Recent searches ─────────────────────────────────────────────────────────

  Widget _recentView(TextTheme tt) {
    if (_recent.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(PhosphorIconsRegular.magnifyingGlass,
                color: kTextMuted, size: 48),
            const SizedBox(height: 12),
            Text('Search across notes and tasks', style: tt.bodySmall),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Recent', style: tt.labelMedium?.copyWith(color: kTextMuted)),
              const Spacer(),
              GestureDetector(
                onTap: _clearRecent,
                child: Text('Clear',
                    style: tt.labelMedium?.copyWith(color: kCrimson)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recent.map((r) {
              return GestureDetector(
                onTap: () {
                  _ctrl.text = r;
                  setState(() => _query = r);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kGlassBorder),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(PhosphorIconsRegular.clockCounterClockwise,
                        size: 13, color: kTextMuted),
                    const SizedBox(width: 6),
                    Text(r, style: tt.bodySmall),
                  ]),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Results ──────────────────────────────────────────────────────────────────

  Widget _resultsView(
    TextTheme tt,
    List<Category> cats,
    List<Note> noteHits,
    List<Task> taskHits,
  ) {
    if (noteHits.isEmpty && taskHits.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(PhosphorIconsRegular.smileySad,
                color: kTextMuted, size: 48),
            const SizedBox(height: 12),
            Text('No matches for "$_query"', style: tt.bodySmall),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        if (noteHits.isNotEmpty) ...[
          _groupHeader(tt, 'Notes', noteHits.length, kNeon),
          ...noteHits.map((n) => _noteTile(tt, n, cats)),
          const SizedBox(height: 12),
        ],
        if (taskHits.isNotEmpty) ...[
          _groupHeader(tt, 'Tasks', taskHits.length, kViolet),
          ...taskHits.map((t) => _taskTile(tt, t, cats)),
        ],
      ],
    );
  }

  Widget _groupHeader(TextTheme tt, String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Text(label, style: tt.titleMedium?.copyWith(color: color)),
        const SizedBox(width: 6),
        Text('$count', style: tt.labelMedium?.copyWith(color: kTextMuted)),
      ]),
    );
  }

  Widget _noteTile(TextTheme tt, Note n, List<Category> cats) {
    final color = n.categoryIds.isNotEmpty
        ? _hex(cats.where((c) => c.id == n.categoryIds.first).firstOrNull
                ?.colorHex ?? '#00D4FF')
        : kNeon;
    return GestureDetector(
      onTap: () {
        _saveRecent(_query);
        context.push('/notes/${n.id}/edit');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kBg2,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _highlighted(n.title.isEmpty ? 'Untitled' : n.title,
                tt.titleSmall!),
            const SizedBox(height: 2),
            _highlighted(
              _snippet(_plain(n.bodyJson)),
              tt.bodySmall!.copyWith(color: kTextSecondary),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _taskTile(TextTheme tt, Task t, List<Category> cats) {
    final color = t.categoryIds.isNotEmpty
        ? _hex(cats.where((c) => c.id == t.categoryIds.first).firstOrNull
                ?.colorHex ?? '#7B61FF')
        : kViolet;
    return GestureDetector(
      onTap: () {
        _saveRecent(_query);
        context.push('/tasks/${t.id}/edit');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kBg2,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _highlighted(t.title, tt.titleSmall!),
            if (t.description.isNotEmpty) ...[
              const SizedBox(height: 2),
              _highlighted(_snippet(t.description),
                  tt.bodySmall!.copyWith(color: kTextSecondary),
                  maxLines: 2),
            ],
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: selected ? kNeon.withValues(alpha: 0.15) : kBg2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? kNeon : kGlassBorder),
          ),
          child: Text(label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? kNeon : kTextSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              )),
        ),
      ),
    );
  }

  /// Builds a Text with the query substring highlighted in kNeon.
  Widget _highlighted(String text, TextStyle base, {int maxLines = 1}) {
    final q = _query.trim();
    if (q.isEmpty) {
      return Text(text, style: base, maxLines: maxLines,
          overflow: TextOverflow.ellipsis);
    }
    final spans = <TextSpan>[];
    final lower = text.toLowerCase();
    final ql = q.toLowerCase();
    var start = 0;
    while (true) {
      final idx = lower.indexOf(ql, start);
      if (idx < 0) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + q.length),
        style: const TextStyle(color: kNeon, fontWeight: FontWeight.w700),
      ));
      start = idx + q.length;
    }
    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(style: base, children: spans),
    );
  }

  String _snippet(String text) =>
      text.length > 120 ? '${text.substring(0, 120)}…' : text;

  Color _hex(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return kNeon;
    }
  }

  String _plain(String bodyJson) {
    if (bodyJson.isEmpty) return '';
    try {
      return bodyJson
          .replaceAll(RegExp(r'\{"insert":"'), '')
          .replaceAll(RegExp(r'"[^}]*\}'), '')
          .replaceAll(RegExp(r'[{}\[\]"\\]'), '')
          .replaceAll('insert:', '')
          .replaceAll('\\n', ' ')
          .trim();
    } catch (_) {
      return '';
    }
  }
}
