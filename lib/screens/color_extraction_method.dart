// lib/screens/color_extraction_method.dart
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async'; // Added for Completer
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palette_generator/palette_generator.dart';
import '../models/app_state.dart';

class ColorExtractor extends StatefulWidget {
  final Uint8List imageBytes;
  
  const ColorExtractor({super.key, required this.imageBytes});

  @override
  State<ColorExtractor> createState() => _ColorExtractorState();
}

class _ColorExtractorState extends State<ColorExtractor> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  Future<void> extractColors() async {
    try {
      // Create an image from the bytes
      final Completer<ui.Image> completer = Completer<ui.Image>();
      ui.decodeImageFromList(widget.imageBytes, (ui.Image img) {
        completer.complete(img);
      });
      final image = await completer.future;
      
      // Generate a palette from the image
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        MemoryImage(widget.imageBytes),
        size: image.width > 0 && image.height > 0 ? Size(image.width.toDouble(), image.height.toDouble()) : const Size(100, 100),
        region: Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      );
      
      // Extract the dominant colors
      final colors = <Color>[];
      if (paletteGenerator.dominantColor != null) {
        colors.add(paletteGenerator.dominantColor!.color);
      }
      
      // Add vibrant colors
      if (paletteGenerator.vibrantColor != null) {
        colors.add(paletteGenerator.vibrantColor!.color);
      }
      
      if (paletteGenerator.lightVibrantColor != null) {
        colors.add(paletteGenerator.lightVibrantColor!.color);
      }
      
      if (paletteGenerator.darkVibrantColor != null) {
        colors.add(paletteGenerator.darkVibrantColor!.color);
      }
      
      // Add muted colors
      if (paletteGenerator.mutedColor != null) {
        colors.add(paletteGenerator.mutedColor!.color);
      }
      
      if (paletteGenerator.lightMutedColor != null) {
        colors.add(paletteGenerator.lightMutedColor!.color);
      }
      
      if (paletteGenerator.darkMutedColor != null) {
        colors.add(paletteGenerator.darkMutedColor!.color);
      }
      
      // Update the app state with the extracted colors
      if (mounted) {
        final appState = Provider.of<AppState>(context, listen: false);
        
        // Ensure we have the right number of colors based on design complexity
        final requiredColorCount = appState.colorCount;
        final List<Color> finalColors = [];
        
        // Fill with extracted colors first
        for (int i = 0; i < requiredColorCount && i < colors.length; i++) {
          finalColors.add(colors[i]);
        }
        
        // If we don't have enough colors, fill with defaults
        final defaultColors = [
          const Color(0xFF26AEFB),
          const Color(0xFFA0E9FF),
          const Color(0xFFFFFFFF),
          const Color(0xFFF7DF4E),
          const Color(0xFF0A0A0F),
          const Color(0xFFf87171),
          const Color(0xFFa78bfa),
        ];
        
        while (finalColors.length < requiredColorCount) {
          finalColors.add(defaultColors[finalColors.length % defaultColors.length]);
        }
        
        appState.setManualColors(finalColors);
      }
    } catch (e) {
      // If color extraction fails, use default colors
      if (mounted) {
        final appState = Provider.of<AppState>(context, listen: false);
        final requiredColorCount = appState.colorCount;
        final defaultColors = [
          const Color(0xFF26AEFB),
          const Color(0xFFA0E9FF),
          const Color(0xFFFFFFFF),
          const Color(0xFFF7DF4E),
          const Color(0xFF0A0A0F),
          const Color(0xFFf87171),
          const Color(0xFFa78bfa),
        ];
        
        final List<Color> finalColors = [];
        for (int i = 0; i < requiredColorCount; i++) {
          finalColors.add(defaultColors[i % defaultColors.length]);
        }
        
        appState.setManualColors(finalColors);
      }
    }
  }
}