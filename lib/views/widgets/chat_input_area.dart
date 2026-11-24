import 'package:flutter/material.dart';

class ChatInputArea extends StatefulWidget {
  final ValueChanged<String> onSend;

  const ChatInputArea({super.key, required this.onSend});

  @override
  State<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<ChatInputArea> {
  final TextEditingController _textController = TextEditingController();

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _textController.clear();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: theme.cardColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant.withOpacity(0.5),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              icon: const Icon(Icons.send_rounded, size: 20),
              onPressed: _handleSend,
            ),
          ],
        ),
      ),
    );
  }
}
