import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_enums.dart';
import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/jarvis_orb_widget.dart';
import '../home/home_view_model.dart';
import 'widgets/futuristic_chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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

  void _handleSend(JarvisMainViewModel vm) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    vm.sendChatMessage(text);
    _scrollToBottom();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.brand;
    final vm = context.watch<JarvisMainViewModel>();
    final activeConv = vm.activeConversation;
    final messages = activeConv?.messages ?? [];

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        backgroundColor: colors.bgSecondary,
        elevation: 1,
        title: Row(
          children: [
            JarvisOrbWidget(
              size: 32,
              state: vm.orbState,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeConv?.title ?? 'Active Transmission',
                    style: AppStyles.bodyLarge.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _getStatusSubtitle(vm.orbState),
                    style: AppStyles.caption.copyWith(
                      color: vm.orbState == OrbState.error
                          ? colors.crimsonAlert
                          : colors.cyanAccent,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              vm.isVoiceMuted ? Icons.volume_off : Icons.volume_up,
              color: colors.cyanAccent,
            ),
            tooltip: vm.isVoiceMuted ? 'Unmute Audio' : 'Mute Audio',
            onPressed: () => vm.toggleVoiceMute(),
          ),
          IconButton(
            icon: Icon(Icons.add, color: colors.cyanAccent),
            tooltip: 'New Conversation',
            onPressed: () async {
              await vm.startNewConversation();
              _scrollToBottom();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          JarvisOrbWidget(
                            size: 140,
                            state: vm.orbState,
                            onTap: () => vm.triggerVoiceInput(),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'COMMUNICATION ARRAY READY',
                            style: AppStyles.hudMono.copyWith(
                              color: colors.cyanAccent,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Send a transmission or tap the orb for voice input.',
                            style: AppStyles.bodyMedium.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return FuturisticChatBubble(
                          message: msg,
                          onRetry: () => vm.sendChatMessage(msg.text),
                        );
                      },
                    ),
            ),
            if (vm.orbState == OrbState.thinking)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'JARVIS is analyzing neural parameters...',
                      style: AppStyles.hudMono.copyWith(
                        color: colors.cyanAccent,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            _buildInputRow(context, vm, colors),
          ],
        ),
      ),
    );
  }

  String _getStatusSubtitle(OrbState state) {
    switch (state) {
      case OrbState.idle:
        return 'Online • Synchronized';
      case OrbState.listening:
        return 'Listening...';
      case OrbState.thinking:
        return 'Processing query...';
      case OrbState.speaking:
        return 'Transmitting audio...';
      case OrbState.error:
        return 'Protocol error';
    }
  }

  Widget _buildInputRow(
    BuildContext context,
    JarvisMainViewModel vm,
    AppBrandColors colors,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        border: Border(top: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              vm.isVoiceListening ? Icons.mic : Icons.mic_none,
              color: vm.isVoiceListening ? colors.neonTeal : colors.cyanAccent,
            ),
            tooltip: 'Voice Input',
            onPressed: () => vm.triggerVoiceInput(),
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              textCapitalization: TextCapitalization.sentences,
              style: AppStyles.bodyMedium.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Transmit message to JARVIS...',
                hintStyle: AppStyles.bodyMedium.copyWith(color: colors.textMuted),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: colors.bgSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: colors.borderSubtle),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: colors.borderSubtle),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: colors.cyanAccent),
                ),
              ),
              onSubmitted: (_) => _handleSend(vm),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: colors.cyanAccent,
              foregroundColor: colors.bgPrimary,
            ),
            icon: const Icon(Icons.send_rounded, size: 20),
            onPressed: () => _handleSend(vm),
          ),
        ],
      ),
    );
  }
}
