import 'package:flutter/material.dart';

const _labelShadow = [Shadow(blurRadius: 4, color: Colors.black54)];

/// Top status bar shown on the map and catch-cow screens: nitrogen meter,
/// matching the Figma concept's persistent HUD (floating directly on the
/// background, no panel behind it).
class NitrogenHud extends StatelessWidget {
  final double nitrogen; // 0-100, counts up as the season goes on

  const NitrogenHud({super.key, required this.nitrogen});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('nitrogenmeter',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              shadows: _labelShadow,
            )),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 14,
            width: 180,
            child: Stack(
              children: [
                Container(color: Colors.white.withValues(alpha: 0.6)),
                FractionallySizedBox(
                  widthFactor: (nitrogen / 100).clamp(0, 1),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF3ECF8E), Color(0xFF12633C)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text('${nitrogen.round()}/100',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              shadows: _labelShadow,
            )),
      ],
    );
  }
}

/// Rounded stat badge, e.g. "+50 coins", "Nitrogen -10" — used across the
/// result screens.
class Pill extends StatelessWidget {
  final String text;
  final Color background;
  final Color textColor;
  final Widget? icon;

  const Pill({
    super.key,
    required this.text,
    required this.background,
    this.textColor = Colors.white,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// A rounded hill silhouette pinned to the bottom of the screen, like the
/// green horizon on the concept's result screens. [height] is the actual
/// visible height of the hill — only the top corners are rounded, so the
/// flat bottom always sits flush with the screen edge regardless of height
/// (no risk of the curve wrapping around a bottom corner).
class Hill extends StatelessWidget {
  final Color color;
  final double height;

  const Hill({super.key, required this.color, this.height = 140});

  @override
  Widget build(BuildContext context) {
    // No horizontal overflow past the screen edges — web's CanvasKit
    // renderer doesn't always composite intentionally-offscreen Positioned
    // content the same way native Skia does, which left a sliver gap at the
    // bottom corner. A flush left:0/right:0 rect with a big top radius
    // (clamped to half-width automatically) gives the same dome shape
    // without depending on any offscreen area at all.
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(300),
            topRight: Radius.circular(300),
          ),
        ),
      ),
    );
  }
}

/// White rounded "Back to the map" / primary CTA button used across result
/// screens.
class RoundButton extends StatelessWidget {
  final String label;
  final Color textColor;
  final VoidCallback onPressed;

  const RoundButton({super.key, required this.label, required this.textColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
