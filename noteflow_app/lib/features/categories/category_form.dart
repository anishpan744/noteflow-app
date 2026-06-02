import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/design/tokens.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/neon_button.dart';
import '../../models/category.dart';
import '../../models/enums.dart';
import 'category_providers.dart';

// 16 preset colors
const _presets = [
  '#00D4FF', '#7B61FF', '#00FFB3', '#FFB800', '#FF3366',
  '#FF6B35', '#A8FF3E', '#FF61DC', '#61DCFF', '#FFD700',
  '#E040FB', '#00BCD4', '#FF5722', '#8BC34A', '#F06292', '#4DD0E1',
];

// Phosphor icons available for categories
final _icons = [
  PhosphorIconsRegular.notepad,     PhosphorIconsRegular.checkSquare,
  PhosphorIconsRegular.tag,         PhosphorIconsRegular.folder,
  PhosphorIconsRegular.star,        PhosphorIconsRegular.heart,
  PhosphorIconsRegular.briefcase,   PhosphorIconsRegular.house,
  PhosphorIconsRegular.graduationCap, PhosphorIconsRegular.book,
  PhosphorIconsRegular.camera,      PhosphorIconsRegular.musicNote,
  PhosphorIconsRegular.gameController, PhosphorIconsRegular.airplane,
  PhosphorIconsRegular.car,         PhosphorIconsRegular.shoppingCart,
  PhosphorIconsRegular.heartbeat,   PhosphorIconsRegular.code,
  PhosphorIconsRegular.palette,     PhosphorIconsRegular.plant,
];

const _iconNames = [
  'notepad', 'checkSquare', 'tag', 'folder', 'star', 'heart',
  'briefcase', 'house', 'graduationCap', 'book', 'camera', 'music',
  'gameController', 'airplane', 'car', 'shoppingCart',
  'heartbeat', 'code', 'palette', 'plant',
];

class CategoryForm extends ConsumerStatefulWidget {
  const CategoryForm({super.key, this.existing});
  final Category? existing;

  @override
  ConsumerState<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends ConsumerState<CategoryForm> {
  final _nameCtrl = TextEditingController();
  String _colorHex     = _presets.first;
  CategoryModule _module = CategoryModule.shared;
  String? _iconName;
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final c = widget.existing!;
      _nameCtrl.text = c.name;
      _colorHex      = c.colorHex;
      _module        = c.module;
      _iconName      = c.iconName;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Color get _color {
    try {
      return Color(int.parse('FF${_colorHex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return kNeon;
    }
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);

    final ctrl = ref.read(categoryControllerProvider.notifier);
    if (_isEdit) {
      await ctrl.edit(widget.existing!.copyWith(
        name:      _nameCtrl.text.trim(),
        colorHex:  _colorHex,
        module:    _module,
        iconName:  _iconName,
        updatedAt: DateTime.now(),
      ));
    } else {
      await ctrl.create(
        name:     _nameCtrl.text.trim(),
        colorHex: _colorHex,
        module:   _module,
        iconName: _iconName,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle + title
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: kGlassBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isEdit ? 'Edit Category' : 'New Category',
              style: tt.headlineMedium,
            ),
            const SizedBox(height: 20),

            // Name field
            TextField(
              controller: _nameCtrl,
              style: tt.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Category name',
                prefixIcon: Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _color,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(
                        color: _color.withValues(alpha: 0.5), blurRadius: 6)],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Color presets
            Text('Color', style: tt.labelMedium?.copyWith(color: kTextMuted)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._presets.map((hex) {
                  final color =
                      Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
                  final selected = hex == _colorHex;
                  return GestureDetector(
                    onTap: () => setState(() => _colorHex = hex),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selected
                            ? Border.all(color: Colors.white, width: 2.5)
                            : null,
                        boxShadow: selected
                            ? [BoxShadow(
                                color: color.withValues(alpha: 0.6),
                                blurRadius: 8)]
                            : null,
                      ),
                    ),
                  );
                }),
                // Custom color picker
                GestureDetector(
                  onTap: () => _pickCustomColor(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kGlassBorder),
                      gradient: const SweepGradient(colors: [
                        Colors.red, Colors.yellow, Colors.green,
                        Colors.blue, Colors.purple, Colors.red,
                      ]),
                    ),
                    child: const Icon(Icons.add, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Module selector
            Text('Module', style: tt.labelMedium?.copyWith(color: kTextMuted)),
            const SizedBox(height: 8),
            Row(
              children: CategoryModule.values.map((m) {
                final selected = m == _module;
                final label    = switch (m) {
                  CategoryModule.note   => 'Notes',
                  CategoryModule.task   => 'Tasks',
                  CategoryModule.shared => 'Both',
                };
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _module = m),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? _color.withValues(alpha: 0.15)
                            : kBg2,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? _color
                              : kGlassBorder,
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selected ? _color : kTextSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Icon picker
            Text('Icon', style: tt.labelMedium?.copyWith(color: kTextMuted)),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: _icons.length,
                itemBuilder: (_, i) {
                  final selected = _iconName == _iconNames[i];
                  return GestureDetector(
                    onTap: () => setState(() => _iconName = _iconNames[i]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: selected
                            ? _color.withValues(alpha: 0.15)
                            : kBg2,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selected ? _color : kGlassBorder,
                        ),
                      ),
                      child: Icon(
                        _icons[i],
                        color: selected ? _color : kTextMuted,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: NeonButton(
                    label: 'Cancel',
                    ghost: true,
                    color: kTextSecondary,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeonButton(
                    label: _isEdit ? 'Save' : 'Create',
                    color: _color,
                    loading: _saving,
                    onTap: _saving ? null : _save,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickCustomColor(BuildContext context) async {
    Color picked = _color;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kBg2,
        title: const Text('Custom color'),
        content: ColorPicker(
          pickerColor: picked,
          onColorChanged: (c) => picked = c,
          pickerAreaHeightPercent: 0.6,
          enableAlpha: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: kTextSecondary)),
          ),
          TextButton(
            onPressed: () {
              final hex =
                  '#${picked.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
              setState(() => _colorHex = hex);
              Navigator.pop(context);
            },
            child: const Text('Select',
                style: TextStyle(color: kNeon)),
          ),
        ],
      ),
    );
  }
}
