# D3LTA Flutter Project Development Guide

This guide provides an overview of the D3LTA Flutter project structure, key components, and development practices.

## Project Overview

D3LTA is a Flutter application for a QR code design service. The app allows users to configure and order custom QR codes with various design options, functionality levels, and additional services.

## Project Structure

```
lib/
├── main.dart                 # Entry point of the application
├── models/
│   ├── app_state.dart        # Application state management
│   └── pricing_model.dart    # Pricing calculations and models
├── screens/
│   └── contratacion_screen.dart  # Main contracting/ordering screen
├── widgets/
│   ├── custom_checkbox.dart      # Custom checkbox widget
│   └── custom_radio.dart         # Custom radio button widget
assets/
├── images/
│   ├── fondo.jpg             # Background image
│   ├── isologo.png           # Isotype logo
│   └── logo.png              # Main logo
test/
└── widget_test.dart          # Example widget tests
```

## Key Components

### 1. Main Application (lib/main.dart)

The entry point of the application that sets up:
- MaterialApp with routing
- Provider for state management
- Theme configuration
- Home screen with animated sections

Key features:
- Uses Provider pattern for state management
- Implements a custom dark theme
- Defines routes for navigation
- Contains several animated UI components

### 2. State Management (lib/models/app_state.dart)

The `AppState` class manages all application state using the ChangeNotifier pattern:
- Design complexity selection (basic, standard, premium)
- Dynamic URL functionality tiers
- Design service options
- Color palette management
- Link entries configuration
- Add-on services (express delivery, large format, printing)
- Currency selection (ARS, USD)

### 3. Pricing Model (lib/models/pricing_model.dart)

Handles all pricing calculations:
- Base design complexity prices
- Dynamic URL functionality pricing
- Add-on service costs
- Printing cost calculations
- Currency conversion and formatting

### 4. Contracting Screen (lib/screens/contratacion_screen.dart)

The main screen where users configure their QR code order:
- Multi-step form with 5 steps:
  1. Base service level (design and functionality)
  2. Creative information (branding, colors, fonts)
  3. Destination configuration
  4. Additional services
  5. Printing services
- Real-time price calculation
- Summary section with cost breakdown
- Order confirmation dialog

### 5. Custom Widgets (lib/widgets/)

Custom UI components for consistent styling:
- `CustomCheckbox`: Styled checkbox component
- `CustomRadio`: Styled radio button component

## Development Practices

### State Management

The project uses the Provider package for state management:
- `AppState` is provided at the root level
- Widgets consume state using `Consumer` widgets
- State changes trigger UI updates through `notifyListeners()`

### UI/UX Patterns

1. **Animated Components**:
   - Fade-in animations for content sections
   - Typewriter effect for subtitles
   - Shiny button effects
   - Bouncing arrows

2. **Responsive Design**:
   - Different layouts for mobile and desktop
   - Dynamic grid columns based on screen size
   - Flexible form layouts

3. **Form Handling**:
   - Custom form fields for different data types
   - Real-time validation
   - Interactive form elements

### Asset Management

Assets are organized in the `assets/images/` directory:
- Background images
- Logos and branding elements
- All assets are referenced in `pubspec.yaml`

### Dependencies

Key dependencies used in the project:
- `provider`: State management
- `fl_chart`: Data visualization for cost breakdown
- `intl`: Internationalization and number formatting
- `file_picker`: File selection functionality
- `url_launcher`: External URL opening

## Key Features Implementation

### 1. Multi-step Form

The contracting screen implements a multi-step form with:
- Step-by-step user guidance
- Conditional rendering based on selections
- Real-time price updates

### 2. Dynamic Pricing

Pricing is calculated in real-time based on:
- Selected design complexity
- Number of link versions
- Add-on services
- Printing requirements
- Currency selection

### 3. Custom Form Elements

The project includes several custom form elements:
- Radio buttons with pricing information
- Checkboxes with descriptive text
- Color pickers
- File upload components
- Custom dropdowns

### 4. Data Visualization

Cost breakdown is visualized using:
- Pie charts showing cost distribution
- Formatted currency display
- Real-time updates as options change

## Testing

The project includes basic widget tests in `test/widget_test.dart`. For new features, follow these testing practices:
- Write unit tests for business logic in models
- Create widget tests for complex UI components
- Use golden tests for UI regression testing

## Code Quality

The project follows Flutter best practices:
- Uses `flutter_lints` for code analysis
- Implements proper error handling
- Follows naming conventions
- Maintains consistent code formatting

## Getting Started with Development

1. Review the existing code structure
2. Understand the state management pattern
3. Run existing tests to ensure they pass
4. Add new features by following established patterns
5. Update documentation as needed

## Common Tasks

### Adding a New Form Field

1. Update the `AppState` model with new properties
2. Add UI elements in the appropriate section of `contratacion_screen.dart`
3. Implement state update methods in `AppState`
4. Add pricing logic if applicable in `PricingModel`

### Adding a New Pricing Component

1. Define pricing data in `PricingModel`
2. Create calculation methods in `PricingModel`
3. Add UI elements to display the cost
4. Update the summary section to include the new cost

### Adding a New Route

1. Define the route in `main.dart` routes map
2. Create the new screen widget
3. Implement navigation using `Navigator.pushNamed`

## Troubleshooting

Common issues and solutions:
- If UI doesn't update with state changes, ensure `notifyListeners()` is called
- For pricing calculation errors, verify the calculation logic in `PricingModel`
- For form validation issues, check the form field configurations