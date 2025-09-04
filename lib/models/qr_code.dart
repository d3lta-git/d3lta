// lib/models/qr_code.dart
import 'dart:typed_data';

class QRCode {
  final String id;
  final String title;
  final String data; // The data encoded in the QR code
  final String type; // Type of data (url, vcard, wifi, etc.)
  final Uint8List? imageBytes; // Generated QR code image
  final DateTime createdAt;
  final String orderId; // Reference to the order this QR belongs to

  QRCode({
    required this.id,
    required this.title,
    required this.data,
    required this.type,
    this.imageBytes,
    required this.createdAt,
    required this.orderId,
  });

  // Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'data': data,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'orderId': orderId,
    };
  }

  // Create from map
  factory QRCode.fromMap(Map<String, dynamic> map) {
    return QRCode(
      id: map['id'],
      title: map['title'],
      data: map['data'],
      type: map['type'],
      createdAt: DateTime.parse(map['createdAt']),
      orderId: map['orderId'],
    );
  }
}