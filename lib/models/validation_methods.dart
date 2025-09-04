// lib/models/validation_methods.dart
import 'app_state.dart'; // Import the AppState class to access its properties

// Extension methods for AppState validation
extension ValidationMethods on AppState {
  // Method to validate if a link entry is complete
  bool isLinkEntryComplete(LinkEntry entry) {
    // If the entry is marked as dynamic URL, it's considered complete
    if (entry.isDynamic) return true;

    // Validate based on the type of destination
    switch (entry.type) {
      case 'url_static':
        // For static URLs, we need a non-empty URL
        final url = entry.values['url'] as String?;
        return url != null && url.trim().isNotEmpty;
      
      case 'vcard':
        // vCard is considered complete when selected
        return true;
      
      case 'wifi':
        // For WiFi connections, we need both SSID and password
        final ssid = entry.values['ssid'] as String?;
        final password = entry.values['password'] as String?;
        return ssid != null && ssid.trim().isNotEmpty && 
               password != null && password.trim().isNotEmpty;
      
      case 'text':
        // For text, we need non-empty text content
        final text = entry.values['text'] as String?;
        return text != null && text.trim().isNotEmpty;
      
      case 'payment':
        // For payments, we need a non-empty payment link or CBU/CVU
        final paymentLink = entry.values['paymentLink'] as String?;
        return paymentLink != null && paymentLink.trim().isNotEmpty;
      
      case 'geo':
        // For geolocation, we need both latitude and longitude
        final latitude = entry.values['latitude'] as String?;
        final longitude = entry.values['longitude'] as String?;
        return latitude != null && latitude.trim().isNotEmpty && 
               longitude != null && longitude.trim().isNotEmpty;
      
      default:
        // For any other type, consider it incomplete
        return false;
    }
  }

  // Method to validate if the design complex instructions are complete
  bool isDesignComplexInstructionsComplete() {
    // If the design service is not 'complex', no validation is needed
    if (designService != 'complex') return true;
    
    // For complex design service, we need non-empty instructions
    return designComplexInstructions.trim().isNotEmpty;
  }

  // Method to validate if the brand info is complete
  bool isBrandInfoComplete() {
    return brandInfo.trim().isNotEmpty;
  }

  // Method to validate if at least one link entry is complete
  bool isAtLeastOneLinkComplete() {
    return linkEntries.any(isLinkEntryComplete);
  }

  // Method to validate the main form
  bool isMainFormValid() {
    return isBrandInfoComplete() && 
           isAtLeastOneLinkComplete() && 
           isDesignComplexInstructionsComplete();
  }

  // Method to validate seller keyword status
  bool isSellerKeywordStatusValid() {
    // If no keyword is entered, it's valid (no discount applied)
    if (sellerKeyword.trim().isEmpty) return true;
    
    // If validation is in progress, it's not yet valid
    // Note: This property doesn't exist in the current AppState implementation
    // We'll assume it's always valid for now
    return isSellerKeywordValid;
  }
}