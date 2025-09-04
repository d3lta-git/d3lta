// lib/screens/qr_sales_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/app_state.dart';
import '../models/qr_code.dart';
import '../services/qr_generation_service.dart';
import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart'; // REMOVED: Unused import
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class QRSalesScreen extends StatefulWidget {
  final String orderId;
  
  const QRSalesScreen({super.key, required this.orderId});

  @override
  State<QRSalesScreen> createState() => _QRSalesScreenState();
}

class _QRSalesScreenState extends State<QRSalesScreen> {
  bool _isGenerating = false;
  List<QRCode> _generatedQRCodes = [];
  List<Uint8List?> _qrImages = [];

  @override
  void initState() {
    super.initState();
    _generateQRCodes();
  }

  Future<void> _generateQRCodes() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      // Get the app state to access the order details
      final appState = Provider.of<AppState>(context, listen: false);
      
      // Generate QR codes for each link entry
      final generatedCodes = <QRCode>[];
      final images = <Uint8List?>[];
      
      for (int i = 0; i < appState.linkEntries.length; i++) {
        final entry = appState.linkEntries[i];
        final data = _getQRData(entry);
        
        if (data != null) {
          // Create QR code model
          final qrCode = QRCode(
            id: '${widget.orderId}_$i',
            title: entry.title.isNotEmpty ? entry.title : 'QR Code #$i',
            data: data,
            type: entry.type,
            createdAt: DateTime.now(),
            orderId: widget.orderId,
          );
          
          generatedCodes.add(qrCode);
          
          // Generate QR code image
          final imageBytes = await QRGenerationService.generateQRCodeBytes(data);
          images.add(imageBytes);
        }
      }
      
      setState(() {
        _generatedQRCodes = generatedCodes;
        _qrImages = images;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al generar los códigos QR')),
        );
      }
    }
  }

  String? _getQRData(dynamic entry) {
    switch (entry.type) {
      case 'url_static':
        return entry.values['url'] as String?;
      case 'vcard':
        final name = entry.values['name'] as String? ?? '';
        final title = entry.values['title'] as String? ?? '';
        final company = entry.values['company'] as String? ?? '';
        final phone = entry.values['phone'] as String? ?? '';
        final email = entry.values['email'] as String? ?? '';
        final website = entry.values['website'] as String? ?? '';
        
        return 'BEGIN:VCARD\nVERSION:3.0\nFN:$name\nORG:$company\nTITLE:$title\nTEL:$phone\nEMAIL:$email\nURL:$website\nEND:VCARD';
      case 'wifi':
        final ssid = entry.values['ssid'] as String? ?? '';
        final password = entry.values['password'] as String? ?? '';
        return 'WIFI:S:$ssid;T:WPA;P:$password;;';
      case 'text':
        return entry.values['text'] as String?;
      case 'payment':
        return entry.values['paymentLink'] as String?;
      case 'geo':
        final lat = entry.values['latitude'] as String? ?? '';
        final lon = entry.values['longitude'] as String? ?? '';
        return 'geo:$lat,$lon';
      default:
        return null;
    }
  }

  Future<void> _downloadQRCode(int index) async {
    final qrCode = _generatedQRCodes[index];
    final imageBytes = _qrImages[index];
    
    if (imageBytes != null) {
      try {
        // Generate file name
        final fileName = QRGenerationService.generateFileName(
          qrCode.title, 
          widget.orderId, 
          index
        );
        
        // Save to file
        final filePath = await QRGenerationService.saveQRCodeToFile(
          imageBytes, 
          fileName
        );
        
        if (filePath != null && mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${qrCode.title} guardado exitosamente')),
          );
        } else {
          throw Exception('No se pudo guardar el archivo');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al guardar el código QR')),
          );
        }
      }
    }
  }

  Future<void> _shareQRCode(int index) async {
    final qrCode = _generatedQRCodes[index];
    final imageBytes = _qrImages[index];
    
    if (imageBytes != null) {
      try {
        // Generate file name
        final fileName = QRGenerationService.generateFileName(
          qrCode.title, 
          widget.orderId, 
          index
        );
        
        // Save to temporary file for sharing
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/$fileName.png';
        final file = File(filePath);
        await file.writeAsBytes(imageBytes);
        
        // Share the file
        await Share.shareXFiles(
          [XFile(filePath)],
          text: 'Aquí está tu código QR: ${qrCode.title}',
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al compartir el código QR')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tus Códigos QR'),
        backgroundColor: const Color(0xFF0A0A0F),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withValues(alpha: 0.9),
          child: _isGenerating
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFFF7DF4E)),
                      SizedBox(height: 20),
                      Text(
                        'Generando tus códigos QR...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
              : _generatedQRCodes.isEmpty
                  ? const Center(
                      child: Text(
                        'No se generaron códigos QR',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '¡Tu pedido ha sido procesado exitosamente!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF7DF4E),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Aquí tienes los códigos QR que solicitaste:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 20),
                          for (int i = 0; i < _generatedQRCodes.length; i++)
                            _buildQRCard(i),
                          const SizedBox(height: 30),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.check, color: Colors.black),
                              label: const Text(
                                'Finalizar',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF7DF4E),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildQRCard(int index) {
    final qrCode = _generatedQRCodes[index];
    final imageBytes = _qrImages[index];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            qrCode.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          if (imageBytes != null)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: QrImageView(
                data: qrCode.data,
                version: QrVersions.auto,
                size: 200.0,
                gapless: false,
              ),
            )
          else
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'QR no disponible',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          const SizedBox(height: 15),
          Text(
            qrCode.type.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => _downloadQRCode(index),
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26AEFB),
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _shareQRCode(index),
                icon: const Icon(Icons.share, size: 18),
                label: const Text('Compartir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7DF4E),
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}