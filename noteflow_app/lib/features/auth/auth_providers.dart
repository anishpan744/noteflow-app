import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ── DEV ONLY ──────────────────────────────────────────────────────────────────
// Temporary auth bypass for emulator visual verification (emulator Google OAuth
// WebView won't accept keyboard input). MUST be false for any commit / release.
const bool kDevBypassAuth = false;
const String _kDevUid = 'dev-preview-user';

// ── Auth state stream ─────────────────────────────────────────────────────────

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Synchronous UID — used by router redirect and repository providers.
/// Returns null when signed out.
final currentUserIdProvider = Provider<String?>((ref) {
  if (kDevBypassAuth) return _kDevUid;
  return ref.watch(authStateProvider).valueOrNull?.uid;
});

// ── Auth controller ───────────────────────────────────────────────────────────

class AuthController extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception('Sign-in cancelled');

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken:     googleAuth.idToken,
      );

      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return result.user;
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    state = const AsyncData(null);
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, User?>(AuthController.new);
