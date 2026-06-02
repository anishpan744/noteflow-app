import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../design/tokens.dart';
import '../design/animations.dart';

/// A single editable key-value pair row for note/task metadata.
class ContextFieldRow extends StatefulWidget {
  const ContextFieldRow({
    super.key,
    required this.fieldKey,
    required this.value,
    this.onChanged,
    this.onDelete,
  });

  final String fieldKey;
  final String value;
  final void Function(String key, String value)? onChanged;
  final VoidCallback? onDelete;

  @override
  State<ContextFieldRow> createState() => _ContextFieldRowState();
}

class _ContextFieldRowState extends State<ContextFieldRow> {
  bool _editing = false;
  late TextEditingController _keyCtrl;
  late TextEditingController _valCtrl;

  @override
  void initState() {
    super.initState();
    _keyCtrl = TextEditingController(text: widget.fieldKey);
    _valCtrl = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _keyCtrl.dispose();
    _valCtrl.dispose();
    super.dispose();
  }

  void _commit() {
    setState(() => _editing = false);
    widget.onChanged?.call(_keyCtrl.text.trim(), _valCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: kDurationFast,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _editing ? kBg2 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _editing ? kNeon.withValues(alpha: 0.4) : Colors.transparent,
        ),
      ),
      child: _editing ? _editRow(tt) : _displayRow(tt),
    );
  }

  Widget _displayRow(TextTheme tt) {
    return GestureDetector(
      onTap: widget.onChanged != null ? () => setState(() => _editing = true) : null,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              widget.fieldKey,
              style: tt.labelMedium?.copyWith(color: kTextMuted),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(widget.value, style: tt.bodySmall),
          ),
          if (widget.onChanged != null)
            Icon(PhosphorIconsRegular.pencilSimple, size: 14, color: kTextMuted),
          if (widget.onDelete != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: widget.onDelete,
              child: Icon(PhosphorIconsRegular.x, size: 14, color: kTextMuted),
            ),
          ],
        ],
      ),
    );
  }

  Widget _editRow(TextTheme tt) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: TextField(
            controller: _keyCtrl,
            style: tt.labelMedium?.copyWith(color: kTextSecondary),
            decoration: const InputDecoration(
              isDense: true,
              hintText: 'Key',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onSubmitted: (_) => _commit(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _valCtrl,
            autofocus: true,
            style: tt.bodySmall,
            decoration: const InputDecoration(
              isDense: true,
              hintText: 'Value',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onSubmitted: (_) => _commit(),
          ),
        ),
        GestureDetector(
          onTap: _commit,
          child: const Icon(PhosphorIconsRegular.check, size: 16, color: kTeal),
        ),
      ],
    );
  }
}
