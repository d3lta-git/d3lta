// lib/services/qr_generation_service.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class QRGenerationService {
  // Generate a QR code image as bytes
  static Future<Uint8List?> generateQRCodeImage(
    String data, {
    double size = 200.0,
    int version = 4,
  }) async {
    try {
      // Use the direct painter approach which is more reliable
      return await generateQRCodeBytes(data, size: size, version: version);
    } catch (e) {
      // Handle error
      return null;
    }
  }
  
  // Generate QR code using QrPainter directly
  static Future<Uint8List?> generateQRCodeBytes(
    String data, {
    double size = 200.0,
    int version = 4,
  }) async {
    try {
      // Create a recorder to capture the drawing
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      // Create the QR code painter
      final qrPainter = QrPainter(
        data: data,
        version: QrVersions.auto,
        gapless: false,
        // Updated to use eyeStyle and dataModuleStyle instead of deprecated color parameters
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Color(0xFF000000), // Black
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Color(0xFF000000), // Black
        ),
        // The background color should be handled by the container widget
      );
      
      // Draw the QR code
      qrPainter.paint(canvas, Size(size, size));
      
      // End recording and convert to image
      final picture = recorder.endRecording();
      final image = await picture.toImage(size.toInt(), size.toInt());
      
      // Convert image to bytes
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }
  
  // Save QR code image to file
  static Future<String?> saveQRCodeToFile(
    Uint8List imageBytes,
    String fileName,
  ) async {
    try {
      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.png';
      
      // Write the image bytes to file
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
      
      return filePath;
    } catch (e) {
      return null;
    }
  }
  
  // Generate file name for QR code
  static String generateFileName(String title, String orderId, int index) {
    // Create a safe file name by removing special characters
    final safeTitle = title.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    return '${safeTitle}_${orderId}_$index';
  }
}