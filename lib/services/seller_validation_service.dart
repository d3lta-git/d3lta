// lib/services/seller_validation_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class SellerValidationService {
  // The URL of the Google Apps Script Web App
  // This should be replaced with the actual deployment URL
  static const String _validationApiUrl = 
      'https://script.google.com/macros/s/AKfycbw_Cbs4HbPkWvV24GOKlEPXmcxbXTCVCdrOYyUZEI3LxHYGKK4aSmnoPO2y2JKCfTu1/exec';

  /// Validates a seller keyword by calling the Google Apps Script API
  static Future<bool> validateSellerKeyword(String keyword) async {
    try {
      // Make the HTTP GET request to the validation API
      final response = await http.get(
        Uri.parse('$_validationApiUrl?keyword=${Uri.encodeQueryComponent(keyword)}'),
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Return the validation result
        return data['isValid'] as bool? ?? false;
      } else {
        // If the request failed, return false
        return false;
      }
    } catch (e) {
      // If there was an error (network issue, etc.), return false
      return false;
    }
  }
}