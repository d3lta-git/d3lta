// lib/widgets/font_selector_with_preview.dart
import 'package:flutter/material.dart';
import 'dart:math';

class FontSelectorWithPreview extends StatefulWidget {
  final String initialFont;
  final List<String> availableFonts;
  final List<String> previewPhrases;
  final Function(String) onFontChanged;
  final VoidCallback? onRemove;

  const FontSelectorWithPreview({
    super.key,
    required this.initialFont,
    required this.availableFonts,
    required this.previewPhrases,
    required this.onFontChanged,
    this.onRemove,
  });

  @override
  State<FontSelectorWithPreview> createState() => _FontSelectorWithPreviewState();
}

class _FontSelectorWithPreviewState extends State<FontSelectorWithPreview> {
  late String _selectedFont;
  late String _previewText;

  @override
  void initState() {
    super.initState();
    _selectedFont = widget.initialFont;
    _previewText = _getRandomPreviewPhrase();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _adjustFontSize();
    });
  }

  String _getRandomPreviewPhrase() {
    if (widget.previewPhrases.isEmpty) return 'Preview Text';
    final random = Random();
    return widget.previewPhrases[random.nextInt(widget.previewPhrases.length)];
  }

  void _adjustFontSize() {
    // In a real implementation, we would dynamically adjust the font size
    // to fit the preview container. For now, we'll use a fixed size.
    setState(() {
      // This would be implemented with a more complex layout algorithm
      // to dynamically adjust the font size based on the container size
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFffffff),
                  Color(0xFFA0E9FF),
                  Color(0xFF26AEFB),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFont,
                items: widget.availableFonts
                    .map((font) => DropdownMenuItem(
                          value: font,
                          child: Text(
                            font,
                            style: TextStyle(
                              fontFamily: _getFontFamily(font),
                              color: Colors.black,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedFont = value;
                      _previewText = _getRandomPreviewPhrase();
                    });
                    widget.onFontChanged(value);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _adjustFontSize();
                    });
                  }
                },
                dropdownColor: const Color(0xFF101018),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Preview container
        Container(
          width: 120,
          height: 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Text(
              _previewText,
              style: TextStyle(
                fontFamily: _getFontFamily(_selectedFont),
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (widget.onRemove != null) ...[
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: widget.onRemove,
          ),
        ],
      ],
    );
  }

  String _getFontFamily(String fontName) {
    // Map font names to actual font families
    // In a real implementation, you would have the actual fonts loaded
    const fontMap = {
      'VT323': 'VT323',
      'Roboto': 'Roboto',
      'Open Sans': 'OpenSans',
      'Lato': 'Lato',
      'Montserrat': 'Montserrat',
      // Add more font mappings as needed
    };
    
    return fontMap[fontName] ?? 'Roboto';
  }
}