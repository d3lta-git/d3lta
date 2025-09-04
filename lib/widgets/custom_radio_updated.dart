// lib/widgets/custom_radio.dart
import 'package:flutter/material.dart';

class CustomRadio extends StatelessWidget {
  final String value;
  final String groupValue;
  final Function(String?) onChanged;
  final String title;
  final String? subtitle;
  final double? price;

  const CustomRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF26AEFB).withValues(alpha: 0.5) : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF26AEFB) : Colors.white70,
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF26AEFB) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? const Color(0xFFF7DF4E) : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (price != null)
              Text(
                '+ \$${price!.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Color(0xFFF7DF4E),
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        subtitle: subtitle != null
            ? Padding(
                padding: const EdgeInsets.only(left: 35, top: 5),
                child: Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              )
            : null,
        onTap: () => onChanged(value),
      ),
    );
  }
}