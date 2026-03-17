import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para persistir la configuración del tema usando SharedPreferences
class ThemePreferences {
  static const String _themeModeKey = 'theme_mode';

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  /// Indica si SharedPreferences está inicializado
  bool get isInitialized => _isInitialized;

  /// Inicializa SharedPreferences - debe llamarse antes de usar otros métodos
  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  /// Obtiene el ThemeMode guardado, por defecto retorna ThemeMode.dark
  ThemeMode getThemeMode() {
    if (!_isInitialized || _prefs == null) {
      return ThemeMode.dark; // Valor por defecto si no está inicializado
    }

    final String? savedMode = _prefs!.getString(_themeModeKey);

    switch (savedMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        // Por defecto modo oscuro si no hay preferencias guardadas
        return ThemeMode.dark;
    }
  }

  /// Guarda el ThemeMode seleccionado
  Future<void> setThemeMode(ThemeMode mode) async {
    if (!_isInitialized || _prefs == null) {
      // Re-intentar inicializar si no está listo
      await init();
    }

    String value;
    switch (mode) {
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.system:
        value = 'system';
        break;
    }
    await _prefs!.setString(_themeModeKey, value);
  }
}
