// lib/widgets/design_integration_details.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

// Widget for design integration details
class DesignIntegrationDetails extends StatefulWidget {
  const DesignIntegrationDetails({super.key});

  @override
  State<DesignIntegrationDetails> createState() => _DesignIntegrationDetailsState();
}

class _DesignIntegrationDetailsState extends State<DesignIntegrationDetails> {
  String _fileName = 'Ningún archivo seleccionado';
  Uint8List? _fileBytes;

  Future<void> _pickDesignFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // Permitir cualquier tipo de archivo
        withData: true, // Para obtener los bytes del archivo
      );

      if (result != null && mounted) {
        PlatformFile file = result.files.first;
        setState(() {
          _fileName = file.name;
          _fileBytes = file.bytes;
        });
        
        // Actualizar el estado de la aplicación con el archivo seleccionado
        final appState = Provider.of<AppState>(context, listen: false);
        appState.setDesignIntegrationFile(file.bytes, file.name);
      }
    } catch (e) {
      // Manejar errores si es necesario
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al seleccionar el archivo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Archivo de Diseño Externo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Sube tu diseño (afiche, menú) para que podamos integrar el QR de forma armónica.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: _pickDesignFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26AEFB).withValues(alpha: 0.2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Seleccionar archivo'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _fileName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (_fileBytes != null) ...[
            const SizedBox(height: 10),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.insert_drive_file,
                      size: 40,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _fileName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}