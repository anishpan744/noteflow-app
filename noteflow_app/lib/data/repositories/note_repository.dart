import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/note.dart';
import '../local/app_database.dart';
import '../local/notes_dao.dart';
import '../remote/firestore_notes_datasource.dart';
import 'sync_service.dart';

class NoteRepository {
  NoteRepository({
    required NotesDao dao,
    required FirestoreNotesDatasource remote,
    required SyncService sync,
  })  : _dao = dao,
        _remote = remote,
        _sync = sync {
    // Mirror Firestore → Drift in background
    _remote.watchAll().listen(
      (notes) async {
        for (final n in notes) {
          await _dao.upsert(n);
          await _dao.markSynced(n.id);
        }
      },
      onError: (_) {},
    );
  }

  final NotesDao _dao;
  final FirestoreNotesDatasource _remote;
  final SyncService _sync;

  // ── Read ──────────────────────────────────────────────────────────────────

  Stream<List<Note>> watchAll() => _dao.watchAll();
  Stream<Note?> watchById(String id) => _dao.watchById(id);
  Stream<List<Note>> watchPinned() => _dao.watchPinned();

  // ── Write ─────────────────────────────────────────────────────────────────

  Future<void> save(Note note) async {
    await _dao.upsert(note);
    if (_sync.isOnline) {
      await _remote.save(note);
      await _dao.markSynced(note.id);
    }
  }

  Future<void> delete(String id) async {
    await _dao.deleteById(id);
    if (_sync.isOnline) {
      await _remote.delete(id);
    }
  }

  Future<void> archive(String id, {required bool archived}) async {
    final note = await _dao.watchById(id).first;
    if (note == null) return;
    await save(note.copyWith(isArchived: archived));
    if (_sync.isOnline) {
      await _remote.archive(id, archived: archived);
    }
  }

  Future<void> pin(String id, {required bool pinned}) async {
    final note = await _dao.watchById(id).first;
    if (note == null) return;
    await save(note.copyWith(isPinned: pinned));
    if (_sync.isOnline) {
      await _remote.pin(id, pinned: pinned);
    }
  }
}

// ── Providers ────────────────────────────────────────────────────────────────

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final db   = ref.watch(appDatabaseProvider);
  final uid  = ref.watch(_uidProvider);
  final sync = ref.watch(syncServiceProvider);
  return NoteRepository(
    dao:    db.notesDao,
    remote: FirestoreNotesDatasource(uid),
    sync:   sync,
  );
});

final _uidProvider = Provider<String>((_) => 'preview-user');
