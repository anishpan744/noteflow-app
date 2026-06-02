import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/design/tokens.dart';
import '../../core/utils/debouncer.dart';
import '../../core/widgets/color_flag_chip.dart';
import '../../core/widgets/context_field_row.dart';
import '../../data/repositories/note_repository.dart';
import '../../features/categories/category_providers.dart';
import '../../models/note.dart';
import 'note_providers.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({super.key, required this.noteId});
  final String noteId;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _titleCtrl    = TextEditingController();
  late QuillController _quillCtrl;
  final _debouncer    = Debouncer(delay: const Duration(milliseconds: 500));
  final _titleFocus   = FocusNode();
  final _bodyFocus    = FocusNode();

  Note? _note;
  bool _metaExpanded = false;
  bool _saving       = false;
  bool _saved        = false;
  bool _initialized  = false;

  @override
  void initState() {
    super.initState();
    _quillCtrl = QuillController.basic();
    _quillCtrl.document.changes.listen((_) => _onChanged());
    _titleCtrl.addListener(_onChanged);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _titleCtrl.dispose();
    _quillCtrl.dispose();
    _titleFocus.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  void _initNote(Note note) {
    if (_initialized) return;
    _initialized = true;
    _note = note;
    _titleCtrl.text = note.title;
    if (note.bodyJson.isNotEmpty) {
      try {
        final delta = jsonDecode(note.bodyJson);
        _quillCtrl = QuillController(
          document:  Document.fromJson(delta as List),
          selection: const TextSelection.collapsed(offset: 0),
        );
        _quillCtrl.document.changes.listen((_) => _onChanged());
      } catch (_) {}
    }
  }

  void _onChanged() {
    setState(() { _saving = true; _saved = false; });
    _debouncer.run(_save);
  }

  Future<void> _save() async {
    if (!mounted) return;
    final now = DateTime.now();
    final body = jsonEncode(_quillCtrl.document.toDelta().toJson());

    final note = (_note ?? Note(
      id:        widget.noteId,
      title:     '',
      createdAt: now,
      updatedAt: now,
    )).copyWith(
      title:     _titleCtrl.text.trim(),
      bodyJson:  body,
      updatedAt: now,
    );

    _note = note;
    await ref.read(noteControllerProvider.notifier).save(note);
    if (mounted) setState(() { _saving = false; _saved = true; });
  }

  @override
  Widget build(BuildContext context) {
    // Load existing note on first build
    final existing = ref.watch(
      StreamProvider.autoDispose<Note?>((ref) =>
          ref.watch(noteRepositoryProvider).watchById(widget.noteId)),
    ).valueOrNull;

    if (existing != null && !_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _initNote(existing));
      });
    } else if (!_initialized && _note == null) {
      // Brand-new note — just mark as initialized
      _initialized = true;
      _note = Note(
        id:        widget.noteId,
        title:     '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: kBg0,
      appBar: AppBar(
        backgroundColor: kBg0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: kTextPrimary),
          onPressed: () {
            _debouncer.dispose();
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        title: Text(
          _titleCtrl.text.isEmpty ? 'New Note' : _titleCtrl.text,
          style: tt.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // Meta toggle
          IconButton(
            icon: Icon(
              _metaExpanded
                  ? PhosphorIconsRegular.caretUp
                  : PhosphorIconsRegular.slidersHorizontal,
              color: kTextSecondary,
              size: 20,
            ),
            onPressed: () => setState(() => _metaExpanded = !_metaExpanded),
          ),
          // Pin
          IconButton(
            icon: Icon(
              _note?.isPinned == true
                  ? PhosphorIconsFill.pushPin
                  : PhosphorIconsRegular.pushPin,
              color: _note?.isPinned == true ? kAmber : kTextSecondary,
              size: 20,
            ),
            onPressed: () {
              if (_note == null) return;
              final updated = _note!.copyWith(isPinned: !_note!.isPinned);
              _note = updated;
              ref.read(noteControllerProvider.notifier).save(updated);
              setState(() {});
            },
          ),
          // Archive
          IconButton(
            icon: const Icon(PhosphorIconsRegular.archive,
                color: kTextSecondary, size: 20),
            onPressed: () {
              if (_note == null) return;
              ref
                  .read(noteControllerProvider.notifier)
                  .archive(widget.noteId, archived: true);
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
          // Delete
          IconButton(
            icon: const Icon(PhosphorIconsRegular.trash,
                color: kCrimson, size: 20),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Save indicator
          if (_saving || _saved)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _saving ? 'Saving…' : 'Saved ✓',
                    style: TextStyle(
                      fontSize: 11,
                      color: _saving ? kTextMuted : kTeal,
                      fontFamily: 'JetBrainsMono',
                    ),
                  ),
                ],
              ),
            ),

          // Metadata panel
          if (_metaExpanded) _MetaPanel(note: _note, onChanged: _updateMeta),

          // Title field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _titleCtrl,
              focusNode: _titleFocus,
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: kTextPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Untitled',
                hintStyle: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: kTextMuted,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),

          // Quill toolbar
          Container(
            color: kBg1,
            child: QuillSimpleToolbar(
              configurations: QuillSimpleToolbarConfigurations(
                controller:               _quillCtrl,
                showFontFamily:           false,
                showFontSize:             false,
                showBackgroundColorButton: false,
                showColorButton:          false,
                showAlignmentButtons:     false,
                showIndent:               false,
                showSearchButton:         false,
                showSubscript:            false,
                showSuperscript:          false,
              ),
            ),
          ),

          // Quill editor
          Expanded(
            child: GestureDetector(
              onTap: () => _bodyFocus.requestFocus(),
              child: Container(
                color: kBg0,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: QuillEditor(
                  focusNode:        _bodyFocus,
                  scrollController: ScrollController(),
                  configurations:   QuillEditorConfigurations(
                    controller: _quillCtrl,
                    placeholder: 'Start writing…',
                    padding:     EdgeInsets.zero,
                    autoFocus:   false,
                    expands:     true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateMeta(Note updated) {
    _note = updated;
    ref.read(noteControllerProvider.notifier).save(updated);
    setState(() {});
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kBg2,
        title: Text('Delete note?',
            style: Theme.of(ctx).textTheme.titleMedium),
        content: Text('This action cannot be undone.',
            style: Theme.of(ctx).textTheme.bodySmall),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: kTextSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: kCrimson)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      // ignore: use_build_context_synchronously
      final nav = Navigator.of(context);
      await ref.read(noteControllerProvider.notifier).delete(widget.noteId);
      if (mounted) nav.pop();
    }
  }
}

// ── Metadata panel ────────────────────────────────────────────────────────────

class _MetaPanel extends ConsumerWidget {
  const _MetaPanel({required this.note, required this.onChanged});
  final Note? note;
  final void Function(Note) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider).valueOrNull ?? [];
    final tt         = Theme.of(context).textTheme;
    final n          = note;
    if (n == null) return const SizedBox.shrink();

    return Container(
      color: kBg1,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories
          if (categories.isNotEmpty) ...[
            Text('Categories', style: tt.labelSmall?.copyWith(color: kTextMuted)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: categories.map((c) {
                final color = _hexColor(c.colorHex);
                final selected = n.categoryIds.contains(c.id);
                return ColorFlagChip(
                  label: c.name,
                  color: color,
                  selected: selected,
                  small: true,
                  onTap: () {
                    final ids = List<String>.from(n.categoryIds);
                    selected ? ids.remove(c.id) : ids.add(c.id);
                    onChanged(n.copyWith(categoryIds: ids));
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Tags
          Text('Tags', style: tt.labelSmall?.copyWith(color: kTextMuted)),
          const SizedBox(height: 6),
          _TagField(
            tags: n.tags,
            onChanged: (tags) => onChanged(n.copyWith(tags: tags)),
          ),
          const SizedBox(height: 12),

          // Context fields
          if (n.contextFields.isNotEmpty) ...[
            Text('Info', style: tt.labelSmall?.copyWith(color: kTextMuted)),
            const SizedBox(height: 4),
            ...n.contextFields.entries.map((e) => ContextFieldRow(
                  fieldKey: e.key,
                  value:    e.value,
                  onChanged: (k, v) {
                    final fields = Map<String, String>.from(n.contextFields);
                    fields.remove(e.key);
                    fields[k] = v;
                    onChanged(n.copyWith(contextFields: fields));
                  },
                  onDelete: () {
                    final fields = Map<String, String>.from(n.contextFields);
                    fields.remove(e.key);
                    onChanged(n.copyWith(contextFields: fields));
                  },
                )),
          ],

          // Add field button
          GestureDetector(
            onTap: () {
              final fields = Map<String, String>.from(n.contextFields);
              fields['Key ${fields.length + 1}'] = '';
              onChanged(n.copyWith(contextFields: fields));
            },
            child: Row(
              children: [
                const Icon(PhosphorIconsRegular.plus, size: 14, color: kTextMuted),
                const SizedBox(width: 4),
                Text('Add field', style: tt.bodySmall?.copyWith(color: kTextMuted)),
              ],
            ),
          ),

          // Timestamps
          const SizedBox(height: 8),
          Text(
            'Created ${_fmt(n.createdAt)} · Edited ${_fmt(n.updatedAt)}',
            style: tt.labelSmall?.copyWith(color: kTextMuted),
          ),
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

  String _fmt(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

// ── Tag field ─────────────────────────────────────────────────────────────────

class _TagField extends StatefulWidget {
  const _TagField({required this.tags, required this.onChanged});
  final List<String> tags;
  final void Function(List<String>) onChanged;

  @override
  State<_TagField> createState() => _TagFieldState();
}

class _TagFieldState extends State<_TagField> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _addTag(String value) {
    final tag = value.trim().replaceAll('#', '');
    if (tag.isEmpty || widget.tags.contains(tag)) {
      _ctrl.clear();
      return;
    }
    widget.onChanged([...widget.tags, tag]);
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ...widget.tags.map((t) => GestureDetector(
              onTap: () {
                final tags = List<String>.from(widget.tags)..remove(t);
                widget.onChanged(tags);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kViolet.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kViolet.withValues(alpha: 0.4)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('#$t',
                      style: const TextStyle(
                          fontSize: 12, color: kViolet, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 4),
                  const Icon(Icons.close, size: 12, color: kViolet),
                ]),
              ),
            )),
        SizedBox(
          width: 100,
          child: TextField(
            controller: _ctrl,
            style: const TextStyle(fontSize: 12, color: kTextPrimary),
            decoration: const InputDecoration(
              hintText: 'Add tag…',
              hintStyle: TextStyle(fontSize: 12, color: kTextMuted),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            onSubmitted: _addTag,
          ),
        ),
      ],
    );
  }
}
