import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/note_repository.dart';
import '../../models/note.dart';

// ── Sort order ────────────────────────────────────────────────────────────────

enum NoteSortOrder { updatedDesc, createdDesc, titleAsc }

// ── State providers ───────────────────────────────────────────────────────────

final noteSearchQueryProvider    = StateProvider<String>((_)    => '');
final selectedCategoryFilterProvider = StateProvider<String?>((_) => null);
final sortOrderProvider          = StateProvider<NoteSortOrder>((_) => NoteSortOrder.updatedDesc);
final noteViewGridProvider       = StateProvider<bool>((_)      => false);

// ── Stream providers ──────────────────────────────────────────────────────────

final notesStreamProvider = StreamProvider<List<Note>>((ref) {
  return ref.watch(noteRepositoryProvider).watchAll();
});

final pinnedNotesProvider = StreamProvider<List<Note>>((ref) {
  return ref.watch(noteRepositoryProvider).watchPinned();
});

final filteredNotesProvider = Provider<List<Note>>((ref) {
  final notes    = ref.watch(notesStreamProvider).valueOrNull ?? [];
  final query    = ref.watch(noteSearchQueryProvider).toLowerCase().trim();
  final catId    = ref.watch(selectedCategoryFilterProvider);
  final sort     = ref.watch(sortOrderProvider);

  var filtered = notes.where((n) => !n.isPinned && !n.isArchived).toList();

  if (catId != null) {
    filtered = filtered.where((n) => n.categoryIds.contains(catId)).toList();
  }

  if (query.isNotEmpty) {
    filtered = filtered.where((n) {
      return n.title.toLowerCase().contains(query) ||
          n.bodyJson.toLowerCase().contains(query) ||
          n.tags.any((t) => t.toLowerCase().contains(query));
    }).toList();
  }

  switch (sort) {
    case NoteSortOrder.updatedDesc:
      filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    case NoteSortOrder.createdDesc:
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    case NoteSortOrder.titleAsc:
      filtered.sort((a, b) => a.title.compareTo(b.title));
  }

  return filtered;
});

// ── Controller ────────────────────────────────────────────────────────────────

class NoteController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  NoteRepository get _repo => ref.read(noteRepositoryProvider);

  Future<void> save(Note note) async {
    state = await AsyncValue.guard(() => _repo.save(note));
  }

  Future<void> delete(String id) async {
    state = await AsyncValue.guard(() => _repo.delete(id));
  }

  Future<void> archive(String id, {required bool archived}) async {
    state = await AsyncValue.guard(
        () => _repo.archive(id, archived: archived));
  }

  Future<void> pin(String id, {required bool pinned}) async {
    state = await AsyncValue.guard(() => _repo.pin(id, pinned: pinned));
  }
}

final noteControllerProvider =
    AsyncNotifierProvider<NoteController, void>(NoteController.new);
