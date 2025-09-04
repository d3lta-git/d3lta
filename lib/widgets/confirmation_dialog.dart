// lib/widgets/confirmation_dialog.dart
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../screens/qr_sales_screen.dart';

// Diálogo de confirmación
class ConfirmationDialog extends StatefulWidget {
  final AppState appState;

  const ConfirmationDialog({super.key, required this.appState});

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String _preferredMethod = 'whatsapp';
  bool _acceptPolicies = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Method to validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  // Method to validate the form
  bool _validateForm() {
    // Validate that all required fields are filled
    final isNameValid = _nameController.text.trim().isNotEmpty;
    final isEmailValid = _emailController.text.trim().isNotEmpty && 
                         _isValidEmail(_emailController.text.trim());
    final isPhoneValid = _phoneController.text.trim().isNotEmpty;
    final isPolicyAccepted = _acceptPolicies;
    // Use isSellerKeywordValid instead of the undefined isSellerKeywordStatusValid
    final isSellerKeywordStatusValid = widget.appState.isSellerKeywordValid;

    return isNameValid && isEmailValid && isPhoneValid && 
           isPolicyAccepted && isSellerKeywordStatusValid;
  }

  @override
  Widget build(BuildContext context) {
    final costs = widget.appState.calculateCosts();
    final total = costs['total'] as double? ?? 0.0;

    return Dialog(
      backgroundColor: const Color(0xFF101018),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Confirmar Solicitud',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Completá tus datos para recibir la cotización formal.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumen de tu pedido:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Resumen del pedido
                      Text(
                        'Diseño: ${widget.appState.designComplexity}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Funcionalidad: ${widget.appState.dynamicUrlTier}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Servicio de Diseño: ${widget.appState.designService}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total: ${widget.appState.formatPrice(total)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre y Apellido',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                  onChanged: (_) {
                    // Re-validate the form when any field changes
                    setState(() {});
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo para confirmación',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu email';
                    }
                    if (!_isValidEmail(value)) {
                      return 'Por favor ingresa un email válido';
                    }
                    return null;
                  },
                  onChanged: (_) {
                    // Re-validate the form when any field changes
                    setState(() {});
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Número de Teléfono',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu teléfono';
                    }
                    return null;
                  },
                  onChanged: (_) {
                    // Re-validate the form when any field changes
                    setState(() {});
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  'Vía de contacto preferida',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('WhatsApp'),
                      selected: _preferredMethod == 'whatsapp',
                      selectedColor: const Color(0xFF25D366),
                      onSelected: (selected) {
                        setState(() {
                          _preferredMethod = selected ? 'whatsapp' : '';
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('Telegram'),
                      selected: _preferredMethod == 'telegram',
                      selectedColor: const Color(0xFF0088CC),
                      onSelected: (selected) {
                        setState(() {
                          _preferredMethod = selected ? 'telegram' : '';
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('SMS'),
                      selected: _preferredMethod == 'sms',
                      selectedColor: const Color(0xFF26AEFB),
                      onSelected: (selected) {
                        setState(() {
                          _preferredMethod = selected ? 'sms' : '';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptPolicies,
                      onChanged: (value) {
                        setState(() {
                          _acceptPolicies = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF26AEFB),
                    ),
                    const Expanded(
                      child: Text(
                        'He leído y acepto los Términos y Condiciones y la Política de Privacidad.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _validateForm()
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                // Generate a unique order ID
                                final orderId = DateTime.now().millisecondsSinceEpoch.toString();
                                
                                // Navigate to QR sales screen
                                Navigator.of(context).pop(); // Close confirmation dialog
                                Navigator.of(context).pop(); // Close summary section
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QRSalesScreen(orderId: orderId),
                                  ),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7DF4E),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Confirmar y Enviar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}