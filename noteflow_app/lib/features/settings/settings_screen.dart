import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../../core/design/theme.dart';
import '../../core/design/tokens.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/neon_button.dart';
import '../auth/auth_providers.dart';
import '../categories/category_providers.dart';
import '../notes/note_providers.dart';
import '../tasks/task_providers.dart';
import 'settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: kBg0,
      appBar: AppBar(
        backgroundColor: kBg0,
        title: Text('Settings', style: tt.headlineMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: const [
          _ProfileSection(),
          SizedBox(height: 16),
          _AppearanceSection(),
          SizedBox(height: 16),
          _NotificationsSection(),
          SizedBox(height: 16),
          _SecuritySection(),
          SizedBox(height: 16),
          _DataSection(),
          SizedBox(height: 16),
          _AccountSection(),
        ],
      ),
    );
  }
}

// ── Section shell ─────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children, this.glow});
  final String title;
  final List<Widget> children;
  final Color? glow;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GlassCard(
      glowColor: glow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(),
              style: tt.labelSmall?.copyWith(
                color: kTextMuted,
                letterSpacing: 1.2,
              )),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

// ── Profile ───────────────────────────────────────────────────────────────────

class _ProfileSection extends ConsumerWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt   = Theme.of(context).textTheme;
    final user = ref.watch(authStateProvider).valueOrNull;
    final name  = user?.displayName ?? 'NoteFlow User';
    final email = user?.email ?? 'Not signed in';
    final photo = user?.photoURL;

    return GlassCard(
      glowColor: kNeon,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kNeon, width: 2),
              boxShadow: [
                BoxShadow(color: kNeon.withValues(alpha: 0.3), blurRadius: 10),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: photo != null
                ? CachedNetworkImage(
                    imageUrl: photo,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        const Icon(PhosphorIconsFill.user, color: kNeon),
                  )
                : const Icon(PhosphorIconsFill.user, color: kNeon, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: tt.headlineSmall),
                const SizedBox(height: 2),
                Text(email,
                    style: tt.labelMedium?.copyWith(color: kTextMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Appearance ────────────────────────────────────────────────────────────────

class _AppearanceSection extends ConsumerWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt        = Theme.of(context).textTheme;
    final mode      = ref.watch(themeProvider);
    final accent    = ref.watch(accentColorProvider);
    final textSize  = ref.watch(textSizeProvider);

    return _Section(
      title: 'Appearance',
      children: [
        Text('Theme', style: tt.bodySmall?.copyWith(color: kTextSecondary)),
        const SizedBox(height: 8),
        _PillRow<ThemeMode>(
          options: const {
            ThemeMode.system: 'System',
            ThemeMode.light: 'Light',
            ThemeMode.dark: 'Dark',
          },
          selected: mode,
          onSelect: (m) => ref.read(themeProvider.notifier).setTheme(m),
        ),
        const SizedBox(height: 16),

        Text('Accent', style: tt.bodySmall?.copyWith(color: kTextSecondary)),
        const SizedBox(height: 8),
        Row(
          children: accentPresets.map((c) {
            final sel = c.toARGB32() == accent.toARGB32();
            return GestureDetector(
              onTap: () => ref.read(accentColorProvider.notifier).set(c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(right: 12),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: sel
                      ? Border.all(color: Colors.white, width: 2.5)
                      : null,
                  boxShadow: sel
                      ? [BoxShadow(color: c.withValues(alpha: 0.6), blurRadius: 10)]
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        Text('Text size', style: tt.bodySmall?.copyWith(color: kTextSecondary)),
        const SizedBox(height: 8),
        _PillRow<AppTextSize>(
          options: {for (final s in AppTextSize.values) s: s.label},
          selected: textSize,
          onSelect: (s) => ref.read(textSizeProvider.notifier).set(s),
        ),
      ],
    );
  }
}

// ── Notifications ─────────────────────────────────────────────────────────────

class _NotificationsSection extends ConsumerStatefulWidget {
  const _NotificationsSection();
  @override
  ConsumerState<_NotificationsSection> createState() =>
      _NotificationsSectionState();
}

class _NotificationsSectionState
    extends ConsumerState<_NotificationsSection> {
  bool _morningDigest = false;
  bool _overdueNudge = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final uid = ref.read(currentUserIdProvider);
    if (uid == null) {
      setState(() => _loaded = true);
      return;
    }
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final settings = (doc.data()?['settings'] ?? {}) as Map<String, dynamic>;
    setState(() {
      _morningDigest = settings['morningDigest'] == true;
      _overdueNudge = settings['overdueNudge'] == true;
      _loaded = true;
    });
  }

  Future<void> _save(String key, bool value) async {
    final uid = ref.read(currentUserIdProvider);
    if (uid == null) return;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'settings': {key: value},
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Notifications',
      children: [
        _ToggleRow(
          icon: PhosphorIconsRegular.sun,
          label: 'Morning digest',
          subtitle: "Daily summary of today's tasks",
          value: _morningDigest,
          enabled: _loaded,
          onChanged: (v) {
            setState(() => _morningDigest = v);
            _save('morningDigest', v);
          },
        ),
        const SizedBox(height: 8),
        _ToggleRow(
          icon: PhosphorIconsRegular.bellRinging,
          label: 'Overdue nudges',
          subtitle: 'Re-alert every 2 hours if incomplete',
          value: _overdueNudge,
          enabled: _loaded,
          onChanged: (v) {
            setState(() => _overdueNudge = v);
            _save('overdueNudge', v);
          },
        ),
      ],
    );
  }
}

// ── Security ──────────────────────────────────────────────────────────────────

class _SecuritySection extends ConsumerWidget {
  const _SecuritySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLock = ref.watch(appLockProvider);

    return _Section(
      title: 'Security',
      children: [
        _ToggleRow(
          icon: PhosphorIconsRegular.fingerprint,
          label: 'App lock',
          subtitle: 'Require biometric / PIN to open',
          value: appLock,
          onChanged: (v) async {
            if (v) {
              final auth = LocalAuthentication();
              try {
                final canCheck = await auth.isDeviceSupported();
                if (!canCheck) {
                  if (context.mounted) {
                    _snack(context, 'No device lock available.');
                  }
                  return;
                }
                final ok = await auth.authenticate(
                  localizedReason: 'Confirm to enable app lock',
                  options: const AuthenticationOptions(stickyAuth: true),
                );
                if (ok) await ref.read(appLockProvider.notifier).set(true);
              } catch (e) {
                if (context.mounted) _snack(context, 'Auth unavailable.');
              }
            } else {
              await ref.read(appLockProvider.notifier).set(false);
            }
          },
        ),
      ],
    );
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────

class _DataSection extends ConsumerWidget {
  const _DataSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    return _Section(
      title: 'Data',
      children: [
        Text('Export all your notes, tasks, and categories as JSON.',
            style: tt.bodySmall),
        const SizedBox(height: 12),
        NeonButton(
          label: 'Export data',
          icon: const Icon(PhosphorIconsRegular.export),
          color: kTeal,
          size: NeonButtonSize.small,
          onTap: () => _export(context, ref),
        ),
      ],
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    try {
      final notes = ref.read(notesStreamProvider).valueOrNull ?? [];
      final tasks = ref.read(allTasksProvider).valueOrNull ?? [];
      final cats  = ref.read(categoriesProvider).valueOrNull ?? [];

      final data = {
        'exportedAt': DateTime.now().toIso8601String(),
        'categories': cats.map((c) => c.toJson()).toList(),
        'notes': notes.map((n) => n.toJson()).toList(),
        'tasks': tasks.map((t) => t.toJson()).toList(),
      };
      final json = const JsonEncoder.withIndent('  ').convert(data);

      final dir = await getTemporaryDirectory();
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/noteflow_export_$stamp.json');
      await file.writeAsString(json);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'NoteFlow data export',
      );
    } catch (e) {
      if (context.mounted) _snack(context, 'Export failed: $e');
    }
  }
}

// ── Account ───────────────────────────────────────────────────────────────────

class _AccountSection extends ConsumerWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _Section(
      title: 'Account',
      glow: kCrimson,
      children: [
        SizedBox(
          width: double.infinity,
          child: NeonButton(
            label: 'Sign Out',
            icon: const Icon(PhosphorIconsRegular.signOut),
            color: kTextSecondary,
            ghost: true,
            onTap: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: NeonButton(
            label: 'Delete Account',
            icon: const Icon(PhosphorIconsRegular.trash),
            color: kCrimson,
            onTap: () => _confirmDelete(context, ref),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kBg2,
        title: Text('Delete account?',
            style: Theme.of(ctx).textTheme.titleMedium),
        content: Text(
          'This permanently deletes your account and all data. '
          'This cannot be undone.',
          style: Theme.of(ctx).textTheme.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: kTextSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: kCrimson)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final uid = ref.read(currentUserIdProvider);
    try {
      if (uid != null) {
        // Deleting the user doc triggers cleanupDeletedUser (once deployed).
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      }
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (_) {
      // If re-auth is required, fall back to sign-out.
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _PillRow<T> extends StatelessWidget {
  const _PillRow({
    required this.options,
    required this.selected,
    required this.onSelect,
  });
  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.entries.map((e) {
        final sel = e.key == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: sel ? kNeon.withValues(alpha: 0.15) : kBg2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: sel ? kNeon : kGlassBorder),
              ),
              child: Center(
                child: Text(e.value,
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
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.enabled = true,
  });
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: kTextSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: tt.titleSmall),
              if (subtitle != null)
                Text(subtitle!,
                    style: tt.labelMedium?.copyWith(color: kTextMuted)),
            ],
          ),
        ),
        Switch(
          value: value,
          activeColor: kNeon,
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}

void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg, style: const TextStyle(color: kTextPrimary)),
      backgroundColor: kBg3,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
