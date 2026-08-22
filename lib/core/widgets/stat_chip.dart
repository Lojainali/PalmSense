import 'package:flutter/material.dart';

class StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color background;
  final Color foreground;

  const StatChip({
    super.key,
    required this.value,
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: foreground),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: foreground.withValues(alpha: 0.85)),
            ),
          ],
        ),
      ),
    );
  }
}
