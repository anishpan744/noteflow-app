import 'package:flutter_riverpod/flutter_riverpod.dart';

// Stub — replaced with real Firebase Auth implementation in Phase 5.
final authStateProvider = StreamProvider<String?>((ref) {
  return Stream.value('preview-user');
});

// Synchronous read used by the router redirect — returns non-null so the
// shell is accessible during design preview (Phase 2).
final currentUserIdProvider = Provider<String?>((_) => 'preview-user');
