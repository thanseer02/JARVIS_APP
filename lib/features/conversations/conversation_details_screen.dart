import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_view_model.dart';

class ConversationDetailsScreen extends StatelessWidget {
  const ConversationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.brand;
    final vm = context.watch<JarvisMainViewModel>();
    final conv = vm.activeConversation;

    if (conv == null) {
      return Scaffold(
        backgroundColor: colors.bgPrimary,
        appBar: AppBar(
          backgroundColor: colors.bgSecondary,
          title: const Text('Protocol Details'),
        ),
        body: Center(
          child: Text(
            'No active protocol selected.',
            style: AppStyles.bodyMedium.copyWith(color: colors.textSecondary),
          ),
        ),
      );
    }

    final createdStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(conv.createdAt);
    final updatedStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(conv.updatedAt);
    final userMsgCount = conv.messages.where((m) => m.isUser).length;
    final aiMsgCount = conv.messages.where((m) => !m.isUser).length;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        backgroundColor: colors.bgSecondary,
        elevation: 1,
        title: Text(
          'PROTOCOL METRICS',
          style: AppStyles.hudMono.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: colors.crimsonAlert),
            tooltip: 'Delete Protocol',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: colors.bgSurface,
                  title: Text(
                    'Purge Protocol',
                    style: TextStyle(color: colors.textPrimary),
                  ),
                  content: Text(
                    'Are you sure you want to delete this conversation?',
                    style: TextStyle(color: colors.textSecondary),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.crimsonAlert,
                      ),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await vm.deleteConversation(conv.id);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.bgSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.borderCyan),
                boxShadow: [
                  BoxShadow(
                    color: colors.cyanAccent.withOpacity(0.08),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.terminal, color: colors.cyanAccent),
                      const SizedBox(width: 8),
                      Text(
                        'PROTOCOL ID',
                        style: AppStyles.hudMono.copyWith(
                          color: colors.cyanAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    conv.title,
                    style: AppStyles.titleLarge.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conv.id,
                    style: AppStyles.hudMono.copyWith(
                      color: colors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Telemetry Grid
            Text(
              'TELEMETRY STATS',
              style: AppStyles.caption.copyWith(
                color: colors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatBox(
                  context,
                  'OPERATOR MSGS',
                  '$userMsgCount',
                  Icons.person_outline,
                  colors.cyanAccent,
                ),
                const SizedBox(width: 12),
                _buildStatBox(
                  context,
                  'JARVIS MSGS',
                  '$aiMsgCount',
                  Icons.smart_toy_outlined,
                  colors.neonTeal,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatBox(
                  context,
                  'TOTAL LOGS',
                  '${conv.messages.length}',
                  Icons.storage,
                  colors.electricBlue,
                ),
                const SizedBox(width: 12),
                _buildStatBox(
                  context,
                  'STATUS',
                  'ARCHIVED',
                  Icons.verified_outlined,
                  colors.amberWarning,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Timestamps Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Column(
                children: [
                  _buildTimestampRow('INITIALIZED', createdStr, colors),
                  const Divider(height: 20),
                  _buildTimestampRow('LAST SYNC', updatedStr, colors),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action: Resume Chat
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: colors.cyanAccent,
                foregroundColor: colors.bgPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.chat_bubble_outline),
              label: Text(
                'RESUME THIS TRANSMISSION',
                style: AppStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.chat);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color accent,
  ) {
    final colors = context.brand;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: AppStyles.hudMono.copyWith(
                    fontSize: 10,
                    color: colors.textMuted,
                  ),
                ),
                Icon(icon, size: 16, color: accent),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppStyles.titleMedium.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimestampRow(String label, String value, AppBrandColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.hudMono.copyWith(
            color: colors.textSecondary,
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: AppStyles.hudMono.copyWith(
            color: colors.cyanAccent,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
