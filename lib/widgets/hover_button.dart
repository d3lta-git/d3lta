// lib/widgets/hover_button.dart
import 'package:flutter/material.dart';

class HoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;
  final double? width;
  final double? height;

  const HoverButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.width,
    this.height,
  });

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: widget.style?.copyWith(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(WidgetState.hovered)) {
                  return _isHovered
                      ? widget.style?.backgroundColor?.resolve(states)?.withValues(alpha: 0.8)
                      : widget.style?.backgroundColor?.resolve(states);
                }
                return widget.style?.backgroundColor?.resolve(states);
              },
            ),
            elevation: WidgetStateProperty.resolveWith<double?>(
              (states) {
                if (states.contains(WidgetState.hovered)) {
                  return (_isHovered ? 10.0 : 8.0);
                }
                return 8.0;
              },
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}