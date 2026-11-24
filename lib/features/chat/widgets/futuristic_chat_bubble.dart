import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/chat_message_model.dart';

class FuturisticChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final VoidCallback? onRetry;

  const FuturisticChatBubble({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = context.brand;
    final isUser = message.isUser;
    final timeStr = DateFormat('HH:mm').format(message.timestamp);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser
              ? colors.cyanAccent.withOpacity(0.14)
              : colors.bgSurface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: Border.all(
            color: isUser
                ? colors.cyanAccent.withOpacity(0.6)
                : colors.borderSubtle,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isUser
                  ? colors.cyanAccent.withOpacity(0.12)
                  : Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isUser ? Icons.person_outline : Icons.smart_toy_outlined,
                  size: 13,
                  color: isUser ? colors.cyanAccent : colors.neonTeal,
                ),
                const SizedBox(width: 4),
                Text(
                  isUser ? 'OPERATOR' : 'JARVIS CORE',
                  style: AppStyles.hudMono.copyWith(
                    fontSize: 9,
                    color: isUser ? colors.cyanAccent : colors.neonTeal,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  timeStr,
                  style: AppStyles.hudMono.copyWith(
                    fontSize: 9,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              message.text,
              style: AppStyles.bodyMedium.copyWith(
                color: colors.textPrimary,
                height: 1.4,
              ),
            ),
            if (message.isPending) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Transmitting...',
                    style: AppStyles.hudMono.copyWith(
                      color: colors.textMuted,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
            if (message.isError && onRetry != null) ...[
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onRetry,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, size: 14, color: colors.crimsonAlert),
                    const SizedBox(width: 4),
                    Text(
                      'Transmission failed. Tap to retry.',
                      style: AppStyles.caption.copyWith(
                        color: colors.crimsonAlert,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
