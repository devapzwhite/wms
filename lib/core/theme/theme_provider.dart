import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wms/core/theme/theme_preferences.dart';

/// Provider para el servicio de preferencias de tema
final themePreferencesProvider = Provider<ThemePreferences>((ref) {
  return ThemePreferences();
});

/// Provider que maneja el estado del ThemeMode con persistencia
/// Notifica a toda la app cuando cambia el tema
class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Valor inicial: se sobrescribirá cuando init() se ejecute
    return ThemeMode.dark;
  }

  /// Inicializa el theme desde SharedPreferences (ya inicializado en main.dart)
  Future<void> init() async {
    final prefs = ref.read(themePreferencesProvider);
    // SharedPreferences ya está inicializado en main.dart, solo leemos el valor
    state = prefs.getThemeMode();
  }

  /// Cambia el tema y persiste la preferencia
  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(themePreferencesProvider);
    await prefs.setThemeMode(mode);
    state = mode;
  }
}

/// Provider principal para el ThemeMode
final themeModeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});

/// Provider para verificar si el tema actual es oscuro
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  return themeMode == ThemeMode.dark;
});
