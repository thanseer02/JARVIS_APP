import 'package:flutter/material.dart';

/// Semantic futuristic brand colors for JARVIS.
@immutable
class AppBrandColors extends ThemeExtension<AppBrandColors> {
  final Color bgPrimary;
  final Color bgSecondary;
  final Color bgSurface;
  final Color bgGlass;

  final Color cyanAccent;
  final Color electricBlue;
  final Color neonTeal;
  final Color holographicGlow;
  final Color amberWarning;
  final Color crimsonAlert;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textGlow;

  final Color borderCyan;
  final Color borderSubtle;

  const AppBrandColors({
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgSurface,
    required this.bgGlass,
    required this.cyanAccent,
    required this.electricBlue,
    required this.neonTeal,
    required this.holographicGlow,
    required this.amberWarning,
    required this.crimsonAlert,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textGlow,
    required this.borderCyan,
    required this.borderSubtle,
  });

  /// Dark Sci-Fi JARVIS palette (default)
  static const dark = AppBrandColors(
    bgPrimary: Color(0xFF030712), // Deep Void Black
    bgSecondary: Color(0xFF0B1220), // Dark Navy
    bgSurface: Color(0xFF111C33), // Space Navy Card
    bgGlass: Color(0x2A00E5FF), // Holographic Glass
    cyanAccent: Color(0xFF00E5FF), // JARVIS Cyan
    electricBlue: Color(0xFF0088FF), // Pulse Blue
    neonTeal: Color(0xFF00FFC2), // Online Neon Teal
    holographicGlow: Color(0x6600E5FF), // Cyan Bloom
    amberWarning: Color(0xFFFFB300), // Alert Amber
    crimsonAlert: Color(0xFFFF1744), // Critical Red
    textPrimary: Color(0xFFF0F6FC), // Pure Bright White
    textSecondary: Color(0xFF94A3B8), // Cool Metallic Silver
    textMuted: Color(0xFF475569), // Muted Dark Silver
    textGlow: Color(0xFF00E5FF), // Cyan Text Glow
    borderCyan: Color(0x5500E5FF), // Glowing Border
    borderSubtle: Color(0x2238BDF8), // Subtle HUD Line
  );

  /// Light Holographic HUD palette
  static const light = AppBrandColors(
    bgPrimary: Color(0xFFF0F4F8), // Crisp Silver White
    bgSecondary: Color(0xFFE2E8F0), // Pale Steel
    bgSurface: Color(0xFFFFFFFF), // Pure White Glass
    bgGlass: Color(0x1F0284C7),
    cyanAccent: Color(0xFF0284C7), // Deep Holographic Blue
    electricBlue: Color(0xFF0369A1),
    neonTeal: Color(0xFF0D9488),
    holographicGlow: Color(0x330284C7),
    amberWarning: Color(0xFFD97706),
    crimsonAlert: Color(0xFFDC2626),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textMuted: Color(0xFF94A3B8),
    textGlow: Color(0xFF0284C7),
    borderCyan: Color(0x440284C7),
    borderSubtle: Color(0x2294A3B8),
  );

  @override
  AppBrandColors copyWith({
    Color? bgPrimary,
    Color? bgSecondary,
    Color? bgSurface,
    Color? bgGlass,
    Color? cyanAccent,
    Color? electricBlue,
    Color? neonTeal,
    Color? holographicGlow,
    Color? amberWarning,
    Color? crimsonAlert,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textGlow,
    Color? borderCyan,
    Color? borderSubtle,
  }) {
    return AppBrandColors(
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgSurface: bgSurface ?? this.bgSurface,
      bgGlass: bgGlass ?? this.bgGlass,
      cyanAccent: cyanAccent ?? this.cyanAccent,
      electricBlue: electricBlue ?? this.electricBlue,
      neonTeal: neonTeal ?? this.neonTeal,
      holographicGlow: holographicGlow ?? this.holographicGlow,
      amberWarning: amberWarning ?? this.amberWarning,
      crimsonAlert: crimsonAlert ?? this.crimsonAlert,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textGlow: textGlow ?? this.textGlow,
      borderCyan: borderCyan ?? this.borderCyan,
      borderSubtle: borderSubtle ?? this.borderSubtle,
    );
  }

  @override
  AppBrandColors lerp(ThemeExtension<AppBrandColors>? other, double t) {
    if (other is! AppBrandColors) return this;
    return AppBrandColors(
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t)!,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t)!,
      bgSurface: Color.lerp(bgSurface, other.bgSurface, t)!,
      bgGlass: Color.lerp(bgGlass, other.bgGlass, t)!,
      cyanAccent: Color.lerp(cyanAccent, other.cyanAccent, t)!,
      electricBlue: Color.lerp(electricBlue, other.electricBlue, t)!,
      neonTeal: Color.lerp(neonTeal, other.neonTeal, t)!,
      holographicGlow: Color.lerp(holographicGlow, other.holographicGlow, t)!,
      amberWarning: Color.lerp(amberWarning, other.amberWarning, t)!,
      crimsonAlert: Color.lerp(crimsonAlert, other.crimsonAlert, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textGlow: Color.lerp(textGlow, other.textGlow, t)!,
      borderCyan: Color.lerp(borderCyan, other.borderCyan, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
    );
  }
}
