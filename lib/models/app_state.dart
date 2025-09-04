// lib/models/app_state.dart
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'pricing_model.dart';
import '../services/seller_validation_service.dart';

class AppState extends ChangeNotifier {
  // Variables de estado
  String _currentCurrency = 'ARS';
  String _designComplexity = 'standard';
  String _dynamicUrlTier = 'none';
  String _designService = 'none';
  String _brandInfo = '';
  List<String> _selectedFonts = ['VT323'];
  List<Color> _manualColors = [
    const Color(0xFF26AEFB),
    const Color(0xFFA0E9FF),
    const Color(0xFFFFFFFF),
    const Color(0xFFF7DF4E),
    const Color(0xFF0A0A0F),
  ];

  String _colorMode = 'picker';
  String _sellerKeyword = '';
  bool _isSellerKeywordValid = false;
  List<LinkEntry> _linkEntries = [LinkEntry()];
  bool _expressDelivery = false;
  bool _largeFormat = false;
  bool _printStickers = false;
  int _stickerQuantity = 50;
  String _stickerSize = '8x8';
  bool _cutStickers = false;
  String _stickerCutShape = 'circular';
  
  // Extended design service properties
  String _designComplexInstructions = '';
  Uint8List? _designIntegrationFileBytes;
  String _designIntegrationFileName = '';

  // Getters
  String get currentCurrency => _currentCurrency;
  String get designComplexity => _designComplexity;
  String get dynamicUrlTier => _dynamicUrlTier;
  String get designService => _designService;
  String get brandInfo => _brandInfo;
  List<String> get selectedFonts => _selectedFonts;
  List<Color> get manualColors => _manualColors;
  String get colorMode => _colorMode;
  String get sellerKeyword => _sellerKeyword;
  bool get isSellerKeywordValid => _isSellerKeywordValid;
  List<LinkEntry> get linkEntries => _linkEntries;
  bool get expressDelivery => _expressDelivery;
  bool get largeFormat => _largeFormat;
  bool get printStickers => _printStickers;
  int get stickerQuantity => _stickerQuantity;
  String get stickerSize => _stickerSize;
  bool get cutStickers => _cutStickers;
  String get stickerCutShape => _stickerCutShape;
  
  // Extended design service getters
  String get designComplexInstructions => _designComplexInstructions;
  Uint8List? get designIntegrationFileBytes => _designIntegrationFileBytes;
  String get designIntegrationFileName => _designIntegrationFileName;
  
  // Pricing model getters
  Map<String, Map<String, dynamic>> get dynamicUrlPrices => PricingModel.dynamicUrlPrices;
  Map<String, double> get designComplexityPrices => PricingModel.designComplexityPrices;
  
  // Helper getter for color count based on design complexity
  int get colorCount {
    switch (_designComplexity) {
      case 'basic':
        return 3;
      case 'standard':
        return 5;
      case 'premium':
        return 7;
      default:
        return 5;
    }
  }

  // Setters con notificación de cambio
  void setCurrentCurrency(String currency) {
    _currentCurrency = currency;
    notifyListeners();
    _updatePrices();
  }

  void setDesignComplexity(String complexity) {
    _designComplexity = complexity;
    
    // Adjust the number of colors based on the design complexity
    final requiredColorCount = colorCount;
    if (_manualColors.length != requiredColorCount) {
      final defaultColors = [
        const Color(0xFF26AEFB),
        const Color(0xFFA0E9FF),
        const Color(0xFFFFFFFF),
        const Color(0xFFF7DF4E),
        const Color(0xFF0A0A0F),
        const Color(0xFFf87171),
        const Color(0xFFa78bfa),
      ];
      
      if (_manualColors.length < requiredColorCount) {
        // Add more colors
        while (_manualColors.length < requiredColorCount) {
          _manualColors.add(defaultColors[_manualColors.length % defaultColors.length]);
        }
      } else if (_manualColors.length > requiredColorCount) {
        // Remove excess colors
        _manualColors = _manualColors.sublist(0, requiredColorCount);
      }
    }
    
    notifyListeners();
    _updatePrices();
  }

  void setDynamicUrlTier(String tier) {
    _dynamicUrlTier = tier;
    notifyListeners();
    _updatePrices();
  }

  void setDesignService(String service) {
    _designService = service;
    notifyListeners();
    _updatePrices();
  }

  void setBrandInfo(String info) {
    _brandInfo = info;
    notifyListeners();
  }

  void setSelectedFonts(List<String> fonts) {
    _selectedFonts = fonts;
    notifyListeners();
  }

  void setManualColors(List<Color> colors) {
    _manualColors = colors;
    notifyListeners();
  }

  void setColorMode(String mode) {
    _colorMode = mode;
    notifyListeners();
  }

  void setSellerKeyword(String keyword) {
    _sellerKeyword = keyword;
    notifyListeners();
  }

  void setIsSellerKeywordValid(bool isValid) {
    _isSellerKeywordValid = isValid;
    notifyListeners();
    _updatePrices();
  }

  // Method to validate seller keyword
  Future<bool> validateSellerKeyword(String keyword) async {
    // If the keyword is empty, it's not valid
    if (keyword.trim().isEmpty) {
      return false;
    }
    
    // Call the seller validation service
    final isValid = await SellerValidationService.validateSellerKeyword(keyword);
    return isValid;
  }

  void setLinkEntries(List<LinkEntry> entries) {
    _linkEntries = entries;
    notifyListeners();
    _updatePrices();
  }

  void setExpressDelivery(bool express) {
    _expressDelivery = express;
    notifyListeners();
    _updatePrices();
  }

  void setLargeFormat(bool large) {
    _largeFormat = large;
    notifyListeners();
    _updatePrices();
  }

  void setPrintStickers(bool print) {
    _printStickers = print;
    notifyListeners();
    _updatePrices();
  }

  void setStickerQuantity(int quantity) {
    // Clamp the quantity to the valid range
    _stickerQuantity = quantity.clamp(1, 1000);
    notifyListeners();
    _updatePrices();
  }

  void setStickerSize(String size) {
    _stickerSize = size;
    notifyListeners();
    _updatePrices();
  }

  void setCutStickers(bool cut) {
    _cutStickers = cut;
    notifyListeners();
    _updatePrices();
  }

  void setStickerCutShape(String shape) {
    _stickerCutShape = shape;
    notifyListeners();
  }
  
  // Extended design service setters
  void setDesignComplexInstructions(String instructions) {
    _designComplexInstructions = instructions;
    notifyListeners();
  }
  
  void setDesignIntegrationFile(Uint8List? fileBytes, String fileName) {
    _designIntegrationFileBytes = fileBytes;
    _designIntegrationFileName = fileName;
    notifyListeners();
  }

  // Métodos para actualizar precios
  void _updatePrices() {
    // Notificar a los listeners que los precios han cambiado
    notifyListeners();
  }

  // Calcular costos
  Map<String, dynamic> calculateCosts() {
    final costs = {
      'creativeFee': 0.0,
      'functionalityFee': 0.0,
      'addonsFee': 0.0,
      'printingCost': 0.0,
      'renewalFee': 0.0,
      'total': 0.0,
    };

    // Calcular tarifa creativa
    final baseDesignCost =
        PricingModel.designComplexityPrices[_designComplexity] ?? 0.0;
    final completeLinkCount = _linkEntries
        .where((entry) =>
            entry.isDynamic ||
            (entry.type == 'url_static' && entry.values['url'] != null && entry.values['url'].toString().isNotEmpty) ||
            (entry.type == 'vcard') ||
            (entry.type == 'wifi' && entry.values['ssid'] != null && entry.values['ssid'].toString().isNotEmpty && entry.values['password'] != null && entry.values['password'].toString().isNotEmpty) ||
            (entry.type == 'text' && entry.values['text'] != null && entry.values['text'].toString().isNotEmpty) ||
            (entry.type == 'payment' && entry.values['paymentLink'] != null && entry.values['paymentLink'].toString().isNotEmpty) ||
            (entry.type == 'geo' && entry.values['latitude'] != null && entry.values['latitude'].toString().isNotEmpty && entry.values['longitude'] != null && entry.values['longitude'].toString().isNotEmpty))
        .length;
    final additionalVersionsCost =
        PricingModel.getAdditionalVersionsCost(completeLinkCount);
    costs['creativeFee'] = baseDesignCost + additionalVersionsCost;

    // Calcular tarifa de funcionalidad
    final dynamicUrlConfig =
        PricingModel.dynamicUrlPrices[_dynamicUrlTier] ?? {};
    costs['functionalityFee'] = (dynamicUrlConfig['price'] as double?) ?? 0.0;
    costs['renewalFee'] = (dynamicUrlConfig['renewal'] as double?) ?? 0.0;

    // Calcular tarifas de adicionales
    if (_expressDelivery) {
      costs['addonsFee'] = (costs['addonsFee'] as double) + PricingModel.getExpressDeliveryCost(
          _designComplexity, _dynamicUrlTier, _linkEntries.length);
    }

    if (_largeFormat) {
      costs['addonsFee'] = (costs['addonsFee'] as double) +
          PricingModel.getLargeFormatCost(_linkEntries.length);
    }

    if (_designService != 'none') {
      costs['addonsFee'] = (costs['addonsFee'] as double) +
          (PricingModel.designServicePrices[_designService] ?? 0.0);
    }

    // Calcular costo de impresión
    if (_printStickers) {
      costs['printingCost'] = PricingModel.getPrintingCost(
          _linkEntries.length, _stickerQuantity, _stickerSize, _cutStickers);
    }

    // Calcular total
    double totalCHF = (costs['creativeFee'] as double) +
        (costs['functionalityFee'] as double) +
        (costs['addonsFee'] as double) +
        (costs['printingCost'] as double);

    // Aplicar descuento de vendedor si es válido
    if (_isSellerKeywordValid) {
      totalCHF *= (1 - PricingModel.sellerDiscountPercentage);
    }

    costs['total'] = totalCHF;

    return costs;
  }

  // Formatear precio
  String formatPrice(double price) {
    return PricingModel.formatCurrency(
        PricingModel.convert(price, _currentCurrency), _currentCurrency);
  }
}

// Modelo para representar una entrada de destino
class LinkEntry {
  String title;
  String type;
  Map<String, dynamic> values;
  String notes;
  bool hasExtraText;
  String extraText;
  bool isDynamic;

  LinkEntry({
    this.title = '',
    this.type = 'url_static',
    this.values = const {},
    this.notes = '',
    this.hasExtraText = false,
    this.extraText = '',
    this.isDynamic = false,
  });
}