import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/enums.dart';
import '../../models/task.dart';

class FirestoreTasksDatasource {
  FirestoreTasksDatasource(this._uid);

  final String _uid;

  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .collection('tasks');

  // ── Streams ──────────────────────────────────────────────────────────────────

  Stream<List<Task>> watchAll() {
    return _col
        .orderBy('dueDate')
        .snapshots()
        .map((snap) => snap.docs.map(Task.fromFirestore).toList());
  }

  Stream<Task?> watchById(String id) {
    return _col.doc(id).snapshots().map(
          (doc) => doc.exists ? Task.fromFirestore(doc) : null,
        );
  }

  Stream<List<Task>> watchForDate(DateTime date) {
    final start = Timestamp.fromDate(
        DateTime(date.year, date.month, date.day));
    final end = Timestamp.fromDate(
        DateTime(date.year, date.month, date.day, 23, 59, 59));
    return _col
        .where('dueDate', isGreaterThanOrEqualTo: start)
        .where('dueDate', isLessThanOrEqualTo: end)
        .snapshots()
        .map((snap) => snap.docs.map(Task.fromFirestore).toList());
  }

  Stream<List<Task>> watchInRange(DateTime from, DateTime to) {
    return _col
        .where('dueDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('dueDate', isLessThanOrEqualTo: Timestamp.fromDate(to))
        .orderBy('dueDate')
        .snapshots()
        .map((snap) => snap.docs.map(Task.fromFirestore).toList());
  }

  Stream<List<Task>> watchOverdue() {
    return _col
        .where('dueDate', isLessThan: Timestamp.now())
        .where('status', whereNotIn: ['done', 'cancelled'])
        .snapshots()
        .map((snap) => snap.docs.map(Task.fromFirestore).toList());
  }

  // ── Mutations ────────────────────────────────────────────────────────────────

  Future<void> save(Task task) async {
    await _col.doc(task.id).set(task.toFirestore());
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }

  Future<void> updateStatus(String id, TaskStatus status) async {
    await _col.doc(id).update({
      'status':    status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateDueDate(String id, DateTime? dueDate) async {
    await _col.doc(id).update({
      'dueDate':   dueDate != null ? Timestamp.fromDate(dueDate) : null,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
