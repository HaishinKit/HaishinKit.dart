import 'package:flutter/material.dart';

const studioBackground = Color(0xFF0B121C);
const studioSurface = Color(0xFF101B28);
const previewScrim = Color(0xC7000000);

ThemeData studioTheme() {
  const colors = ColorScheme.dark(
    primary: Color(0xFF65DEC9),
    onPrimary: Color(0xFF00382F),
    primaryContainer: Color(0xFF164D45),
    onPrimaryContainer: Color(0xFFA0F2E1),
    secondary: Color(0xFFB7C9DB),
    onSecondary: Color(0xFF233342),
    secondaryContainer: Color(0xFF293E50),
    onSecondaryContainer: Color(0xFFD6E7F8),
    surface: studioSurface,
    onSurface: Color(0xFFE6EDF5),
    onSurfaceVariant: Color(0xFFB8C7D6),
    outline: Color(0xFF7E90A2),
    outlineVariant: Color(0xFF3C5063),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    scaffoldBackgroundColor: studioBackground,
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: studioSurface,
      indicatorColor: Color(0xFF293E50),
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: studioSurface,
      indicatorColor: Color(0xFF293E50),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: studioSurface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      alignLabelWithHint: true,
    ),
    cardTheme: CardThemeData(
      color: studioSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFF3C5063)),
      ),
    ),
  );
}

extension StudioCopy on BuildContext {
  String studioText(String english, String japanese) =>
      Localizations.localeOf(this).languageCode == 'ja' ? japanese : english;
}
