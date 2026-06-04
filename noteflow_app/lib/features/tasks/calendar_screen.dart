import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';
import '../../core/design/animations.dart';
import '../../core/design/tokens.dart';
import '../../core/widgets/glass_card.dart';
import '../../models/category.dart';
import '../../models/task.dart';
import '../categories/category_providers.dart';
import 'task_list_panel.dart';
import 'task_providers.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view     = ref.watch(calendarViewModeProvider);
    final selected = ref.watch(selectedDateProvider);
    final tt       = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: kBg0,
      body: SafeArea(
        child: Column(
          children: [
            // Header: month/year + view switcher + TODAY
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Text(
                    DateFormat('MMMM yyyy').format(selected),
                    style: tt.headlineMedium,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => ref
                        .read(selectedDateProvider.notifier)
                        .state = DateTime.now(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kNeon.withValues(alpha: 0.5)),
                      ),
                      child: Text('TODAY',
                          style: TextStyle(
                            fontSize: 11,
                            color: kNeon,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          )),
                    ),
                  ),
                ],
              ),
            ),

            // View mode pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _ViewSwitcher(view: view),
            ),
            const SizedBox(height: 8),

            // Calendar body
            Expanded(
              child: switch (view) {
                CalendarView.month => _MonthView(),
                CalendarView.week  => _WeekView(),
                CalendarView.day   => _DayView(),
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kViolet,
        foregroundColor: Colors.white,
        onPressed: () {
          final id = const Uuid().v4();
          context.push('/tasks/$id/edit');
        },
        child: const Icon(PhosphorIconsRegular.plus),
      ),
    );
  }
}

// ── View switcher ─────────────────────────────────────────────────────────────

class _ViewSwitcher extends ConsumerWidget {
  const _ViewSwitcher({required this.view});
  final CalendarView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: kBg2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: CalendarView.values.map((v) {
          final sel = v == view;
          final label = switch (v) {
            CalendarView.day   => 'Day',
            CalendarView.week  => 'Week',
            CalendarView.month => 'Month',
          };
          return Expanded(
            child: GestureDetector(
              onTap: () =>
                  ref.read(calendarViewModeProvider.notifier).state = v,
              child: AnimatedContainer(
                duration: kDurationFast,
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: sel ? kNeon.withValues(alpha: 0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: sel ? kNeon : Colors.transparent,
                  ),
                ),
                child: Center(
                  child: Text(label,
                      style: TextStyle(
                        fontSize: 13,
                        color: sel ? kNeon : kTextSecondary,
                        fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                      )),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Color _hexColor(String hex) {
  try {
    return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
  } catch (_) {
    return kNeon;
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

List<Task> _tasksOn(List<Task> all, DateTime day) =>
    all.where((t) => t.dueDate != null && _sameDay(t.dueDate!, day)).toList();

List<Color> _dotColors(List<Task> tasks, List<Category> cats) {
  final colors = <Color>[];
  for (final t in tasks.take(3)) {
    if (t.categoryIds.isNotEmpty) {
      final cat = cats.where((c) => c.id == t.categoryIds.first).firstOrNull;
      colors.add(cat != null ? _hexColor(cat.colorHex) : kViolet);
    } else {
      colors.add(kViolet);
    }
  }
  return colors;
}

// ── Month view ────────────────────────────────────────────────────────────────

class _MonthView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDateProvider);
    final allTasks = ref.watch(allTasksProvider).valueOrNull ?? [];
    final cats     = ref.watch(categoriesProvider).valueOrNull ?? [];

    return Column(
      children: [
        GlassCard(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(8),
          child: TableCalendar<Task>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay:  DateTime.utc(2030, 12, 31),
            focusedDay: selected,
            currentDay: DateTime.now(),
            selectedDayPredicate: (d) => _sameDay(d, selected),
            calendarFormat: CalendarFormat.month,
            availableGestures: AvailableGestures.horizontalSwipe,
            headerVisible: false,
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: kTextMuted, fontSize: 11),
              weekendStyle: TextStyle(color: kTextMuted, fontSize: 11),
            ),
            eventLoader: (day) => _tasksOn(allTasks, day),
            onDaySelected: (sel, foc) =>
                ref.read(selectedDateProvider.notifier).state = sel,
            onPageChanged: (foc) =>
                ref.read(selectedDateProvider.notifier).state = foc,
            calendarBuilders: CalendarBuilders<Task>(
              defaultBuilder: (ctx, day, foc) =>
                  _cell(day, allTasks, cats, selected),
              outsideBuilder: (ctx, day, foc) =>
                  _cell(day, allTasks, cats, selected, outside: true),
              todayBuilder: (ctx, day, foc) =>
                  _TodayCell(day: day),
              selectedBuilder: (ctx, day, foc) =>
                  _cell(day, allTasks, cats, selected, isSelected: true),
              markerBuilder: (ctx, day, tasks) {
                if (tasks.isEmpty) return null;
                final colors = _dotColors(tasks, cats);
                return Positioned(
                  bottom: 4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: colors
                        .map((c) => Container(
                              width: 5,
                              height: 5,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                              ),
                            ))
                        .toList(),
                  ),
                );
              },
            ),
          ),
        ),

        // Selected day's tasks
        Expanded(child: TaskListPanel(date: selected)),
      ],
    );
  }

  Widget _cell(
    DateTime day,
    List<Task> all,
    List<Category> cats,
    DateTime selected, {
    bool outside = false,
    bool isSelected = false,
  }) {
    final tasks = _tasksOn(all, day);
    final overdue = tasks.any((t) => t.isOverdue);
    Color textColor = outside ? kTextMuted.withValues(alpha: 0.4) : kTextPrimary;
    if (overdue) textColor = kCrimson;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected ? kGlassFill : kBg2.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? Border.all(color: kNeon) : null,
      ),
      alignment: Alignment.center,
      child: Text('${day.day}',
          style: TextStyle(
            color: textColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            fontSize: 13,
          )),
    );
  }
}

// Pulsing neon ring for today
class _TodayCell extends StatefulWidget {
  const _TodayCell({required this.day});
  final DateTime day;

  @override
  State<_TodayCell> createState() => _TodayCellState();
}

class _TodayCellState extends State<_TodayCell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kNeon, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: kNeon.withValues(alpha: 0.2 + _ctrl.value * 0.4),
                blurRadius: 6 + _ctrl.value * 8,
                spreadRadius: _ctrl.value * 2,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text('${widget.day.day}',
              style: const TextStyle(
                color: kNeon,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              )),
        );
      },
    );
  }
}

// ── Week view ─────────────────────────────────────────────────────────────────

class _WeekView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDateProvider);
    final allTasks = ref.watch(allTasksProvider).valueOrNull ?? [];
    final cats     = ref.watch(categoriesProvider).valueOrNull ?? [];

    // Compute the Monday of the selected week
    final monday = selected.subtract(Duration(days: selected.weekday - 1));
    final days = List.generate(7, (i) => monday.add(Duration(days: i)));

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: days.map((day) {
          final tasks   = _tasksOn(allTasks, day);
          final isToday = _sameDay(day, DateTime.now());
          return Expanded(
            child: GestureDetector(
              onTap: () =>
                  ref.read(selectedDateProvider.notifier).state = day,
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isToday ? kGlowBlue : kBg1,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isToday ? kNeon.withValues(alpha: 0.5) : kGlassBorder,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    Text(DateFormat('E').format(day).substring(0, 1),
                        style: const TextStyle(
                            color: kTextMuted, fontSize: 10)),
                    Text('${day.day}',
                        style: TextStyle(
                          color: isToday ? kNeon : kTextPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        )),
                    const SizedBox(height: 4),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        children: [
                          ...tasks.take(3).map((t) =>
                              _miniPill(t, cats)),
                          if (tasks.length > 3)
                            Text('+${tasks.length - 3}',
                                style: const TextStyle(
                                    color: kTextMuted, fontSize: 9),
                                textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _miniPill(Task t, List<Category> cats) {
    final color = t.categoryIds.isNotEmpty
        ? _hexColor(
            cats.where((c) => c.id == t.categoryIds.first).firstOrNull?.colorHex
                ?? '#7B61FF')
        : kViolet;
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(4),
        border: Border(left: BorderSide(color: color, width: 2)),
      ),
      child: Text(
        t.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 9,
          color: t.isOverdue ? kCrimson : kTextSecondary,
        ),
      ),
    );
  }
}

// ── Day view ──────────────────────────────────────────────────────────────────

class _DayView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDateProvider);
    final allTasks = ref.watch(allTasksProvider).valueOrNull ?? [];
    final cats     = ref.watch(categoriesProvider).valueOrNull ?? [];
    final dayTasks = _tasksOn(allTasks, selected);

    // Hours 6:00 → 23:00
    final hours = List.generate(18, (i) => i + 6);
    final now = DateTime.now();
    final isToday = _sameDay(selected, now);

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
          itemCount: hours.length,
          itemBuilder: (_, i) {
            final hour = hours[i];
            final hourTasks = dayTasks.where((t) {
              if (t.dueTime == null) return false;
              final parts = t.dueTime!.split(':');
              return int.tryParse(parts[0]) == hour;
            }).toList();

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 11,
                        color: kTextMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 16, left: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: kGlassBorder, width: 0.5),
                        ),
                      ),
                      child: Column(
                        children: hourTasks
                            .map((t) => _block(t, cats))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // Current time indicator
        if (isToday) _CurrentTimeLine(),
      ],
    );
  }

  Widget _block(Task t, List<Category> cats) {
    final color = t.categoryIds.isNotEmpty
        ? _hexColor(
            cats.where((c) => c.id == t.categoryIds.first).firstOrNull?.colorHex
                ?? '#7B61FF')
        : kViolet;
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(t.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: t.isOverdue ? kCrimson : kTextPrimary,
                )),
          ),
          if (t.dueTime != null)
            Text(t.dueTime!,
                style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    color: kTextMuted)),
        ],
      ),
    );
  }
}

class _CurrentTimeLine extends StatefulWidget {
  @override
  State<_CurrentTimeLine> createState() => _CurrentTimeLineState();
}

class _CurrentTimeLineState extends State<_CurrentTimeLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    if (now.hour < 6 || now.hour > 23) return const SizedBox.shrink();
    // Each hour row ≈ rough fixed height; approximate offset
    final offset = (now.hour - 6) * 52.0 + (now.minute / 60) * 52.0 + 8;

    return Positioned(
      top: offset,
      left: 48,
      right: 8,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: kNeon,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kNeon.withValues(alpha: 0.4 + _ctrl.value * 0.4),
                    blurRadius: 4 + _ctrl.value * 6,
                    spreadRadius: _ctrl.value * 2,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(height: 1.5, color: kNeon),
            ),
          ],
        ),
      ),
    );
  }
}
