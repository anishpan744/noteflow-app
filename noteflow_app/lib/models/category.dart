import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category {
  const Category._();

  const factory Category({
    required String id,
    required String name,
    required String colorHex,
    required CategoryModule module,
    String? iconName,
    @Default(0) int sortOrder,
    DateTime? archivedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Category(
      id:         doc.id,
      name:       d['name'] as String,
      colorHex:   d['colorHex'] as String,
      module:     CategoryModule.values.firstWhere(
          (e) => e.name == (d['module'] ?? 'shared'),
          orElse: () => CategoryModule.shared),
      iconName:   d['iconName'] as String?,
      sortOrder:  (d['sortOrder'] as int?) ?? 0,
      archivedAt: _tsToDate(d['archivedAt']),
      createdAt:  _tsToDate(d['createdAt']) ?? DateTime.now(),
      updatedAt:  _tsToDate(d['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    final m = toJson()..remove('id');
    m['createdAt'] = Timestamp.fromDate(createdAt);
    m['updatedAt'] = Timestamp.fromDate(updatedAt);
    if (archivedAt != null) {
      m['archivedAt'] = Timestamp.fromDate(archivedAt!);
    }
    return m;
  }
}

DateTime? _tsToDate(dynamic v) {
  if (v == null) return null;
  if (v is Timestamp) return v.toDate();
  if (v is String) return DateTime.tryParse(v);
  return null;
}
