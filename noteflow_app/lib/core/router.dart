import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_providers.dart';
import '../features/auth/login_screen.dart';
import 'responsive_layout.dart';
import 'design/animations.dart';
import 'widgets/_preview.dart';

// ── Placeholder screens ───────────────────────────────────────────────────────

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}

// ── Router provider ───────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final authListenable = _AuthListenable(ref);

  return GoRouter(
    initialLocation: '/notes',
    refreshListenable: authListenable,
    redirect: (context, state) {
      final userId  = ref.read(currentUserIdProvider);
      final onLogin = state.uri.toString() == '/login';
      if (userId == null && !onLogin) return '/login';
      if (userId != null && onLogin)  return '/notes';
      return null;
    },
    routes: [
      // Login — outside the shell
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => pageRouteTransition(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),

      // Floating search overlay — outside the tab shell
      GoRoute(
        path: '/search',
        pageBuilder: (context, state) => pageRouteTransition(
          key: state.pageKey,
          child: const _Placeholder('Search — Phase 12'),
        ),
      ),

      // StatefulShellRoute — preserves per-tab navigation stacks
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // Branch 0 — Notes
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/notes',
              pageBuilder: (context, state) => pageRouteTransition(
                key: state.pageKey,
                child: const DesignPreviewScreen(), // replaced Phase 7
              ),
              routes: [
                GoRoute(
                  path: ':id/edit',
                  pageBuilder: (context, state) => pageRouteTransition(
                    key: state.pageKey,
                    child: _Placeholder(
                        'Note Editor — ${state.pathParameters['id']}'),
                  ),
                ),
              ],
            ),
          ]),

          // Branch 1 — Tasks
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/tasks',
              pageBuilder: (context, state) => pageRouteTransition(
                key: state.pageKey,
                child: const _Placeholder('Tasks — Phase 8'),
              ),
              routes: [
                GoRoute(
                  path: ':id/edit',
                  pageBuilder: (context, state) => pageRouteTransition(
                    key: state.pageKey,
                    child: _Placeholder(
                        'Task Editor — ${state.pathParameters['id']}'),
                  ),
                ),
              ],
            ),
          ]),

          // Branch 2 — Categories
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/categories',
              pageBuilder: (context, state) => pageRouteTransition(
                key: state.pageKey,
                child: const _Placeholder('Categories — Phase 6'),
              ),
            ),
          ]),

          // Branch 3 — Settings
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => pageRouteTransition(
                key: state.pageKey,
                child: const _Placeholder('Settings — Phase 11'),
              ),
            ),
          ]),
        ],
      ),
    ],
  );
});

// ── Auth listenable ───────────────────────────────────────────────────────────

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
  }
}
