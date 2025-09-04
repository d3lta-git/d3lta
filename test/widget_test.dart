// D3LTA App widget tests
//
// These tests verify the basic functionality of the D3LTA app.

import 'package:flutter_test/flutter_test.dart';

import 'package:d3lta/models/app_state.dart';

void main() {
  test('AppState initializes correctly', () {
    // Verify that we can create the app state without errors
    final appState = AppState();
    expect(appState, isNotNull);
    
    // Verify initial state values
    expect(appState.currentCurrency, 'ARS');
    expect(appState.designComplexity, 'standard');
    expect(appState.dynamicUrlTier, 'none');
  });

  test('App can calculate costs', () {
    final appState = AppState();
    
    // Verify that we can calculate costs without errors
    final costs = appState.calculateCosts();
    expect(costs, isNotNull);
    expect(costs['total'], isNotNull);
  });
}
