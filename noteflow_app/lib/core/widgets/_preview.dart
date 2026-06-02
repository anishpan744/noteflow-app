import 'package:flutter/material.dart';
import '../design/tokens.dart';
import 'glass_card.dart';
import 'neon_button.dart';

class DesignPreviewScreen extends StatelessWidget {
  const DesignPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background to make glass effect visible
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kBg0, Color(0xFF0A1628), kBg1],
              ),
            ),
          ),

          // Blurred accent orbs behind cards
          Positioned(
            top: 80,
            left: 60,
            child: _GlowOrb(color: kNeon),
          ),
          Positioned(
            top: 300,
            right: 40,
            child: _GlowOrb(color: kViolet),
          ),
          Positioned(
            bottom: 120,
            left: 100,
            child: _GlowOrb(color: kTeal),
          ),

          // Cards
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Neural Glass', style: tt.displayLarge),
                  const SizedBox(height: 4),
                  Text('Design System Preview', style: tt.bodySmall),
                  const SizedBox(height: 32),

                  // Card 1 — electric blue glow
                  GlassCard(
                    glowColor: kNeon,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(width: 8, height: 8,
                            decoration: const BoxDecoration(color: kNeon, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text('Electric Blue', style: tt.titleMedium?.copyWith(color: kNeon)),
                        ]),
                        const SizedBox(height: 8),
                        Text('GlassCard with kNeon glow. BackdropFilter blur=12, border kGlassBorder.', style: tt.bodySmall),
                        const SizedBox(height: 12),
                        Text('14:32 · Jun 2 2026', style: tt.labelSmall),
                      ],
                    ),
                  ),

                  // Card 2 — violet glow
                  GlassCard(
                    glowColor: kViolet,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(width: 8, height: 8,
                            decoration: const BoxDecoration(color: kViolet, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text('Violet', style: tt.titleMedium?.copyWith(color: kViolet)),
                        ]),
                        const SizedBox(height: 8),
                        Text('Tasks module accent. Used on task cards and calendar views.', style: tt.bodySmall),
                        const SizedBox(height: 12),
                        Text('PRIORITY · HIGH', style: tt.labelSmall?.copyWith(color: kAmber)),
                      ],
                    ),
                  ),

                  // Card 3 — no glow, pure glass
                  GlassCard(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('No Glow', style: tt.titleMedium),
                        const SizedBox(height: 8),
                        Text('Pure glass morphism — semi-transparent fill + 20% white border only.', style: tt.bodySmall),
                        const SizedBox(height: 12),
                        Row(children: [
                          _ColorSwatch(kNeon, 'Neon'),
                          const SizedBox(width: 8),
                          _ColorSwatch(kViolet, 'Violet'),
                          const SizedBox(width: 8),
                          _ColorSwatch(kTeal, 'Teal'),
                          const SizedBox(width: 8),
                          _ColorSwatch(kAmber, 'Amber'),
                          const SizedBox(width: 8),
                          _ColorSwatch(kCrimson, 'Crimson'),
                        ]),
                      ],
                    ),
                  ),

                  // NeonButton showcase
                  GlassCard(
                    glowColor: kNeon,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NeonButton', style: tt.titleMedium?.copyWith(color: kNeon)),
                        const SizedBox(height: 16),
                        Wrap(spacing: 12, runSpacing: 12, children: [
                          NeonButton(label: 'Primary', onTap: () {}, color: kNeon),
                          NeonButton(label: 'Tasks', onTap: () {}, color: kViolet),
                          NeonButton(label: 'Success', onTap: () {}, color: kTeal),
                          NeonButton(label: 'Warning', onTap: () {}, color: kAmber),
                          NeonButton(label: 'Danger', onTap: () {}, color: kCrimson),
                        ]),
                        const SizedBox(height: 12),
                        Wrap(spacing: 12, runSpacing: 12, children: [
                          NeonButton(label: 'Small', onTap: () {}, size: NeonButtonSize.small),
                          NeonButton(label: 'Normal', onTap: () {}),
                          NeonButton(label: 'Large', onTap: () {}, size: NeonButtonSize.large),
                        ]),
                        const SizedBox(height: 12),
                        Wrap(spacing: 12, runSpacing: 12, children: [
                          NeonButton(label: 'Ghost', onTap: () {}, ghost: true),
                          NeonButton(label: 'Loading', onTap: () {}, loading: true),
                          NeonButton(label: 'Disabled', onTap: null),
                        ]),
                      ],
                    ),
                  ),

                  // Typography showcase
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Typography', style: tt.titleMedium?.copyWith(color: kNeon)),
                        const SizedBox(height: 12),
                        Text('Display — Rajdhani Bold', style: tt.displaySmall),
                        Text('Headline Medium — Rajdhani', style: tt.headlineMedium),
                        Text('Body Large — DM Sans regular', style: tt.bodyLarge),
                        Text('Body Small — DM Sans secondary', style: tt.bodySmall),
                        Text('LABEL MONO · 11PT', style: tt.labelSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 80, spreadRadius: 20),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(this.color, this.label);
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 20, height: 20,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      ),
      const SizedBox(height: 4),
      Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9)),
    ]);
  }
}
