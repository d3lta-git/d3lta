// lib/widgets/gradient_title.dart
import 'package:flutter/material.dart';

class GradientTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final TextAlign textAlign;

  const GradientTitle({
    super.key,
    required this.title,
    this.fontSize = 36,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF26AEFB), Color(0xFFFFFFFF)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Text(
        title,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.08 * fontSize, // 0.08em equivalent
          shadows: [
            Shadow(
              offset: const Offset(0, 2),
              blurRadius: 15,
              color: const Color(0xFF26AEFB).withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}