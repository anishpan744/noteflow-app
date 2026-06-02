import 'dart:convert';
import 'package:drift/drift.dart';
import '../../models/link_attachment.dart';
import '../../models/note.dart';
import 'app_database.dart';

part 'notes_dao.g.dart';

@DriftAccessor(tables: [NotesTable])
class NotesDao extends DatabaseAccessor<AppDatabase> with _$NotesDaoMixin {
  NotesDao(super.db);

  // ── Queries ─────────────────────────────────────────────────────────────────

  Stream<List<Note>> watchAll() {
    return (select(notesTable)
          ..where((t) => t.syncStatus.isNotValue('deleted'))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Stream<Note?> watchById(String id) {
    return (select(notesTable)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .map((r) => r == null ? null : _fromRow(r));
  }

  Stream<List<Note>> watchPinned() {
    return (select(notesTable)
          ..where((t) =>
              t.isPinned.equals(true) &
              t.syncStatus.isNotValue('deleted') &
              t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<List<Note>> getPending() async {
    final rows = await (select(notesTable)
          ..where((t) => t.syncStatus.equals('pending')))
        .get();
    return rows.map(_fromRow).toList();
  }

  // ── Mutations ────────────────────────────────────────────────────────────────

  Future<void> upsert(Note note) {
    return into(notesTable).insertOnConflictUpdate(_toCompanion(note));
  }

  Future<void> deleteById(String id) {
    return (update(notesTable)..where((t) => t.id.equals(id)))
        .write(const NotesTableCompanion(syncStatus: Value('deleted')));
  }

  Future<void> markSynced(String id) {
    return (update(notesTable)..where((t) => t.id.equals(id)))
        .write(const NotesTableCompanion(syncStatus: Value('synced')));
  }

  // ── Converters ───────────────────────────────────────────────────────────────

  Note _fromRow(NotesTableData r) => Note(
        id:             r.id,
        title:          r.title,
        bodyJson:       r.bodyJson,
        categoryIds:    List<String>.from(jsonDecode(r.categoryIds) as List),
        tags:           List<String>.from(jsonDecode(r.tags) as List),
        links:          (jsonDecode(r.links) as List)
            .map((e) => LinkAttachment.fromMap(e as Map<String, dynamic>))
            .toList(),
        attachmentUrls: List<String>.from(jsonDecode(r.attachmentUrls) as List),
        isPinned:       r.isPinned,
        isArchived:     r.isArchived,
        contextFields:  Map<String, String>.from(jsonDecode(r.contextFields) as Map),
        createdAt:      DateTime.fromMillisecondsSinceEpoch(r.createdAt),
        updatedAt:      DateTime.fromMillisecondsSinceEpoch(r.updatedAt),
      );

  NotesTableCompanion _toCompanion(Note n) => NotesTableCompanion.insert(
        id:             n.id,
        title:          n.title,
        bodyJson:       Value(n.bodyJson),
        categoryIds:    Value(jsonEncode(n.categoryIds)),
        tags:           Value(jsonEncode(n.tags)),
        links:          Value(jsonEncode(n.links.map((l) => l.toMap()).toList())),
        attachmentUrls: Value(jsonEncode(n.attachmentUrls)),
        isPinned:       Value(n.isPinned),
        isArchived:     Value(n.isArchived),
        contextFields:  Value(jsonEncode(n.contextFields)),
        createdAt:      n.createdAt.millisecondsSinceEpoch,
        updatedAt:      n.updatedAt.millisecondsSinceEpoch,
        syncStatus:     const Value('pending'),
      );
}
