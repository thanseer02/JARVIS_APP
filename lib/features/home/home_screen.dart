import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_enums.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/conversation_model.dart';
import '../../shared/widgets/jarvis_orb_widget.dart';
import '../../shared/widgets/status_badge_widget.dart';
import 'home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning, Sir.';
    if (hour < 17) return 'Good afternoon, Sir.';
    return 'Good evening, Sir.';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.brand;
    final now = DateTime.now();
    final timeStr = DateFormat('HH:mm:ss').format(now);
    final dateStr = DateFormat('EEEE, MMMM d, y').format(now);

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.cyanAccent,
                boxShadow: [
                  BoxShadow(
                    color: colors.cyanAccent,
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'JARVIS v2.4',
              style: AppStyles.hudMono.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Consumer<JarvisMainViewModel>(
            builder: (context, vm, _) {
              return StatusBadgeWidget(
                status: vm.connectionStatus,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.backendConnection),
              );
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.tune, color: colors.cyanAccent),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              // Time & HUD Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTimeGreeting(),
                        style: AppStyles.titleMedium.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        dateStr.toUpperCase(),
                        style: AppStyles.caption.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.bgSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.borderSubtle),
                    ),
                    child: Text(
                      timeStr,
                      style: AppStyles.hudMono.copyWith(
                        color: colors.cyanAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Central Holographic Orb
              Consumer<JarvisMainViewModel>(
                builder: (context, vm, _) {
                  return Column(
                    children: [
                      JarvisOrbWidget(
                        size: 220,
                        state: vm.orbState,
                        onTap: () => vm.triggerVoiceInput(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getStateDescription(vm.orbState),
                        style: AppStyles.hudMono.copyWith(
                          color: colors.cyanAccent,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // Quick Actions Bar (Voice, Text Chat, New Protocol)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildQuickAction(
                    context,
                    icon: Icons.chat_bubble_outline,
                    label: 'Direct Chat',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.chat);
                    },
                  ),
                  const SizedBox(width: 16),
                  Consumer<JarvisMainViewModel>(
                    builder: (context, vm, _) {
                      return _buildQuickAction(
                        context,
                        icon: vm.isVoiceListening ? Icons.mic : Icons.mic_none,
                        label: vm.isVoiceListening
                            ? 'Listening...'
                            : 'Voice Command',
                        isPrimary: true,
                        onTap: () => vm.triggerVoiceInput(),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  _buildQuickAction(
                    context,
                    icon: Icons.history,
                    label: 'History',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.conversationHistory,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // Recent Protocols Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECENT PROTOCOLS',
                    style: AppStyles.caption.copyWith(
                      color: colors.textSecondary,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.conversationHistory,
                    ),
                    child: Text(
                      'VIEW ALL',
                      style: AppStyles.hudMono.copyWith(
                        color: colors.cyanAccent,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Consumer<JarvisMainViewModel>(
                builder: (context, vm, _) {
                  if (vm.recentConversations.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colors.bgSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.borderSubtle),
                      ),
                      child: Center(
                        child: Text(
                          'No recent protocols logged.',
                          style: AppStyles.bodyMedium.copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: vm.recentConversations.take(3).map((conv) {
                      return _buildProtocolCard(context, conv, colors);
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _getStateDescription(OrbState state) {
    switch (state) {
      case OrbState.idle:
        return 'READY FOR COMMANDS';
      case OrbState.listening:
        return 'ACOUSTIC RECEPTORS ACTIVE';
      case OrbState.thinking:
        return 'PROCESSING QUANTUM QUERY';
      case OrbState.speaking:
        return 'VOCAL TRANSMISSION ACTIVE';
      case OrbState.error:
        return 'TELEMETRY ANOMALY';
    }
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    final colors = context.brand;
    final bg = isPrimary
        ? colors.cyanAccent.withValues(alpha: 0.18)
        : colors.bgSurface;
    final border = isPrimary ? colors.cyanAccent : colors.borderSubtle;
    final iconColor = isPrimary ? colors.cyanAccent : colors.textPrimary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: isPrimary ? 1.5 : 1),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: colors.cyanAccent.withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppStyles.caption.copyWith(
                  color: isPrimary ? colors.cyanAccent : colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProtocolCard(
    BuildContext context,
    ConversationModel conv,
    AppBrandColors colors,
  ) {
    final timeStr = DateFormat('MMM d, HH:mm').format(conv.updatedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.cyanAccent.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: colors.borderCyan),
          ),
          child: Icon(Icons.memory, color: colors.cyanAccent, size: 20),
        ),
        title: Text(
          conv.title,
          style: AppStyles.bodyLarge.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          conv.lastMessagePreview ?? 'No transmission logs.',
          style: AppStyles.bodyMedium.copyWith(color: colors.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              timeStr,
              style: AppStyles.hudMono.copyWith(
                color: colors.textMuted,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            Icon(Icons.chevron_right, color: colors.cyanAccent, size: 16),
          ],
        ),
          onTap: () {
            context.read<JarvisMainViewModel>().selectConversation(conv.id);
            Navigator.pushNamed(context, AppRoutes.chat);
          },
        ),
      ),
    );
  }
}
