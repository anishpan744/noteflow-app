import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_providers.dart';
import '../features/auth/login_screen.dart';
import '../features/categories/category_list_screen.dart';
import '../features/notes/note_editor_screen.dart';
import '../features/notes/note_list_screen.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/tasks/calendar_screen.dart';
import '../features/tasks/task_editor_screen.dart';
import 'responsive_layout.dart';
import 'design/animations.dart';

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
          child: const SearchScreen(),
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
                child: const NoteListScreen(),
              ),
              routes: [
                GoRoute(
                  path: ':id/edit',
                  pageBuilder: (context, state) => pageRouteTransition(
                    key: state.pageKey,
                    child: NoteEditorScreen(
                        noteId: state.pathParameters['id']!),
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
                child: const CalendarScreen(),
              ),
              routes: [
                GoRoute(
                  path: ':id/edit',
                  pageBuilder: (context, state) => pageRouteTransition(
                    key: state.pageKey,
                    child: TaskEditorScreen(
                        taskId: state.pathParameters['id']!),
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
                child: const CategoryListScreen(),
              ),
            ),
          ]),

          // Branch 3 — Settings
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => pageRouteTransition(
                key: state.pageKey,
                child: const SettingsScreen(),
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
