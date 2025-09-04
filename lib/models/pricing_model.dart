// lib/models/pricing_model.dart
import 'package:intl/intl.dart';

class PricingModel {
  // Precios base en CHF
  static const Map<String, double> designComplexityPrices = {
    'basic': 40.0,
    'standard': 62.0,
    'premium': 110.0,
  };

  // Precios de funcionalidad dinámica en CHF
  static const Map<String, Map<String, dynamic>> dynamicUrlPrices = {
    'none': {},
    'starter': {'price': 35.0, 'renewal': 15.0, 'limit': 3},
    'business': {'price': 95.0, 'renewal': 45.0, 'limit': 12},
    'scale': {'price': 225.0, 'renewal': 95.0, 'limit': 30},
  };

  // Precios de servicios adicionales en CHF
  static const Map<String, dynamic> addonPrices = {
    'express_delivery': {
      'base': {
        'basic': {'none': 30.0, 'starter': 40.0, 'business': 50.0, 'scale': 50.0},
        'standard': {'none': 45.0, 'starter': 55.0, 'business': 65.0, 'scale': 65.0},
        'premium': {'none': 60.0, 'starter': 70.0, 'business': 80.0, 'scale': 80.0},
      },
      'per_version': {'min': 2.5, 'max': 4.0, 'count_max': 30},
    },
    'large_format': {'base': 15.0, 'per_version': 5.0},
    'printing': {
      '5x5': {'total_at_1': 4.5, 'total_at_1000': 300.0},
      '8x8': {'total_at_1': 7.0, 'total_at_1000': 450.0},
      '10x10': {'total_at_1': 9.0, 'total_at_1000': 600.0},
      'cut_multiplier': 1.6,
    },
  };

  // Precios de servicios de diseño en CHF
  static const Map<String, double> designServicePrices = {
    'integration': 13.0,
    'complex': 98.0,
  };

  // Precios para versiones adicionales en CHF
  static const List<Map<String, dynamic>> additionalVersionsPrices = [
    {'max': 5, 'price': 4.5},
    {'max': 15, 'price': 3.5},
    {'max': 30, 'price': 2.5},
  ];

  // Tasa de descuento para vendedores
  static const double sellerDiscountPercentage = 0.10; // 10%

  // Tipos de cambio (valores de ejemplo, en una implementación real se obtendrían de una API)
  static const Map<String, double> exchangeRates = {
    'ARS': 1250.0,
    'USD': 1.1,
    'CHF': 1.0,
  };

  // Calcular el costo de versiones adicionales
  static double getAdditionalVersionsCost(int count) {
    if (count <= 1) return 0.0;
    double cost = 0.0;
    int remaining = count - 1;
    int lastMax = 0;

    for (var tier in additionalVersionsPrices) {
      int inThisTier = (remaining < (tier['max'] as int) - lastMax) ? remaining : (tier['max'] as int) - lastMax;
      if (inThisTier > 0) {
        cost += inThisTier * (tier['price'] as double);
        remaining -= inThisTier;
        lastMax = tier['max'] as int;
      }
      if (remaining <= 0) break;
    }

    // Si quedan versiones adicionales fuera de los tiers definidos, se cobran al precio del último tier
    if (remaining > 0) {
      cost += remaining * (additionalVersionsPrices.last['price'] as double);
    }

    return cost;
  }

  // Calcular el precio por unidad de impresión de stickers
  static double getStickerPricePerUnit(int quantity, String size) {
    final config = addonPrices['printing'] as Map<String, dynamic>;
    final sizeConfig = config[size] as Map<String, dynamic>?;
    if (sizeConfig == null || quantity <= 0) return 0.0;

    final totalAt1 = sizeConfig['total_at_1'] as double;
    final totalAt1000 = sizeConfig['total_at_1000'] as double;

    if (quantity <= 1) return totalAt1;
    if (quantity >= 1000) return totalAt1000 / 1000;

    final totalCost =
        totalAt1 + ((totalAt1000 - totalAt1) / (999)) * (quantity - 1);
    return totalCost / quantity;
  }

  // Calcular el costo total de impresión
  static double getPrintingCost(
      int numVersions, int quantityPerVersion, String size, bool cutStickers) {
    if (quantityPerVersion <= 0 || numVersions <= 0) return 0.0;

    final pricePerUnit = getStickerPricePerUnit(quantityPerVersion, size);
    double totalPrintingCost =
        pricePerUnit * quantityPerVersion * numVersions;

    if (cutStickers) {
      final cutMultiplier =
          (addonPrices['printing'] as Map<String, dynamic>)['cut_multiplier'] as double;
      totalPrintingCost *= cutMultiplier;
    }

    return totalPrintingCost;
  }

  // Calcular el costo de entrega express
  static double getExpressDeliveryCost(String designTier, String urlTier,
      int versionCount) {
    if (versionCount <= 0) return 0.0;

    final expressDeliveryConfig =
        addonPrices['express_delivery'] as Map<String, dynamic>;
    final baseConfig =
        expressDeliveryConfig['base'] as Map<String, dynamic>;
    final perVersionConfig =
        expressDeliveryConfig['per_version'] as Map<String, dynamic>;

    if (!baseConfig.containsKey(designTier)) return 0.0;

    String urlTierKey = 'none';
    if (urlTier != 'none' &&
        (baseConfig[designTier] as Map<String, dynamic>).containsKey(urlTier)) {
      urlTierKey = urlTier;
    }

    final baseCost =
        (baseConfig[designTier] as Map<String, dynamic>)[urlTierKey] as double;
    final min = perVersionConfig['min'] as double;
    final max = perVersionConfig['max'] as double;
    final countMax = perVersionConfig['count_max'] as int;

    double perVersionCost = 0.0;
    if (versionCount > 0) {
      if (versionCount == 1) {
        perVersionCost = max;
      } else if (versionCount >= countMax) {
        perVersionCost = min;
      } else {
        final scale = (versionCount - 1) / (countMax - 1);
        perVersionCost = max - scale * (max - min);
      }
    }

    return baseCost + (perVersionCost * versionCount);
  }

  // Calcular el costo de certificación para gigantografía
  static double getLargeFormatCost(int versionCount) {
    if (versionCount <= 0) return 0.0;

    final largeFormatConfig =
        addonPrices['large_format'] as Map<String, dynamic>;
    final base = largeFormatConfig['base'] as double;
    final perVersion = largeFormatConfig['per_version'] as double;

    return base + (perVersion * versionCount);
  }

  // Convertir un valor de CHF a la moneda especificada
  static double convert(double valueInChf, String currency) {
    return valueInChf * (exchangeRates[currency] ?? 1.0);
  }

  // Formatear una cantidad monetaria
  static String formatCurrency(double value, String currency) {
    final formatter = currency == 'ARS'
        ? NumberFormat.currency(
            locale: 'es_AR', symbol: '\$', decimalDigits: 0)
        : NumberFormat.currency(
            locale: 'es_AR', symbol: '\$', decimalDigits: 2);
    
    // Para ARS, redondear a los miles más cercanos
    if (currency == 'ARS') {
      value = (value / 1000).round() * 1000;
    }
    
    return formatter.format(value);
  }
}
