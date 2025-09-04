# D3LTA - Diseño de Códigos QR Artísticos

Una aplicación Flutter multiplataforma para el diseño y pedido de códigos QR artísticos personalizados.

## Descripción

D3LTA es una aplicación de Flutter que permite a los usuarios configurar y ordenar servicios personalizados de diseño de códigos QR. La aplicación ofrece:

- Proceso de pedido en múltiples pasos para servicios de diseño de códigos QR
- Selección de complejidad de diseño (básico, estándar, premium)
- Niveles de funcionalidad de URL dinámica
- Servicios de diseño extendidos
- Configuración de información creativa (marca, colores, fuentes)
- Configuración de destinos con múltiples tipos (URL, vCard, Wi-Fi, etc.)
- Servicios adicionales (entrega exprés, certificación para gigantografía)
- Servicios de impresión para stickers
- Cálculos de precios en tiempo real
- Resumen del pedido con visualización del desglose de costos
- Flujo de confirmación del pedido

## Características Técnicas

- Desarrollado con Flutter para web y móviles (iOS/Android)
- Uso de Provider para la gestión del estado
- Diseño responsivo para diferentes tamaños de pantalla
- Componentes UI personalizados para un estilo consistente

## Empezando

### Prerrequisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Editor de código (Visual Studio Code recomendado)

### Instalación

1. Clonar el repositorio:
   ```bash
   git clone <repository-url>
   ```

2. Navegar al directorio del proyecto:
   ```bash
   cd d3lta
   ```

3. Obtener las dependencias:
   ```bash
   flutter pub get
   ```

### Ejecutar la aplicación

Para ejecutar en un dispositivo/emulador:
```bash
flutter run
```

Para ejecutar en la web:
```bash
flutter run -d chrome
```

### Construir para la web

```bash
flutter build web
```

## Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/
│   ├── app_state.dart        # Gestión del estado de la aplicación usando Provider
│   └── pricing_model.dart    # Cálculos de precios y modelos
├── screens/
│   └── contratacion_screen.dart  # Pantalla principal de contratación/pedido
├── widgets/
│   ├── custom_checkbox.dart      # Componente de checkbox personalizado
│   └── custom_radio.dart         # Componente de radio button personalizado
assets/
├── images/
│   ├── fondo.jpg             # Imagen de fondo
│   ├── isologo.png           # Logo isotipo
│   └── logo.png              # Logo principal
```

## Despliegue

La aplicación está configurada para desplegarse en GitHub Pages usando GitHub Actions.

## Contribuir

1. Fork el proyecto
2. Crea tu rama de características (`git checkout -b feature/AmazingFeature`)
3. Haz commit de tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Haz push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto es privado y propiedad de D3LTA.

## Contacto

Delta del Paraná, Argentina