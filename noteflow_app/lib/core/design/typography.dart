import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

TextTheme buildTextTheme({bool light = false}) {
  final primary   = light ? kLightTextPrimary   : kTextPrimary;
  final secondary = light ? kLightTextSecondary : kTextSecondary;
  final muted     = light ? kLightTextMuted     : kTextMuted;

  return TextTheme(
    // Display — Rajdhani, angular technical headings
    displayLarge:  GoogleFonts.rajdhani(fontSize: 32, fontWeight: FontWeight.w700, color: primary),
    displayMedium: GoogleFonts.rajdhani(fontSize: 28, fontWeight: FontWeight.w700, color: primary),
    displaySmall:  GoogleFonts.rajdhani(fontSize: 24, fontWeight: FontWeight.w600, color: primary),

    // Headline — Rajdhani
    headlineLarge:  GoogleFonts.rajdhani(fontSize: 22, fontWeight: FontWeight.w600, color: primary),
    headlineMedium: GoogleFonts.rajdhani(fontSize: 20, fontWeight: FontWeight.w600, color: primary),
    headlineSmall:  GoogleFonts.rajdhani(fontSize: 18, fontWeight: FontWeight.w600, color: primary),

    // Title — DM Sans
    titleLarge:  GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600, color: primary),
    titleMedium: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: primary),
    titleSmall:  GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: primary),

    // Body — DM Sans, humanist clarity
    bodyLarge:  GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w400, color: primary),
    bodyMedium: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400, color: primary),
    bodySmall:  GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w400, color: secondary),

    // Label — JetBrains Mono, timestamps & metadata
    labelLarge:  GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w400, color: secondary),
    labelMedium: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w400, color: secondary),
    labelSmall:  GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w400, color: muted),
  );
}
