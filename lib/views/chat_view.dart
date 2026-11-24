import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/chat_viewmodel.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input_area.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final viewModel = context.watch<ChatViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.smart_toy_outlined,
                color: colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jarvis Mini',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  viewModel.isTyping ? 'typing...' : 'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: viewModel.isTyping
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear Chat',
            onPressed: () {
              context.read<ChatViewModel>().clearChat();
              _scrollToBottom();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: viewModel.messages.length,
                itemBuilder: (context, index) {
                  final message = viewModel.messages[index];
                  return ChatBubble(message: message);
                },
              ),
            ),
            if (viewModel.isTyping)
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Jarvis is thinking...',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ChatInputArea(
              onSend: (text) {
                context.read<ChatViewModel>().sendMessage(text);
                _scrollToBottom();
              },
            ),
          ],
        ),
      ),
    );
  }
}
