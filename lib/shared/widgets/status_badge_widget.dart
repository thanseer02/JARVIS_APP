import 'package:flutter/material.dart';

import '../../core/constants/app_enums.dart';
import '../../core/theme/app_theme.dart';

class StatusBadgeWidget extends StatelessWidget {
  final BackendConnectionStatus status;
  final VoidCallback? onTap;

  const StatusBadgeWidget({super.key, required this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.brand;

    Color badgeColor;
    String label;
    IconData icon;

    switch (status) {
      case BackendConnectionStatus.connected:
        badgeColor = colors.neonTeal;
        label = 'CORE ONLINE';
        icon = Icons.wifi;
        break;
      case BackendConnectionStatus.connecting:
        badgeColor = colors.amberWarning;
        label = 'SYNCHRONIZING';
        icon = Icons.sync;
        break;
      case BackendConnectionStatus.disconnected:
        badgeColor = colors.crimsonAlert;
        label = 'OFFLINE';
        icon = Icons.wifi_off;
        break;
      case BackendConnectionStatus.mockMode:
        badgeColor = colors.cyanAccent;
        label = 'SIMULATION MATRIX';
        icon = Icons.memory;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: badgeColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: badgeColor.withValues(alpha: 0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: badgeColor.withValues(alpha: 0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badgeColor,
                boxShadow: [
                  BoxShadow(color: badgeColor, blurRadius: 6, spreadRadius: 2),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppStyles.hudMono.copyWith(
                color: badgeColor,
                fontSize: 10,
              ),
            ),
            const SizedBox(width: 4),
            Icon(icon, size: 12, color: badgeColor),
          ],
        ),
      ),
    );
  }
}
