import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/category_repository.dart';
import '../../models/category.dart';
import '../../models/enums.dart';

// ── Stream ────────────────────────────────────────────────────────────────────

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchAll();
});

// ── Controller ────────────────────────────────────────────────────────────────

class CategoryController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  CategoryRepository get _repo => ref.read(categoryRepositoryProvider);

  Future<void> create({
    required String name,
    required String colorHex,
    required CategoryModule module,
    String? iconName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final now = DateTime.now();
      final category = Category(
        id:        const Uuid().v4(),
        name:      name,
        colorHex:  colorHex,
        module:    module,
        iconName:  iconName,
        sortOrder: 0,
        createdAt: now,
        updatedAt: now,
      );
      await _repo.save(category);
    });
  }

  Future<void> edit(Category category) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.save(category.copyWith(updatedAt: DateTime.now()));
    });
  }

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.delete(id));
  }

  Future<void> reorder(List<Category> ordered) async {
    state = await AsyncValue.guard(() => _repo.reorder(ordered));
  }
}

final categoryControllerProvider =
    AsyncNotifierProvider<CategoryController, void>(CategoryController.new);
