import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_view_model.dart';

class SettingsScreen extends StatefulWidget {
  final ValueChanged<ThemeMode>? onThemeModeChanged;
  final ThemeMode currentThemeMode;

  const SettingsScreen({
    super.key,
    this.onThemeModeChanged,
    this.currentThemeMode = ThemeMode.dark,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDark;
  bool _voiceFeedback = true;
  bool _hapticFeedback = true;

  @override
  void initState() {
    super.initState();
    _isDark = widget.currentThemeMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.brand;
    final vm = context.watch<JarvisMainViewModel>();

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        backgroundColor: colors.bgSecondary,
        elevation: 1,
        title: Text(
          'NEURAL CONFIGURATION',
          style: AppStyles.hudMono.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Section: Visual System
            _buildSectionHeader('INTERFACE & VISUAL SPECTRUM', colors),
            Container(
              decoration: BoxDecoration(
                color: colors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Material(
                type: MaterialType.transparency,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      'Dark Void Mode',
                      style: AppStyles.bodyLarge.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Deep navy and black sci-fi palette',
                      style: AppStyles.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    secondary: Icon(
                      Icons.dark_mode_outlined,
                      color: colors.cyanAccent,
                    ),
                    value: _isDark,
                    activeColor: colors.cyanAccent,
                    onChanged: (val) {
                      setState(() => _isDark = val);
                      widget.onThemeModeChanged?.call(
                        val ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

            // Section: Voice & Audio
            _buildSectionHeader('AUDIO ACOUSTICS & SYNTHESIS', colors),
            Container(
              decoration: BoxDecoration(
                color: colors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Material(
                type: MaterialType.transparency,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      'Mute Vocal Synthesis',
                      style: AppStyles.bodyLarge.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Silence speech feedback while retaining text responses',
                      style: AppStyles.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    secondary: Icon(
                      vm.isVoiceMuted ? Icons.volume_off : Icons.volume_up,
                      color: colors.cyanAccent,
                    ),
                    value: vm.isVoiceMuted,
                    activeColor: colors.cyanAccent,
                    onChanged: (_) => vm.toggleVoiceMute(),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(
                      'Vocal Receptive Feedback',
                      style: AppStyles.bodyLarge.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Play chimes during listening activation',
                      style: AppStyles.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    secondary: Icon(Icons.graphic_eq, color: colors.cyanAccent),
                    value: _voiceFeedback,
                    activeColor: colors.cyanAccent,
                    onChanged: (val) => setState(() => _voiceFeedback = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(
                      'Haptic Telemetry Pulses',
                      style: AppStyles.bodyLarge.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    subtitle: Text('Tactile response on orb interactions'),
                    secondary: Icon(Icons.vibration, color: colors.cyanAccent),
                    value: _hapticFeedback,
                    activeColor: colors.cyanAccent,
                    onChanged: (val) => setState(() => _hapticFeedback = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

            // Section: Network & Engine Link
            _buildSectionHeader('INFRASTRUCTURE LINK', colors),
            Container(
              decoration: BoxDecoration(
                color: colors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Material(
                type: MaterialType.transparency,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: Icon(Icons.dns_outlined, color: colors.cyanAccent),
                  title: Text(
                    'Backend Connection',
                    style: AppStyles.bodyLarge.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Configure Shelf REST API host & health ping',
                    style: AppStyles.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right, color: colors.cyanAccent),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.backendConnection),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Version info
            Center(
              child: Text(
                'JARVIS CLIENT MATRIX v2.4.0\nLINKED ARCHITECTURE: MVVM + DIO + PROVIDER',
                textAlign: TextAlign.center,
                style: AppStyles.hudMono.copyWith(
                  color: colors.textMuted,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, AppBrandColors colors) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: AppStyles.hudMono.copyWith(
          color: colors.cyanAccent,
          fontSize: 11,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}
