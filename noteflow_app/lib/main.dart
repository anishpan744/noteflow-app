import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/design/theme.dart';
import 'core/router.dart';

void main() {
  runApp(const ProviderScope(child: NoteFlowApp()));
}

class NoteFlowApp extends ConsumerWidget {
  const NoteFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router    = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'NoteFlow & TaskCanvas',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
