// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Importar la nueva pantalla
import 'screens/contratacion_screen.dart';
import 'models/app_state.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // Definir nombres constantes para las rutas
  static const String homeRoute = '/';
  static const String contratacionRoute = '/contratacion';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'D3LTA - Diseño de Códigos QR Artísticos',
      theme: ThemeData(
        useMaterial3: true,
        // Puedes definir colores y fuentes personalizadas aquí si lo deseas
        // Asegurarse de que el tema tenga un color de fondo oscuro para que
        // el texto blanco sea visible en toda la app
        scaffoldBackgroundColor: Colors.black,
      ),
      // Definir las rutas de la aplicación
      routes: {
        homeRoute: (context) => const MyHomePage(),
        contratacionRoute: (context) => const ContratacionScreen(), // Asegúrate de que ContratacionScreen tenga un constructor const
      },
      // Definir la ruta inicial
      initialRoute: homeRoute,
      debugShowCheckedModeBanner: false, // Oculta el banner de debug
      navigatorKey: navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeContent(),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo de imagen
        Positioned.fill(
          child: Image.asset(
            'assets/images/fondo.jpg',
            fit: BoxFit.cover,
          ),
        ),
        // Capa de color oscuro (simula el backdrop-filter)
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.9),
          ),
        ),
        // Contenido principal con desplazamiento si es necesario
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Solo ocupa el espacio necesario
                children: [
                  const FadeInUpWidget(delay: Duration(milliseconds: 100), child: MainSection()),
                  const SizedBox(height: 16),
                  const FadeInUpWidget(delay: Duration(milliseconds: 900), child: PortfolioIndicator()),
                  const SizedBox(height: 16),
                  // PortfolioSection ya no necesita Expanded, ya que su contenido puede desplazarse
                  const FadeInUpWidget(delay: Duration(milliseconds: 1100), child: PortfolioSection()),
                  const SizedBox(height: 16),
                  const FadeInUpWidget(delay: Duration(milliseconds: 1300), child: FooterSection()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Sección Principal: Logo, Título, Subtítulo, Botón CTA ---
class MainSection extends StatelessWidget {
  const MainSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Solo ocupa el espacio necesario
      children: [
        // Logo Isotipo
        Image.asset(
          'assets/images/isologo.png',
          height: 150, // Ajusta según necesites
          width: 150,
        ),
        const SizedBox(height: 16),
        // Título principal
        const Text(
          'Diseño gráfico de\nCódigos QR Artísticos', // \n en lugar de salto de línea real
          textAlign: TextAlign.center,
          style: TextStyle(
            // fontFamily: 'BarlowCondensed', // Se añadirá cuando se configuren las fuentes
            fontSize: 28, // Ajustado para móviles
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 4.2, // 0.15em * 28px
            height: 1.1,
            shadows: [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 15,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Subtítulo con animación de máquina de escribir
        const TypewriterSubtitleWidget(),
        const SizedBox(height: 16),
        // Botón de prueba estándar para diagnóstico
        ElevatedButton(
          onPressed: () {
            // print("Botón 'Encargar mi QR' ESTÁNDAR presionado - Intentando navegar..."); // COMENTADO: avoid_print
            Navigator.pushNamed(context, MyApp.contratacionRoute);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF7DF4E),
          ),
          child: const Text(
            'Encargar mi QR (Prueba)',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

// --- Widget para Animación Fade In Up ---
class FadeInUpWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const FadeInUpWidget({super.key, required this.child, required this.delay});
  @override
  State<FadeInUpWidget> createState() => _FadeInUpWidgetState();
}

class _FadeInUpWidgetState extends State<FadeInUpWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // CORREGIDO: child debe ser el último parámetro en AnimatedBuilder
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: child, // Usar child aquí es más eficiente
          ),
        );
      },
      child: widget.child, // 'child' está correctamente al final aquí
    );
  }
}

// --- Widget para el Subtítulo con Animación de Máquina de Escribir ---
class TypewriterSubtitleWidget extends StatefulWidget {
  const TypewriterSubtitleWidget({super.key});
  @override
  State<TypewriterSubtitleWidget> createState() => _TypewriterSubtitleWidgetState();
}

class _TypewriterSubtitleWidgetState extends State<TypewriterSubtitleWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _textIndex;
  final String _fullText =
      'Transformamos ideas en Códigos QR Artísticos que capturan la esencia de tu marca, conectando el mundo físico con el digital de una forma increíble.';
  String _displayText = '';
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: _fullText.length * 30), // Ajusta la velocidad
      vsync: this,
    );
    _textIndex = StepTween(begin: 0, end: _fullText.length).animate(_controller)
      ..addListener(() {
        setState(() {
          _displayText = _fullText.substring(0, _textIndex.value);
        });
      });
    _controller.forward();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Text(
      '$_displayText|', // El cursor parpadeante se implementa con un TextPainter personalizado o un widget separado
      textAlign: TextAlign.center,
      style: const TextStyle(
        // fontFamily: 'Poppins', // Se añadirá cuando se configuren las fuentes
        fontSize: 14, // Ajustado para móviles
        color: Colors.white,
        letterSpacing: 1.4, // 0.1em * 14px
      ),
    );
  }
}

// --- Widget para el Botón con Efecto de Brillo ---
class ShinyButton extends StatefulWidget {
  final VoidCallback onPressed; // Recibir la función de callback
  const ShinyButton({super.key, required this.onPressed});
  @override
  State<ShinyButton> createState() => _ShinyButtonState();
}

class _ShinyButtonState extends State<ShinyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Repetir infinitamente para el efecto de brillo
    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            // Botón base
            ElevatedButton.icon(
              onPressed: widget.onPressed, // Usar el callback proporcionado
              icon: const Icon(
                Icons.auto_awesome,
                color: Colors.black,
              ),
              label: const Text(
                'Encargar mi QR',
                style: TextStyle(
                  // fontFamily: 'Poppins', // Se añadirá cuando se configuren las fuentes
                  fontSize: 18, // Ajustado para móviles
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0.9, // 0.05em * 18px
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7DF4E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14), // Ajustado
                elevation: 8.0,
                shadowColor: const Color(0xFFC5AB3A),
              ),
            ),
            // Capa de brillo animada
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(_animation.value - 0.5, -1),
                          end: Alignment(_animation.value + 0.5, 1),
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// --- Indicador de Portafolio ---
class PortfolioIndicator extends StatelessWidget {
  const PortfolioIndicator({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'PORTAFOLIO DE EJEMPLOS',
          style: TextStyle(
            // fontFamily: 'BarlowCondensed', // Se añadirá cuando se configuren las fuentes
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        BouncingArrow(),
      ],
    );
  }
}

// --- Flecha que Rebota ---
class BouncingArrow extends StatefulWidget {
  const BouncingArrow({super.key});
  @override
  State<BouncingArrow> createState() => _BouncingArrowState();
}

class _BouncingArrowState extends State<BouncingArrow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);
    _animation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeInOut)),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: const Icon(
            Icons.arrow_downward,
            color: Colors.white,
            size: 24,
          ),
        );
      },
    );
  }
}

// --- Sección del Portafolio ---
class PortfolioSection extends StatefulWidget {
  const PortfolioSection({super.key});
  @override
  State<PortfolioSection> createState() => _PortfolioSectionState();
}

class _PortfolioSectionState extends State<PortfolioSection> {
  String _selectedFilter = 'all';
  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PortfolioFilters(selectedFilter: _selectedFilter, onFilterSelected: _onFilterSelected),
        const SizedBox(height: 20),
        PortfolioGrid(selectedFilter: _selectedFilter), // <-- GridView.builder maneja su propio desplazamiento
      ],
    );
  }
}

// --- Filtros del Portafolio ---
class PortfolioFilters extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;
  const PortfolioFilters({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        FilterButton(
          label: 'Todos',
          isSelected: selectedFilter == 'all',
          onTap: () => onFilterSelected('all'),
        ),
        FilterButton(
          label: 'Municipios',
          isSelected: selectedFilter == 'municipios',
          onTap: () => onFilterSelected('municipios'),
        ),
        FilterButton(
          label: 'Artistas',
          isSelected: selectedFilter == 'artistas',
          onTap: () => onFilterSelected('artistas'),
        ),
      ],
    );
  }
}

// --- Botón de Filtro ---
class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const FilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? const Color(0xFF26AEFB)
            : Colors.white.withValues(alpha: 0.05),
        foregroundColor: isSelected ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: const BorderSide(color: Colors.transparent, width: 2.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Ajustado
        elevation: isSelected ? 4.0 : 0.0,
        shadowColor: isSelected ? const Color(0xFF26AEFB).withValues(alpha: 0.3) : null,
      ),
      child: Text(
        label,
        style: const TextStyle(
          // fontFamily: 'Poppins', // Se añadirá cuando se configuren las fuentes
          fontSize: 12, // Ajustado
          fontWeight: FontWeight.normal, // Se ajusta con isSelected
        ),
      ),
    );
  }
}

// --- Cuadrícula del Portafolio ---
class PortfolioGrid extends StatelessWidget {
  final String selectedFilter;
  const PortfolioGrid({super.key, required this.selectedFilter});
  @override
  Widget build(BuildContext context) {
    // Datos simulados (mismos que antes)
    final List<Map<String, dynamic>> allPortfolioItems = [
      {'id': 1, 'category': ['static', 'municipios'], 'imageUrl': 'https://i.ibb.co/fGTqmTLW/Mapainteractivo.png'},
      {'id': 2, 'category': ['static', 'municipios'], 'imageUrl': 'https://i.ibb.co/n8brSjx1/Cartelera-cultural.png'},
      {'id': 3, 'category': ['static', 'artistas'], 'imageUrl': 'https://i.ibb.co/xqrX2Pg9/VIC3N1.png'},
      {'id': 4, 'category': ['static', 'municipios'], 'imageUrl': 'https://i.ibb.co/JwvRn6xV/Guiaderesiduos.png'},
      {'id': 5, 'category': ['static', 'municipios'], 'imageUrl': 'https://i.ibb.co/p6SkzWB7/Centrosdesalud.png'},
      {'id': 6, 'category': ['static', 'artistas'], 'imageUrl': 'https://i.ibb.co/LhPqyD6t/VIC3N4.png'},
      {'id': 7, 'category': ['static', 'municipios'], 'imageUrl': 'https://i.ibb.co/N2C1BGHn/Transportepublico.png'},
      {'id': 8, 'category': ['static', 'municipios'], 'imageUrl': 'https://i.ibb.co/ns6f5XKy/Sugerenciasyreclamos.png'},
      {'id': 9, 'category': ['static', 'artistas'], 'imageUrl': 'https://i.ibb.co/LXWSjW8y/VIC3N2.png'},
      {'id': 10, 'category': ['static', 'municipios'], 'imageUrl': 'https://i.ibb.co/S4KB8cr1/Portal-de-pagos.png'},
      {'id': 11, 'category': ['static', 'municipios'], 'imageUrl': 'https://i.ibb.co/7NSwspt6/Guiadetramites.png'},
      {'id': 12, 'category': ['static', 'artistas'], 'imageUrl': 'https://i.ibb.co/wh7M9FTH/VIC3N3.png'},
    ];
    // Filtrar elementos según el filtro seleccionado
    List<Map<String, dynamic>> filteredItems;
    if (selectedFilter == 'all') {
      filteredItems = allPortfolioItems;
    } else {
      filteredItems = allPortfolioItems
          .where((item) => item['category'].contains(selectedFilter))
          .toList();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar el número de columnas basado en el ancho disponible
        int crossAxisCount = 2; // Por defecto 2 columnas
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4; // 4 columnas en pantallas grandes
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 3; // 3 columnas en pantallas medianas
        }
        // En pantallas pequeñas (<= 800), se mantienen 2 columnas
        return SizedBox(
          height: 400, // Altura fija para el GridView
          child: GridView.builder(
            // physics también se puede eliminar porque el SizedBox maneja el tamaño
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, // Número de columnas dinámico
              crossAxisSpacing: 12, // Ajustado
              mainAxisSpacing: 12, // Ajustado
              childAspectRatio: 1.0, // aspect-square
            ),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return PortfolioCard(item: filteredItems[index]);
            },
          ),
        );
      },
    );
  }
}

// --- Tarjeta del Portafolio ---
class PortfolioCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const PortfolioCard({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent, width: 2.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          item['imageUrl'],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.black.withValues(alpha: 0.2),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.black.withValues(alpha: 0.2),
              child: const Icon(Icons.error, color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}

// --- Pie de Página ---
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Solo ocupa el espacio necesario
      children: const [
        Divider(
          color: Color(0xFF6B7280),
          thickness: 1,
          indent: 30,
          endIndent: 30,
        ),
        SizedBox(height: 20),
        Image(
          image: AssetImage('assets/images/logo.png'),
          height: 80, // Ajustado
        ),
        SizedBox(height: 12),
        Text(
          '◃ D3LTA ▵ 2025 ▹',
          style: TextStyle(
            // fontFamily: 'Poppins', // Se añadirá cuando se configuren las fuentes
            fontSize: 12, // Ajustado
            color: Color(0xFF9CA3AF),
          ),
        ),
        Text(
          'Delta del Paraná, Argentina',
          style: TextStyle(
            // fontFamily: 'Poppins', // Se añadirá cuando se configuren las fuentes
            fontSize: 12, // Ajustado
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}
