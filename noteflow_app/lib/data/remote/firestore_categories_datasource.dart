import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/category.dart';

class FirestoreCategoriesDatasource {
  FirestoreCategoriesDatasource(this._uid);

  final String _uid;

  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .collection('categories');

  // ── Streams ──────────────────────────────────────────────────────────────────

  Stream<List<Category>> watchAll() {
    return _col
        .orderBy('sortOrder')
        .snapshots()
        .map((snap) => snap.docs.map(Category.fromFirestore).toList());
  }

  Stream<Category?> watchById(String id) {
    return _col.doc(id).snapshots().map(
          (doc) => doc.exists ? Category.fromFirestore(doc) : null,
        );
  }

  // ── Mutations ────────────────────────────────────────────────────────────────

  Future<void> save(Category category) async {
    await _col.doc(category.id).set(category.toFirestore());
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }

  /// Batch-updates `sortOrder` for a reordered list.
  Future<void> reorder(List<Category> ordered) async {
    final batch = FirebaseFirestore.instance.batch();
    for (var i = 0; i < ordered.length; i++) {
      batch.update(_col.doc(ordered[i].id), {
        'sortOrder': i,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }
}
