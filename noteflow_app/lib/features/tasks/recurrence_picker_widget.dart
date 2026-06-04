import 'package:flutter/material.dart';
import '../../core/design/tokens.dart';
import '../../models/enums.dart';
import '../../models/recurrence.dart';

class RecurrencePickerWidget extends StatefulWidget {
  const RecurrencePickerWidget({
    super.key,
    this.initial,
    required this.onChanged,
  });

  final Recurrence? initial;
  final void Function(Recurrence?) onChanged;

  @override
  State<RecurrencePickerWidget> createState() => _RecurrencePickerWidgetState();
}

class _RecurrencePickerWidgetState extends State<RecurrencePickerWidget> {
  late RecurrenceType _type;
  late int _interval;
  late List<int> _daysOfWeek;
  late int? _dayOfMonth;
  late RecurrenceEnd _endCondition;
  late DateTime? _endDate;
  late int? _endAfterCount;

  @override
  void initState() {
    super.initState();
    final r = widget.initial;
    _type         = r?.type          ?? RecurrenceType.daily;
    _interval     = r?.interval      ?? 1;
    _daysOfWeek   = r?.daysOfWeek    ?? [];
    _dayOfMonth   = r?.dayOfMonth;
    _endCondition = r?.endCondition  ?? RecurrenceEnd.noEnd;
    _endDate      = r?.endDate;
    _endAfterCount = r?.endAfterCount;
  }

  void _notify() {
    widget.onChanged(Recurrence(
      type:          _type,
      interval:      _interval,
      daysOfWeek:    _daysOfWeek,
      dayOfMonth:    _dayOfMonth,
      endCondition:  _endCondition,
      endDate:       _endDate,
      endAfterCount: _endAfterCount,
    ));
  }

  String get _previewText {
    final unit = switch (_type) {
      RecurrenceType.daily     => _interval == 1 ? 'day' : 'days',
      RecurrenceType.weekly    => _interval == 1 ? 'week' : 'weeks',
      RecurrenceType.monthly   => _interval == 1 ? 'month' : 'months',
      RecurrenceType.quarterly => 'quarter',
      RecurrenceType.halfYearly => '6 months',
      RecurrenceType.annually  => 'year',
      RecurrenceType.custom    => 'interval',
    };

    String base = 'Repeats every${_interval > 1 ? ' $_interval' : ''} $unit';

    if (_type == RecurrenceType.weekly && _daysOfWeek.isNotEmpty) {
      const names = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final days = _daysOfWeek.map((d) => names[d]).join(', ');
      base += ' on $days';
    }

    if (_endCondition == RecurrenceEnd.endByDate && _endDate != null) {
      base += ' · ends ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}';
    } else if (_endCondition == RecurrenceEnd.endAfterCount &&
        _endAfterCount != null) {
      base += ' · ${_endAfterCount!} times';
    }

    return base;
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Frequency row ─────────────────────────────────────────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: RecurrenceType.values.map((t) {
              final label = switch (t) {
                RecurrenceType.daily     => 'Daily',
                RecurrenceType.weekly    => 'Weekly',
                RecurrenceType.monthly   => 'Monthly',
                RecurrenceType.quarterly => 'Quarterly',
                RecurrenceType.halfYearly => '6-Month',
                RecurrenceType.annually  => 'Yearly',
                RecurrenceType.custom    => 'Custom',
              };
              final sel = t == _type;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() { _type = t; _notify(); }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? kViolet.withValues(alpha: 0.15) : kBg2,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel ? kViolet : kGlassBorder,
                        width: sel ? 1.5 : 1,
                      ),
                      boxShadow: sel
                          ? [BoxShadow(
                              color: kViolet.withValues(alpha: 0.2),
                              blurRadius: 8)]
                          : null,
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        color: sel ? kViolet : kTextSecondary,
                        fontWeight:
                            sel ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // ── Interval ────────────────────────────────────────────────────
        if (_type == RecurrenceType.custom) ...[
          Row(children: [
            Text('Every', style: tt.bodySmall),
            const SizedBox(width: 8),
            SizedBox(
              width: 48,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: TextEditingController(text: '$_interval'),
                style: tt.bodyMedium,
                decoration: const InputDecoration(isDense: true),
                onChanged: (v) {
                  final n = int.tryParse(v);
                  if (n != null && n > 0) {
                    setState(() => _interval = n);
                    _notify();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Text('days/weeks/months', style: tt.bodySmall),
          ]),
          const SizedBox(height: 16),
        ],

        // ── Weekly day selector ──────────────────────────────────────────
        if (_type == RecurrenceType.weekly) ...[
          Text('On days', style: tt.labelSmall?.copyWith(color: kTextMuted)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(7, (i) {
              final day   = i + 1; // 1=Mon … 7=Sun
              const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              final sel   = _daysOfWeek.contains(day);
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    sel ? _daysOfWeek.remove(day) : _daysOfWeek.add(day);
                    _notify();
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 4),
                    height: 36,
                    decoration: BoxDecoration(
                      color: sel ? kViolet : kBg2,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: sel ? kViolet : kGlassBorder),
                    ),
                    child: Center(
                      child: Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 12,
                          color: sel ? Colors.white : kTextMuted,
                          fontWeight: sel
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
        ],

        // ── Monthly day picker ───────────────────────────────────────────
        if (_type == RecurrenceType.monthly) ...[
          Text('On day', style: tt.labelSmall?.copyWith(color: kTextMuted)),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: 31,
              itemBuilder: (_, i) {
                final day = i + 1;
                final sel = _dayOfMonth == day;
                return GestureDetector(
                  onTap: () =>
                      setState(() { _dayOfMonth = day; _notify(); }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    decoration: BoxDecoration(
                      color: sel ? kViolet : kBg2,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 12,
                          color: sel ? Colors.white : kTextSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],

        // ── End condition ────────────────────────────────────────────────
        Text('Ends', style: tt.labelSmall?.copyWith(color: kTextMuted)),
        const SizedBox(height: 8),
        Row(children: [
          _EndPill(
            label: 'Never',
            selected: _endCondition == RecurrenceEnd.noEnd,
            onTap: () => setState(() {
              _endCondition = RecurrenceEnd.noEnd;
              _notify();
            }),
          ),
          const SizedBox(width: 8),
          _EndPill(
            label: 'By date',
            selected: _endCondition == RecurrenceEnd.endByDate,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _endDate ?? DateTime.now().add(
                    const Duration(days: 30)),
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() {
                  _endCondition = RecurrenceEnd.endByDate;
                  _endDate      = picked;
                  _notify();
                });
              }
            },
          ),
          const SizedBox(width: 8),
          _EndPill(
            label: 'After N',
            selected: _endCondition == RecurrenceEnd.endAfterCount,
            onTap: () => setState(() {
              _endCondition = RecurrenceEnd.endAfterCount;
              _endAfterCount ??= 10;
              _notify();
            }),
          ),
        ]),

        if (_endCondition == RecurrenceEnd.endAfterCount) ...[
          const SizedBox(height: 8),
          Row(children: [
            Text('After', style: tt.bodySmall),
            const SizedBox(width: 8),
            SizedBox(
              width: 48,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller:
                    TextEditingController(text: '${_endAfterCount ?? 10}'),
                style: tt.bodyMedium,
                decoration: const InputDecoration(isDense: true),
                onChanged: (v) {
                  final n = int.tryParse(v);
                  if (n != null && n > 0) {
                    setState(() => _endAfterCount = n);
                    _notify();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Text('times', style: tt.bodySmall),
          ]),
        ],

        // ── Live preview ─────────────────────────────────────────────────
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kBg2,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kGlassBorder),
          ),
          child: Text(
            _previewText,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              color: kTextSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _EndPill extends StatelessWidget {
  const _EndPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? kViolet.withValues(alpha: 0.15) : kBg2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? kViolet : kGlassBorder,
              width: selected ? 1.5 : 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? kViolet : kTextSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
