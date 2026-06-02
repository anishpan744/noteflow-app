import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/note.dart';

class FirestoreNotesDatasource {
  FirestoreNotesDatasource(this._uid);

  final String _uid;

  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .collection('notes');

  // ── Streams ──────────────────────────────────────────────────────────────────

  Stream<List<Note>> watchAll() {
    return _col
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Note.fromFirestore).toList());
  }

  Stream<Note?> watchById(String id) {
    return _col.doc(id).snapshots().map(
          (doc) => doc.exists ? Note.fromFirestore(doc) : null,
        );
  }

  Stream<List<Note>> watchPinned() {
    return _col
        .where('isPinned', isEqualTo: true)
        .where('isArchived', isEqualTo: false)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Note.fromFirestore).toList());
  }

  Stream<List<Note>> watchByCategory(String categoryId) {
    return _col
        .where('categoryIds', arrayContains: categoryId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Note.fromFirestore).toList());
  }

  // ── Mutations ────────────────────────────────────────────────────────────────

  Future<void> save(Note note) async {
    await _col.doc(note.id).set(note.toFirestore());
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }

  Future<void> archive(String id, {required bool archived}) async {
    await _col.doc(id).update({
      'isArchived': archived,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> pin(String id, {required bool pinned}) async {
    await _col.doc(id).update({
      'isPinned': pinned,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
