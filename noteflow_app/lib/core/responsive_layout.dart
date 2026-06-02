import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'design/tokens.dart';
import 'design/animations.dart';
import 'widgets/glass_card.dart';

// ── Tab definitions ───────────────────────────────────────────────────────────

class _Tab {
  const _Tab({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.path,
  });

  final String label;
  final PhosphorIconData icon;
  final PhosphorIconData activeIcon;
  final String path;
}

const _tabs = [
  _Tab(
    label: 'Notes',
    icon: PhosphorIconsRegular.notepad,
    activeIcon: PhosphorIconsFill.notepad,
    path: '/notes',
  ),
  _Tab(
    label: 'Tasks',
    icon: PhosphorIconsRegular.checkSquare,
    activeIcon: PhosphorIconsFill.checkSquare,
    path: '/tasks',
  ),
  _Tab(
    label: 'Categories',
    icon: PhosphorIconsRegular.tag,
    activeIcon: PhosphorIconsFill.tag,
    path: '/categories',
  ),
  _Tab(
    label: 'Settings',
    icon: PhosphorIconsRegular.gear,
    activeIcon: PhosphorIconsFill.gear,
    path: '/settings',
  ),
];

// ── AppShell ──────────────────────────────────────────────────────────────────

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final idx   = navigationShell.currentIndex;

    if (width >= 1200) {
      return _DesktopShell(
        index: idx, onTap: _onTap, child: navigationShell);
    }
    if (width >= 600) {
      return _TabletShell(
        index: idx, onTap: _onTap, child: navigationShell);
    }
    return _PhoneShell(
      index: idx, onTap: _onTap, child: navigationShell);
  }
}

// ── Phone layout — BottomNavigationBar ───────────────────────────────────────

class _PhoneShell extends StatelessWidget {
  const _PhoneShell({
    required this.index,
    required this.onTap,
    required this.child,
  });
  final int index;
  final ValueChanged<int> onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _NeonBottomBar(
        currentIndex: index, onTap: onTap),
    );
  }
}

class _NeonBottomBar extends StatelessWidget {
  const _NeonBottomBar({
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kBg1,
        border: Border(top: BorderSide(color: kGlassBorder)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final tab      = _tabs[i];
              final selected = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: kDurationFast,
                        height: 2,
                        width: selected ? 24 : 0,
                        decoration: BoxDecoration(
                          color: kNeon,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        selected ? tab.activeIcon : tab.icon,
                        color: selected ? kNeon : kTextMuted,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tab.label,
                        style: TextStyle(
                          fontSize: 10,
                          color: selected ? kNeon : kTextMuted,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ── Tablet layout — NavigationRail ────────────────────────────────────────────

class _TabletShell extends StatelessWidget {
  const _TabletShell({
    required this.index,
    required this.onTap,
    required this.child,
  });
  final int index;
  final ValueChanged<int> onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: kBg1,
            selectedIndex: index,
            onDestinationSelected: onTap,
            labelType: NavigationRailLabelType.selected,
            selectedIconTheme: const IconThemeData(color: kNeon, size: 24),
            unselectedIconTheme:
                const IconThemeData(color: kTextMuted, size: 22),
            selectedLabelTextStyle: const TextStyle(
              color: kNeon,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelTextStyle: const TextStyle(
              color: kTextMuted,
              fontSize: 11,
            ),
            indicatorColor: kGlowBlue,
            destinations: _tabs.map((t) {
              return NavigationRailDestination(
                icon: Icon(t.icon),
                selectedIcon: Icon(t.activeIcon),
                label: Text(t.label),
              );
            }).toList(),
          ),
          const VerticalDivider(width: 1, color: kGlassBorder),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ── Desktop layout — Full sidebar (120 px) ────────────────────────────────────

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.index,
    required this.onTap,
    required this.child,
  });
  final int index;
  final ValueChanged<int> onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar — solid kBg1 background for visibility
          Container(
            width: 120,
            color: kBg1,
            child: Column(
              children: [
                const SizedBox(height: 24),
                // App mark
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: GlassCard(
                    borderRadius: 12,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    glowColor: kNeon,
                    child: Text('NF',
                        style: tt.displaySmall?.copyWith(color: kNeon)),
                  ),
                ),
                // Tab items
                ...List.generate(_tabs.length, (i) {
                  final tab      = _tabs[i];
                  final selected = i == index;
                  return GestureDetector(
                    onTap: () => onTap(i),
                    child: AnimatedContainer(
                      duration: kDurationFast,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selected
                            ? kNeon.withValues(alpha: 0.10)
                            : Colors.transparent,
                        border: selected
                            ? const Border(
                                left: BorderSide(color: kNeon, width: 2))
                            : const Border(
                                left: BorderSide(
                                    color: Colors.transparent, width: 2)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            selected ? tab.activeIcon : tab.icon,
                            color: selected ? kNeon : kTextMuted,
                            size: 22,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tab.label,
                            style: TextStyle(
                              fontSize: 11,
                              color: selected ? kNeon : kTextMuted,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const VerticalDivider(width: 1, color: kGlassBorder),
          Expanded(child: child),
        ],
      ),
    );
  }
}
