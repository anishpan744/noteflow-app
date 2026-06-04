import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/design/theme.dart';
import 'core/fcm_service.dart';
import 'core/notification_service.dart';
import 'core/router.dart';
import 'features/auth/auth_providers.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Notifications (no-op on web / unsupported platforms)
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await NotificationService.instance.init();
    await FCMService.instance.init();
  }

  runApp(const ProviderScope(child: NoteFlowApp()));
}

class NoteFlowApp extends ConsumerWidget {
  const NoteFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router    = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider);

    // Save the FCM token whenever a user is signed in.
    ref.listen(currentUserIdProvider, (prev, uid) {
      if (uid != null) {
        FCMService.instance.onNavigate = (route) => router.go(route);
        FCMService.instance.saveTokenForUser(uid);
      }
    });

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
