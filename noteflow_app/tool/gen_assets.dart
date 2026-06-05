// Generates the app icon and splash logo as PNGs using package:image.
// Run from the project root:  dart run tool/gen_assets.dart
//
// Produces a "Neural Glass" hexagonal node-network mark in electric blue
// on a deep-space navy background. Replace with a designed asset later.
import 'dart:io';
import 'dart:math' as math;
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as img;

void main() {
  _writeIcon();
  _writeSplash();
  stdout.writeln('Assets generated.');
}

// Neural Glass tokens
final _bg   = img.ColorRgb8(5, 8, 16);     // kBg0
final _neon = img.ColorRgb8(0, 212, 255);  // kNeon
final _violet = img.ColorRgb8(123, 97, 255); // kViolet

/// Computes the 6 vertices of a regular hexagon (pointy-top).
List<List<int>> _hexVertices(double cx, double cy, double r) {
  final pts = <List<int>>[];
  for (var i = 0; i < 6; i++) {
    final angle = math.pi / 3 * i - math.pi / 2;
    pts.add([
      (cx + r * math.cos(angle)).round(),
      (cy + r * math.sin(angle)).round(),
    ]);
  }
  return pts;
}

void _drawMark(img.Image image, double cx, double cy, double r,
    {bool fillBg = true}) {
  if (fillBg) img.fill(image, color: _bg);

  final outer = _hexVertices(cx, cy, r);
  final inner = _hexVertices(cx, cy, r * 0.5);

  // Connect center → each inner node, and inner ring
  final centerX = cx.round();
  final centerY = cy.round();

  // Faint connecting web (inner ring + spokes)
  for (var i = 0; i < 6; i++) {
    final a = inner[i];
    final b = inner[(i + 1) % 6];
    img.drawLine(image,
        x1: a[0], y1: a[1], x2: b[0], y2: b[1],
        color: _violet, thickness: 5, antialias: true);
    // spoke to center
    img.drawLine(image,
        x1: a[0], y1: a[1], x2: centerX, y2: centerY,
        color: _violet, thickness: 4, antialias: true);
    // inner node → matching outer node
    img.drawLine(image,
        x1: a[0], y1: a[1], x2: outer[i][0], y2: outer[i][1],
        color: _neon, thickness: 5, antialias: true);
  }

  // Outer hexagon edges (bright neon)
  for (var i = 0; i < 6; i++) {
    final a = outer[i];
    final b = outer[(i + 1) % 6];
    img.drawLine(image,
        x1: a[0], y1: a[1], x2: b[0], y2: b[1],
        color: _neon, thickness: 12, antialias: true);
  }

  // Nodes
  for (final p in outer) {
    img.fillCircle(image, x: p[0], y: p[1], radius: 20, color: _neon);
  }
  for (final p in inner) {
    img.fillCircle(image, x: p[0], y: p[1], radius: 12, color: _violet);
  }
  // Center node (bright)
  img.fillCircle(image, x: centerX, y: centerY, radius: 26, color: _neon);
}

void _writeIcon() {
  const size = 1024;
  final image = img.Image(width: size, height: size);
  _drawMark(image, size / 2, size / 2, size * 0.34, fillBg: true);
  File('assets/icon/app_icon.png').writeAsBytesSync(img.encodePng(image));
}

void _writeSplash() {
  const size = 768;
  // Transparent background so flutter_native_splash composites over its color.
  final image = img.Image(width: size, height: size, numChannels: 4);
  _drawMark(image, size / 2, size / 2, size * 0.32, fillBg: false);
  File('assets/splash/logo_animated.png')
      .writeAsBytesSync(img.encodePng(image));
}
