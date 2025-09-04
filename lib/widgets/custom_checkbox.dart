import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;
  final String? title;
  final String? subtitle;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: value ? const Color(0xFF26AEFB) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: value ? const Color(0xFFA0E9FF) : Colors.white.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: value
              ? const Icon(
                  Icons.check,
                  size: 18,
                  color: Colors.white,
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    color: value ? const Color(0xFFF7DF4E) : Colors.white,
                    fontWeight: value ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
