// lib/screens/contratacion_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../models/app_state.dart';
import '../widgets/custom_checkbox.dart';
import '../widgets/custom_radio.dart';
import '../widgets/font_selector_with_preview.dart';
import '../screens/qr_sales_screen.dart';

// Constantes de color del prototipo
const Color primaryYellow = Color(0xFFF7DF4E);
const Color primaryBlue = Color(0xFF26AEFB);
const Color lightBlue = Color(0xFFA0E9FF);
const Color darkBackground = Color(0xFF0A0A0F);
const Color darkBackgroundLight = Color(0xFF101018);

class ContratacionScreen extends StatefulWidget {
  const ContratacionScreen({super.key});

  @override
  State<ContratacionScreen> createState() => _ContratacionScreenState();
}

class _ContratacionScreenState extends State<ContratacionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contratar el servicio'),
        backgroundColor: darkBackground,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header
                const HeaderSection(),
                const SizedBox(height: 20),
                
                // Selector de moneda
                Consumer<AppState>(
                  builder: (context, appState, child) {
                    return CurrencySelector(
                      currentCurrency: appState.currentCurrency,
                      onChanged: appState.setCurrentCurrency,
                    );
                  },
                ),
                const SizedBox(height: 20),
                
                // Contenido principal en dos columnas
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 900) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Columna principal (pasos)
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Consumer<AppState>(
                                  builder: (context, appState, child) {
                                    return BaseServiceSection(
                                      designComplexity: appState.designComplexity,
                                      dynamicUrlTier: appState.dynamicUrlTier,
                                      designService: appState.designService,
                                      onDesignComplexityChanged: appState.setDesignComplexity,
                                      onDynamicUrlTierChanged: appState.setDynamicUrlTier,
                                      onDesignServiceChanged: appState.setDesignService,
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                const ProjectInfoSection(),
                                const SizedBox(height: 20),
                                const FunctionalityAndRequirementsSection(),
                                const SizedBox(height: 20),
                                const AddonsSection(),
                                const SizedBox(height: 20),
                                const PrintingServiceSection(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Columna lateral (resumen)
                          const Expanded(
                            flex: 1,
                            child: SummarySection(),
                          ),
                        ],
                      );
                    } else {
                      // Diseño para móviles (una sola columna)
                      return Column(
                        children: [
                          Consumer<AppState>(
                            builder: (context, appState, child) {
                              return BaseServiceSection(
                                designComplexity: appState.designComplexity,
                                dynamicUrlTier: appState.dynamicUrlTier,
                                designService: appState.designService,
                                onDesignComplexityChanged: appState.setDesignComplexity,
                                onDynamicUrlTierChanged: appState.setDynamicUrlTier,
                                onDesignServiceChanged: appState.setDesignService,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          const ProjectInfoSection(),
                          const SizedBox(height: 20),
                          const FunctionalityAndRequirementsSection(),
                          const SizedBox(height: 20),
                          const AddonsSection(),
                          const SizedBox(height: 20),
                          const PrintingServiceSection(),
                          const SizedBox(height: 20),
                          const SummarySection(),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Sección de encabezado
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png', // Asegúrate de tener este asset
          height: 100,
        ),
        const SizedBox(height: 20),
        const Text(
          'Contratar el servicio',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7DF4E),
            shadows: [
              Shadow(
                color: Color(0xFF26AEFB),
                blurRadius: 10.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Construye tu pedido a medida y obtén una cotización al instante.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

// Selector de moneda
class CurrencySelector extends StatefulWidget {
  final String currentCurrency;
  final Function(String) onChanged;

  const CurrencySelector({
    super.key,
    required this.currentCurrency,
    required this.onChanged,
  });

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant CurrencySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentCurrency != widget.currentCurrency) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'MONEDA:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(width: 10),
            Stack(
              children: [
                Container(
                  width: 120, // Ancho fijo para contener ambos botones
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'ARS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'USD',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: widget.currentCurrency == 'ARS' 
                          ? const Offset(0, 0) 
                          : const Offset(60, 0), // 60 es la mitad del ancho total
                      child: Container(
                        width: 60, // Mitad del ancho total
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [primaryBlue, primaryYellow],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: primaryBlue.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: 120, // Ancho fijo para contener ambos botones
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            widget.onChanged('ARS');
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'ARS',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            widget.onChanged('USD');
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'USD',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Título de sección
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}


// Sección: Paso 1 - Nivel de Diseño y Funcionalidad
class BaseServiceSection extends StatefulWidget {
  final String designComplexity;
  final String dynamicUrlTier;
  final String designService;
  final Function(String) onDesignComplexityChanged;
  final Function(String) onDynamicUrlTierChanged;
  final Function(String) onDesignServiceChanged;

  const BaseServiceSection({
    super.key,
    required this.designComplexity,
    required this.dynamicUrlTier,
    required this.designService,
    required this.onDesignComplexityChanged,
    required this.onDynamicUrlTierChanged,
    required this.onDesignServiceChanged,
  });

  @override
  State<BaseServiceSection> createState() => _BaseServiceSectionState();
}

class _BaseServiceSectionState extends State<BaseServiceSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Paso 1: Nivel de Diseño y Funcionalidad'),
          const SizedBox(height: 20),
          
          // Nivel de Diseño del QR
          const Text(
            'Nivel de Diseño del QR',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Elige el nivel de detalle y creatividad. Esto definirá la cantidad de colores y opciones disponibles.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              CustomRadio(
                value: 'basic',
                groupValue: widget.designComplexity,
                onChanged: (value) {
                  widget.onDesignComplexityChanged(value!);
                },
                title: 'Diseño Básico (1 Revisión)',
                subtitle: 'Logo integrado, patrón estándar y hasta 3 colores de marca.',
                price: 40.0, // Precio en CHF
              ),
              CustomRadio(
                value: 'standard',
                groupValue: widget.designComplexity,
                onChanged: (value) {
                  widget.onDesignComplexityChanged(value!);
                },
                title: 'Diseño Estándar (2 Revisiones)',
                subtitle: 'Diseño creativo que integra tu logo y hasta 5 colores de marca.',
                price: 62.0, // Precio en CHF
              ),
              CustomRadio(
                value: 'premium',
                groupValue: widget.designComplexity,
                onChanged: (value) {
                  widget.onDesignComplexityChanged(value!);
                },
                title: 'Diseño Premium (4 Revisiones)',
                subtitle: 'Concepto artístico a medida, ilustraciones y hasta 7 colores de marca.',
                price: 110.0, // Precio en CHF
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Plan de Funcionalidad
          const Divider(color: Colors.white10),
          const SizedBox(height: 20),
          const Text(
            'Plan de Funcionalidad (URL Dinámica y Estadísticas)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Permite editar destinos a futuro y da acceso a estadísticas. Se abona anualmente.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              CustomRadio(
                value: 'none',
                groupValue: widget.dynamicUrlTier,
                onChanged: (value) {
                  widget.onDynamicUrlTierChanged(value!);
                },
                title: 'Ninguno (URL Estática)',
                subtitle: 'El destino del QR será fijo. No incluye URLs dinámicas ni estadísticas.',
              ),
              CustomRadio(
                value: 'starter',
                groupValue: widget.dynamicUrlTier,
                onChanged: (value) {
                  widget.onDynamicUrlTierChanged(value!);
                },
                title: 'Plan Starter',
                subtitle: 'Hasta 3 URLs dinámicas. Sin reportes de estadísticas.',
                price: 35.0, // Precio en CHF
              ),
              CustomRadio(
                value: 'business',
                groupValue: widget.dynamicUrlTier,
                onChanged: (value) {
                  widget.onDynamicUrlTierChanged(value!);
                },
                title: 'Plan Business',
                subtitle: 'Hasta 12 URLs dinámicas. Incluye reportes cuatrimestrales.',
                price: 95.0, // Precio en CHF
              ),
              CustomRadio(
                value: 'scale',
                groupValue: widget.dynamicUrlTier,
                onChanged: (value) {
                  widget.onDynamicUrlTierChanged(value!);
                },
                title: 'Plan Scale',
                subtitle: 'Hasta 30 URLs dinámicas. Incluye reportes trimestrales.',
                price: 225.0, // Precio en CHF
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Servicio de Diseño Gráfico Extendido
          const Divider(color: Colors.white10),
          const SizedBox(height: 20),
          const Text(
            'Servicio de Diseño Gráfico Extendido',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '¿Necesitas que el QR sea parte de un diseño más grande, como un afiche o un post para redes?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              CustomRadio(
                value: 'none',
                groupValue: widget.designService,
                onChanged: (value) {
                  widget.onDesignServiceChanged(value!);
                },
                title: 'No, solo el archivo del QR',
                subtitle: 'Ideal si ya tenés tu propio diseño y solo necesitás integrar el QR.',
              ),
              CustomRadio(
                value: 'integration',
                groupValue: widget.designService,
                onChanged: (value) {
                  widget.onDesignServiceChanged(value!);
                },
                title: 'Sí, integrar en un Diseño Externo',
                subtitle: 'Nos enviás tu diseño (afiche, menú) y nosotros integramos el QR de forma armónica.',
                price: 13.0, // Precio en CHF
              ),
              Column(
                children: [
                  CustomRadio(
                    value: 'complex',
                    groupValue: widget.designService,
                    onChanged: (value) {
                      widget.onDesignServiceChanged(value!);
                    },
                    title: 'Sí, crear un Diseño Complejo (Afiche/Folleto)',
                    subtitle: 'Diseñamos una pieza gráfica elaborada y detallada que incluya tu QR.',
                    price: 98.0, // Precio en CHF
                  ),
                  // Show details when complex design service is selected
                  if (widget.designService == 'complex')
                    const Padding(
                      padding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                      child: DesignComplexDetails(),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Sección: Paso 2 - Información Creativa
class ProjectInfoSection extends StatefulWidget {
  const ProjectInfoSection({super.key});

  @override
  State<ProjectInfoSection> createState() => _ProjectInfoSectionState();
}

class _ProjectInfoSectionState extends State<ProjectInfoSection> {
  late TextEditingController _brandInfoController;
  late TextEditingController _sellerKeywordController;
  String _logoFileName = 'Ningún archivo seleccionado';
  Uint8List? _logoImageBytes;
  String _colorImageFileName = 'Ningún archivo seleccionado';
  Uint8List? _colorImageBytes;

  @override
  void initState() {
    super.initState();
    _brandInfoController = TextEditingController();
    _sellerKeywordController = TextEditingController();
  }

  @override
  void dispose() {
    _brandInfoController.dispose();
    _sellerKeywordController.dispose();
    super.dispose();
  }

  int _getTypographyLimit(String designService) {
    switch (designService) {
      case 'integration':
        return 2;
      case 'complex':
        return 3;
      default:
        return 1;
    }
  }

  Future<void> _pickLogoFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true, // Para obtener los bytes de la imagen
      );

      if (result != null && mounted) {
        PlatformFile file = result.files.first;
        setState(() {
          _logoFileName = file.name;
          _logoImageBytes = file.bytes;
        });
      }
    } catch (e) {
      // Manejar errores si es necesario
      // Error al seleccionar el archivo: $e
    }
  }

  Future<void> _pickColorImageFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true, // Para obtener los bytes de la imagen
      );

      if (result != null && mounted) {
        PlatformFile file = result.files.first;
        setState(() {
          _colorImageFileName = file.name;
          _colorImageBytes = file.bytes;
        });
        
        // TODO: Implement color extraction from image
        // This would require additional libraries or custom implementation
        // For now, we'll just show the image preview
      }
    } catch (e) {
      // Manejar errores si es necesario
      // Error al seleccionar el archivo: $e
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Actualizar los controladores con los valores del estado
        _brandInfoController.text = appState.brandInfo;
        _sellerKeywordController.text = appState.sellerKeyword;

        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'Paso 2: Información Creativa'),
              const SizedBox(height: 20),
              
              // Descripción General del Estilo
              const Text(
                'Descripción General del Estilo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Describe la visión, el concepto y la identidad de marca que debe reflejar el diseño del QR.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _brandInfoController,
                maxLines: 4,
                onChanged: (value) {
                  appState.setBrandInfo(value);
                },
                decoration: InputDecoration(
                  hintText: 'Somos una empresa dedicada a...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                '${_brandInfoController.text.length}/1200',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Identidad Visual
              const Divider(color: Colors.white10),
              const SizedBox(height: 20),
              const Text(
                'Identidad Visual',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              
              // Logo (placeholder)
              const Text(
                'Logo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sube tu logo (PNG, JPG, SVG).',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickLogoFile,
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
                      _logoFileName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _logoImageBytes != null
                    ? Image.memory(
                        _logoImageBytes!,
                        fit: BoxFit.contain,
                      )
                    : const Center(
                        child: Text(
                          'PREVISUALIZACIÓN DEL LOGO',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                      ),
              ),
              
              const SizedBox(height: 20),
              
              // Tipografías
              const Text(
                'Sugerencia de Tipografías',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'El número de tipografías que puedes añadir depende del "Servicio de Diseño Extendido" que elijas.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Consumer<AppState>(
                builder: (context, appState, child) {
                  final limit = _getTypographyLimit(appState.designService);
                  final canAddMore = appState.selectedFonts.length < limit;
                  
                  return Column(
                    children: [
                      Column(
                        children: [
                          for (int i = 0; i < appState.selectedFonts.length; i++)
                            FontSelectorWithPreview(
                              key: ValueKey(i),
                              initialFont: appState.selectedFonts[i],
                              availableFonts: const [
                                'VT323',
                                'Roboto',
                                'Open Sans',
                                'Lato',
                                'Montserrat',
                                // Add more fonts as needed
                              ],
                              previewPhrases: const [
                                "El río es un camino de agua y de sol.",
                                "Sauces llorones besan la mansa orilla.",
                                "El junco se mece en un verde susurro.",
                                "La canoa duerme, espera la alborada.",
                                "Un ceibo en flor es sangre en el paisaje.",
                                "El agua borra huellas y viejos ecos.",
                                "La isla respira un aire de misterio.",
                                "Sol de la siesta, chicharra y letargo.",
                                "El pescador regresa con la luna nueva.",
                                "Casas de madera, de tiempo y de río.",
                                "La bruma esconde el alma del arroyo.",
                                "El silencio habla en voz de calandria.",
                              ],
                              onFontChanged: (font) {
                                final newFonts = List<String>.from(appState.selectedFonts);
                                newFonts[i] = font;
                                appState.setSelectedFonts(newFonts);
                              },
                              onRemove: appState.selectedFonts.length > 1
                                  ? () {
                                      final newFonts = List<String>.from(appState.selectedFonts);
                                      newFonts.removeAt(i);
                                      appState.setSelectedFonts(newFonts);
                                    }
                                  : null,
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (canAddMore)
                        ElevatedButton.icon(
                          onPressed: () {
                            final newFonts = List<String>.from(appState.selectedFonts);
                            newFonts.add('VT323');
                            appState.setSelectedFonts(newFonts);
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Sugerir otra tipografía'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      if (!canAddMore)
                        const Text(
                          'Has alcanzado el límite de tipografías para tu plan actual.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFFD700), // Amarillo dorado
                          ),
                        ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 20),
              
              // Paleta de Colores
              const Text(
                'Paleta de Colores',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'El número de colores que puedes seleccionar depende del Nivel de Diseño que elijas en el Paso 1.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Selector Manual'),
                    selected: appState.colorMode == 'picker',
                    selectedColor: const Color(0xFF26AEFB),
                    onSelected: (selected) {
                      appState.setColorMode('picker');
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Extraer de Imagen'),
                    selected: appState.colorMode == 'image',
                    selectedColor: const Color(0xFF26AEFB),
                    onSelected: (selected) {
                      appState.setColorMode('image');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (appState.colorMode == 'picker')
                Column(
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        // Create color pickers based on the design complexity
                        for (int i = 0; i < appState.colorCount; i++)
                          ColorPickerItem(
                            key: ValueKey(i),
                            color: i < appState.manualColors.length 
                                ? appState.manualColors[i] 
                                : const Color(0xFF26AEFB), // Default color if index is out of range
                            onChanged: (color) {
                              // Ensure we have enough colors in the list
                              final newColors = List<Color>.from(appState.manualColors);
                              while (newColors.length <= i) {
                                newColors.add(const Color(0xFF26AEFB));
                              }
                              newColors[i] = color;
                              appState.setManualColors(newColors);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'El plan ${appState.designComplexity == 'basic' ? 'Básico' : appState.designComplexity == 'standard' ? 'Estándar' : 'Premium'} permite hasta ${appState.designComplexity == 'basic' ? 3 : appState.designComplexity == 'standard' ? 5 : 7} colores.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFFD700), // Amarillo dorado
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    const Text(
                      'Sube una imagen de referencia y nosotros extraeremos la paleta de colores.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _pickColorImageFile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF26AEFB).withValues(alpha: 0.2),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Seleccionar imagen'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _colorImageFileName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _colorImageBytes != null
                          ? Image.memory(
                              _colorImageBytes!,
                              fit: BoxFit.contain,
                            )
                          : const Center(
                              child: Text(
                                'PREVISUALIZACIÓN DE IMAGEN',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              
              const SizedBox(height: 20),
              
              // Palabra Clave del Vendedor
              const Divider(color: Colors.white10),
              const SizedBox(height: 20),
              const Text(
                'Palabra Clave del Vendedor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Si tienes un código de vendedor, ingrésalo para aplicar un descuento especial.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _sellerKeywordController,
                onChanged: (value) async {
                  appState.setSellerKeyword(value);
                  // Validate the seller keyword
                  final isValid = await appState.validateSellerKeyword(value);
                  appState.setIsSellerKeywordValid(isValid);
                },
                decoration: InputDecoration(
                  hintText: 'Ej: VENDEDOR01',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                appState.isSellerKeywordValid 
                  ? '✓ ¡Clave válida! Descuento aplicado.' 
                  : (appState.sellerKeyword.trim().isEmpty ? '' : 'Clave de vendedor incorrecta.'),
                style: TextStyle(
                  fontSize: 14,
                  color: appState.isSellerKeywordValid ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widget para seleccionar color
class ColorPickerItem extends StatefulWidget {
  final Color color;
  final Function(Color) onChanged;

  const ColorPickerItem({
    Key? key,
    required this.color,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ColorPickerItem> createState() => _ColorPickerItemState();
}

class _ColorPickerItemState extends State<ColorPickerItem> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // En una implementación real, aquí se abriría un selector de color
        // Por ahora, solo cambiamos a un color aleatorio para demostrar la funcionalidad
        setState(() {
          // Using toARGB32() instead of deprecated value property
          _currentColor = Color(((_currentColor.toARGB32() & 0xFFFFFF) + 0x111111) | 0xFF000000);
        });
        widget.onChanged(_currentColor);
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: _currentColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
      ),
    );
  }
}

// Modelo para representar un tipo de destino
class DestinationType {
  final String value;
  final String text;

  DestinationType({required this.value, required this.text});
}


// Sección: Paso 3 - Configuración de Destinos
class FunctionalityAndRequirementsSection extends StatelessWidget {
  const FunctionalityAndRequirementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final destinationTypes = [
      DestinationType(value: 'url_static', text: 'URL (Estática)'),
      DestinationType(value: 'vcard', text: 'Info de Contacto (vCard)'),
      DestinationType(value: 'wifi', text: 'Conexión a Red Wi-Fi'),
      DestinationType(value: 'text', text: 'Texto Simple'),
      DestinationType(value: 'payment', text: 'Pagos Móviles (MercadoPago, etc.)'),
      DestinationType(value: 'geo', text: 'Geolocalización (Lat/Lon)'),
    ];

    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Check if we need to update any dynamic URL entries when the plan changes
        final dynamicUrlConfig = appState.dynamicUrlPrices[appState.dynamicUrlTier] ?? {};
        final limit = dynamicUrlConfig['limit'] as int? ?? 0;
        final dynamicUrlCount = appState.linkEntries.where((entry) => entry.isDynamic).length;
        
        // If we exceed the limit, we need to disable some dynamic URLs
        if (dynamicUrlCount > limit) {
          final entriesToUpdate = appState.linkEntries.where((entry) => entry.isDynamic).toList();
          // Keep only up to the limit
          for (int i = limit; i < entriesToUpdate.length; i++) {
            final index = appState.linkEntries.indexOf(entriesToUpdate[i]);
            if (index != -1) {
              final newEntries = List<LinkEntry>.from(appState.linkEntries);
              newEntries[index].isDynamic = false;
              // Update the type back to the original if it was changed
              if (newEntries[index].type == 'url_static' && 
                  newEntries[index].values.containsKey('originalType')) {
                newEntries[index].type = newEntries[index].values['originalType'] as String;
                newEntries[index].values.remove('originalType');
              }
              appState.setLinkEntries(newEntries);
            }
          }
        }
        
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'Paso 3: Configuración de Destinos'),
              const SizedBox(height: 20),
              const Text(
                'Configura los destinos para cada versión de tu diseño. El diseño base incluye una versión. Añade más si necesitas que el mismo estilo de QR apunte a diferentes lugares.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  for (int i = 0; i < appState.linkEntries.length; i++)
                    LinkEntryWidget(
                      key: ValueKey(i),
                      index: i,
                      entry: appState.linkEntries[i],
                      destinationTypes: destinationTypes,
                      onUpdate: (entry) {
                        final newEntries = List<LinkEntry>.from(appState.linkEntries);
                        newEntries[i] = entry;
                        appState.setLinkEntries(newEntries);
                      },
                      onRemove: appState.linkEntries.length > 1
                          ? () {
                              final newEntries = List<LinkEntry>.from(appState.linkEntries);
                              newEntries.removeAt(i);
                              appState.setLinkEntries(newEntries);
                            }
                          : null,
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: appState.linkEntries.length < 30
                        ? () {
                            final newEntries = List<LinkEntry>.from(appState.linkEntries);
                            newEntries.add(LinkEntry());
                            appState.setLinkEntries(newEntries);
                          }
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text('Añadir otra versión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26AEFB),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (appState.linkEntries.length >= 30)
                    const Text(
                      'Para más de 30 versiones, por favor contactanos para un paquete corporativo a medida.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFFD700), // Amarillo dorado
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widget para una entrada de destino
class LinkEntryWidget extends StatefulWidget {
  final int index;
  final LinkEntry entry;
  final List<DestinationType> destinationTypes;
  final Function(LinkEntry) onUpdate;
  final VoidCallback? onRemove;

  const LinkEntryWidget({
    Key? key,
    required this.index,
    required this.entry,
    required this.destinationTypes,
    required this.onUpdate,
    this.onRemove,
  }) : super(key: key);

  @override
  State<LinkEntryWidget> createState() => _LinkEntryWidgetState();
}

class _LinkEntryWidgetState extends State<LinkEntryWidget> {
  late LinkEntry _entry;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _extraTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _entry = widget.entry;
    _titleController.text = _entry.title;
    _notesController.text = _entry.notes;
    _extraTextController.text = _entry.extraText;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _extraTextController.dispose();
    super.dispose();
  }

  void _updateEntry() {
    widget.onUpdate(_entry);
  }

  void _handleTitleChange(String value) {
    _entry.title = value;
    _updateEntry();
  }

  void _handleTypeChange(String? value) {
    if (value != null) {
      _entry.type = value;
      _entry.values = {}; // Reset values when type changes
      _updateEntry();
    }
  }

  void _handleNotesChange(String value) {
    _entry.notes = value;
    _updateEntry();
  }

  void _handleExtraTextChange(String value) {
    _entry.extraText = value;
    _updateEntry();
  }

  void _handleHasExtraTextChange(bool? value) {
    if (value != null) {
      _entry.hasExtraText = value;
      _updateEntry();
    }
  }

  void _handleIsDynamicChange(bool? value) {
    if (value != null) {
      _entry.isDynamic = value;
      
      // If we're enabling dynamic URL, save the original type and change to url_static
      if (value) {
        if (_entry.type != 'url_static') {
          // Save the original type
          _entry.values['originalType'] = _entry.type;
          _entry.type = 'url_static';
        }
      } else {
        // If we're disabling dynamic URL, restore the original type if it was saved
        if (_entry.values.containsKey('originalType')) {
          _entry.type = _entry.values['originalType'] as String;
          _entry.values.remove('originalType');
        }
      }
      
      _updateEntry();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Versión #${widget.index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (widget.onRemove != null)
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: widget.onRemove,
                ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _titleController,
                  onChanged: _handleTitleChange,
                  decoration: InputDecoration(
                    labelText: 'Título del Destino',
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
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      // Type selector (hidden when dynamic)
                      Opacity(
                        opacity: _entry.isDynamic ? 0.0 : 1.0,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _entry.type,
                            items: widget.destinationTypes
                                .map((type) => DropdownMenuItem(
                                      value: type.value,
                                      child: Text(type.text,
                                          style: const TextStyle(color: Colors.white)),
                                    ))
                                .toList(),
                            onChanged: _entry.isDynamic
                                ? null
                                : _handleTypeChange,
                            dropdownColor: const Color(0xFF101018),
                            style: const TextStyle(color: Colors.white),
                            isExpanded: true,
                          ),
                        ),
                      ),
                      // Dynamic URL indicator (visible when dynamic)
                      if (_entry.isDynamic)
                        Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF26AEFB).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF26AEFB),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'URL (Dinámica)',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Campos específicos según el tipo de destino
          Column(
            children: [
              if (_entry.isDynamic)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF26AEFB).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF26AEFB).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Text(
                'Este destino será una URL Dinámica. Te entregaremos el link correspondiente una vez configurado.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            )
            else
              DestinationFields(
                type: _entry.type,
                values: _entry.values,
                onChanged: (values) {
                  _entry.values = values;
                  _updateEntry();
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _notesController,
            onChanged: _handleNotesChange,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Notas Específicas (Opcional)',
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
          ),
          const SizedBox(height: 10),
          Text(
            '${_notesController.text.length}/300',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Checkbox(
                value: _entry.hasExtraText,
                onChanged: _handleHasExtraTextChange,
                activeColor: const Color(0xFF26AEFB),
              ),
              const Text(
                'Añadir texto adicional',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(width: 20),
              Consumer<AppState>(
                builder: (context, appState, child) {
                  // Check if the dynamic URL feature is available based on the selected plan
                  final isDynamicUrlAvailable = appState.dynamicUrlTier != 'none';
                  final dynamicUrlConfig = appState.dynamicUrlPrices[appState.dynamicUrlTier] ?? {};
                  final limit = dynamicUrlConfig['limit'] as int? ?? 0;
                  
                  // Count how many dynamic URLs are already selected
                  final dynamicUrlCount = appState.linkEntries.where((entry) => entry.isDynamic).length;
                  final isLimitReached = dynamicUrlCount >= limit && limit > 0;
                  final isDisabled = !isDynamicUrlAvailable || (isLimitReached && !_entry.isDynamic);
                  
                  return Tooltip(
                    message: !isDynamicUrlAvailable 
                        ? 'Selecciona un plan de funcionalidad para habilitar URLs dinámicas' 
                        : isLimitReached && !_entry.isDynamic
                            ? 'Límite de $limit URLs dinámicas alcanzado para tu plan'
                            : '',
                    child: Checkbox(
                      value: _entry.isDynamic,
                      onChanged: isDisabled 
                          ? null 
                          : _handleIsDynamicChange,
                      activeColor: const Color(0xFF26AEFB),
                      // Make the checkbox visually different when disabled
                      side: isDisabled 
                          ? BorderSide(color: Colors.grey.shade700, width: 2) 
                          : null,
                      shape: isDisabled 
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(color: Colors.grey.shade700, width: 2),
                            ) 
                          : null,
                    ),
                  );
                },
              ),
              const Text(
                'Convertir en URL Dinámica',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          if (_entry.hasExtraText)
            Column(
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: _extraTextController,
                  onChanged: _handleExtraTextChange,
                  decoration: InputDecoration(
                    labelText: 'Texto adicional',
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
                ),
                const SizedBox(height: 5),
                Text(
                  '${_extraTextController.text.length}/50',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// Widget para los campos específicos según el tipo de destino
class DestinationFields extends StatelessWidget {
  final String type;
  final Map<String, dynamic> values;
  final Function(Map<String, dynamic>) onChanged;

  const DestinationFields({
    super.key,
    required this.type,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'url_static':
        return TextFormField(
          initialValue: values['url'] as String? ?? '',
          onChanged: (value) => onChanged({'url': value}),
          decoration: InputDecoration(
            labelText: 'URL de Destino',
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
          keyboardType: TextInputType.url,
        );
      case 'vcard':
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: values['name'] as String? ?? '',
                    onChanged: (value) => onChanged({'name': value, ...values}),
                    decoration: InputDecoration(
                      labelText: 'Nombre',
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
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: values['title'] as String? ?? '',
                    onChanged: (value) => onChanged({'title': value, ...values}),
                    decoration: InputDecoration(
                      labelText: 'Puesto',
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: values['company'] as String? ?? '',
                    onChanged: (value) => onChanged({'company': value, ...values}),
                    decoration: InputDecoration(
                      labelText: 'Empresa',
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
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: values['phone'] as String? ?? '',
                    onChanged: (value) => onChanged({'phone': value, ...values}),
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: values['email'] as String? ?? '',
              onChanged: (value) => onChanged({'email': value, ...values}),
              decoration: InputDecoration(
                labelText: 'Email',
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
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: values['website'] as String? ?? '',
              onChanged: (value) => onChanged({'website': value, ...values}),
              decoration: InputDecoration(
                labelText: 'Sitio Web',
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
              keyboardType: TextInputType.url,
            ),
          ],
        );
      case 'wifi':
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: values['ssid'] as String? ?? '',
                onChanged: (value) => onChanged({'ssid': value, ...values}),
                decoration: InputDecoration(
                  labelText: 'Nombre de Red (SSID)',
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
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                initialValue: values['password'] as String? ?? '',
                onChanged: (value) => onChanged({'password': value, ...values}),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
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
                obscureText: true,
              ),
            ),
          ],
        );
      case 'text':
        return TextFormField(
          initialValue: values['text'] as String? ?? '',
          onChanged: (value) => onChanged({'text': value}),
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'Texto a mostrar',
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
        );
      case 'payment':
        return TextFormField(
          initialValue: values['paymentLink'] as String? ?? '',
          onChanged: (value) => onChanged({'paymentLink': value}),
          decoration: InputDecoration(
            labelText: 'Link de Pago o CBU/CVU',
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
        );
      case 'geo':
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: values['latitude'] as String? ?? '',
                onChanged: (value) => onChanged({'latitude': value, ...values}),
                decoration: InputDecoration(
                  labelText: 'Latitud',
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                initialValue: values['longitude'] as String? ?? '',
                onChanged: (value) => onChanged({'longitude': value, ...values}),
                decoration: InputDecoration(
                  labelText: 'Longitud',
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// Sección: Paso 4 - Adicionales
class AddonsSection extends StatelessWidget {
  const AddonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'Paso 4: Adicionales'),
              const SizedBox(height: 20),
              
              // Entrega Express
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: GestureDetector(
                  onTap: () {
                    appState.setExpressDelivery(!appState.expressDelivery);
                  },
                  child: CustomCheckbox(
                    value: appState.expressDelivery,
                    onChanged: (value) {
                      appState.setExpressDelivery(value ?? false);
                    },
                    title: 'Entrega Express (48-72hs)',
                    subtitle: 'Tu proyecto recibe la máxima prioridad. El costo varía según la complejidad y funcionalidad de tu pedido.',
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Certificación para Gigantografía
              CertificationItem(appState: appState),
            ],
          ),
        );
      },
    );
  }
}

// Sección: Paso 5 - Servicio de Impresión
class PrintingServiceSection extends StatelessWidget {
  const PrintingServiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'Paso 5: Servicio de Impresión'),
              const SizedBox(height: 20),
              
              // Opción principal: Imprimir QR como Stickers
              Row(
                children: [
                  Checkbox(
                    value: appState.printStickers,
                    onChanged: (value) {
                      appState.setPrintStickers(value ?? false);
                    },
                    activeColor: const Color(0xFF26AEFB),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Imprimir QR como Stickers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
              const Text(
                'Recibí tu diseño listo para usar. Gestionamos la impresión y el control de calidad por vos.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              
              // Opciones de impresión (solo visibles si se selecciona la opción principal)
              if (appState.printStickers) ...[
                const SizedBox(height: 20),
                Container(
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
                        'Opciones de Impresión',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      // Cantidad y Tamaño
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Cantidad por cada versión',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  initialValue: appState.stickerQuantity.toString(),
                                  onChanged: (value) {
                                    final quantity = int.tryParse(value) ?? 50;
                                    // Ensure the quantity is within the valid range
                                    final clampedQuantity = quantity.clamp(1, 1000);
                                    appState.setStickerQuantity(clampedQuantity);
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    // Add helper text to show the valid range
                                    helperText: 'Mín: 1, Máx: 1000',
                                    helperStyle: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tamaño (aprox.)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: appState.stickerSize,
                                      items: ['5x5', '8x8', '10x10']
                                          .map((size) => DropdownMenuItem(
                                                value: size,
                                                child: Text('$size cm', style: const TextStyle(color: Colors.white)),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          appState.setStickerSize(value);
                                        }
                                      },
                                      dropdownColor: const Color(0xFF101018),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 15),
                      
                      // Opción de recorte
                      Row(
                        children: [
                          Checkbox(
                            value: appState.cutStickers,
                            onChanged: (value) {
                              appState.setCutStickers(value ?? false);
                            },
                            activeColor: const Color(0xFF26AEFB),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Solicitar QR recortados individualmente (+60% del costo de impresión)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      
                      // Forma del recorte (solo visible si se selecciona la opción de recorte)
                      if (appState.cutStickers) ...[
                        const SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Forma del recorte',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: appState.stickerCutShape,
                                  items: ['circular', 'square', 'rounded_square', 'hexagon']
                                      .map((shape) => DropdownMenuItem(
                                            value: shape,
                                            child: Text(
                                              shape == 'circular'
                                                  ? 'Circular'
                                                  : shape == 'square'
                                                      ? 'Cuadrado'
                                                      : shape == 'rounded_square'
                                                          ? 'Cuadrado con bordes redondeados'
                                                          : 'Hexágono',
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      appState.setStickerCutShape(value);
                                    }
                                  },
                                  dropdownColor: const Color(0xFF101018),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 15),
                      
                      // Costo Total de Impresión
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Costo Total de Impresión: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            appState.formatPrice(appState.calculateCosts()['printingCost'] as double),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF7DF4E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// Widget para Certificación para Gigantografía
class CertificationItem extends StatelessWidget {
  final AppState appState;

  const CertificationItem({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final costs = appState.calculateCosts();
    final largeFormatCost = costs['largeFormat'] as double? ?? 0.0;
    
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: appState.largeFormat,
            onChanged: (value) {
              appState.setLargeFormat(value ?? false);
            },
            activeColor: const Color(0xFF26AEFB),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Certificación para Gigantografía',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Aseguramos la legibilidad del QR en formatos grandes. El costo base se ajusta por la cantidad de versiones a certificar.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '+ ${appState.formatPrice(largeFormatCost)}', // Precio dinámico
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF7DF4E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Por favor ingresa un email válido';
                    }
                    return null;
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
                      value: true, // Asumimos que el usuario acepta las políticas al enviar el formulario
                      onChanged: null, // No permitimos cambiarlo en este diálogo
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
                      onPressed: () {
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
                      },
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

// Sección: Resumen del Pedido
class SummarySection extends StatelessWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final costs = appState.calculateCosts();
        final total = costs['total'] as double? ?? 0.0;
        final renewal = costs['renewal'] as double? ?? 0.0;
        final baseDesign = costs['baseDesign'] as double? ?? 0.0;
        final additionalVersions = costs['additionalVersions'] as double? ?? 0.0;
        final functionality = costs['functionality'] as double? ?? 0.0;
        final addons = costs['addons'] as double? ?? 0.0;
        final printing = costs['printingCost'] as double? ?? 0.0;
        
        // Calcular porcentajes para el gráfico
        final totalCost = baseDesign + additionalVersions + functionality + addons + printing;
        final designPercentage = totalCost > 0 ? (((baseDesign + additionalVersions) / totalCost) * 100).toDouble() : 0.0;
        final functionalityPercentage = totalCost > 0 ? ((functionality / totalCost) * 100).toDouble() : 0.0;
        final addonsPercentage = totalCost > 0 ? ((addons / totalCost) * 100).toDouble() : 0.0;
        final printingPercentage = totalCost > 0 ? ((printing / totalCost) * 100).toDouble() : 0.0;

        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: 'Resumen del Pedido'),
              const SizedBox(height: 20),
              const Text(
                'Total (Pago Único):',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                appState.formatPrice(total),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7DF4E),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Renovación Anual:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                renewal > 0 ? appState.formatPrice(renewal) : 'N/A',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      if (designPercentage > 0)
                        PieChartSectionData(
                          color: const Color(0xFF26AEFB),
                          value: designPercentage,
                          title: 'Diseño',
                          radius: 50,
                        ),
                      if (functionalityPercentage > 0)
                        PieChartSectionData(
                          color: const Color(0xFFA0E9FF),
                          value: functionalityPercentage,
                          title: 'Funcionalidad',
                          radius: 40,
                        ),
                      if (addonsPercentage > 0)
                        PieChartSectionData(
                          color: const Color(0xFFF7DF4E),
                          value: addonsPercentage,
                          title: 'Adicionales',
                          radius: 30,
                        ),
                      if (printingPercentage > 0)
                        PieChartSectionData(
                          color: const Color(0xFFF87171),
                          value: printingPercentage,
                          title: 'Impresión',
                          radius: 20,
                        ),
                    ],
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Acción para abrir el modal de confirmación
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationDialog(appState: appState);
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100), // Hacerlo más redondeado
                    ),
                    elevation: 8, // Añadir sombra
                    shadowColor: primaryBlue.withValues(alpha: 0.3), // Color de la sombra
                  ),
                  child: const Text(
                    'Encargar mi QR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widget para los detalles del servicio de diseño complejo
class DesignComplexDetails extends StatefulWidget {
  const DesignComplexDetails({super.key});

  @override
  State<DesignComplexDetails> createState() => _DesignComplexDetailsState();
}

class _DesignComplexDetailsState extends State<DesignComplexDetails> {
  late TextEditingController _instructionsController;
  String _fileName = 'Ningún archivo seleccionado';
  Uint8List? _fileBytes;

  @override
  void initState() {
    super.initState();
    _instructionsController = TextEditingController();
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

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
    return Consumer<AppState>(
      builder: (context, appState, child) {
        _instructionsController.text = appState.designComplexInstructions;
        
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
                'Instrucciones Detalladas para tu Diseño',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Describe los detalles para tu afiche o folleto.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _instructionsController,
                maxLines: 4,
                onChanged: (value) {
                  appState.setDesignComplexInstructions(value);
                },
                decoration: InputDecoration(
                  hintText: 'Describe los detalles para tu afiche o folleto...',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
                style: const TextStyle(color: Colors.white),
                maxLength: 1200,
              ),
              const SizedBox(height: 5),
              Text(
                '${_instructionsController.text.length}/1200',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Archivo de Referencia (Opcional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Si tienes un diseño de referencia, puedes subirlo para ayudarnos a entender mejor tu visión.',
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
      },
    );
  }
}
