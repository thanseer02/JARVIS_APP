import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/conversation_model.dart';
import '../home/home_view_model.dart';

class ConversationHistoryScreen extends StatefulWidget {
  const ConversationHistoryScreen({super.key});

  @override
  State<ConversationHistoryScreen> createState() =>
      _ConversationHistoryScreenState();
}

class _ConversationHistoryScreenState extends State<ConversationHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.brand;
    final vm = context.watch<JarvisMainViewModel>();

    final filtered = vm.recentConversations.where((conv) {
      final q = _searchQuery.toLowerCase();
      final titleMatch = conv.title.toLowerCase().contains(q);
      final lastMsgMatch =
          conv.lastMessagePreview?.toLowerCase().contains(q) ?? false;
      return titleMatch || lastMsgMatch;
    }).toList();

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        backgroundColor: colors.bgSecondary,
        elevation: 1,
        title: Text(
          'PROTOCOL LOG ARCHIVES',
          style: AppStyles.hudMono.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: colors.cyanAccent),
            tooltip: 'New Protocol',
            onPressed: () async {
              await vm.startNewConversation();
              if (context.mounted) {
                Navigator.pushNamed(context, AppRoutes.chat);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                style: AppStyles.bodyMedium.copyWith(color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search archive by title or transmission...',
                  hintStyle: AppStyles.bodyMedium.copyWith(
                    color: colors.textMuted,
                  ),
                  prefixIcon: Icon(Icons.search, color: colors.cyanAccent),
                  filled: true,
                  fillColor: colors.bgSurface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.borderSubtle),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.cyanAccent),
                  ),
                ),
                onChanged: (val) {
                  setState(() => _searchQuery = val);
                },
              ),
            ),
            // Conversations List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No archives match your query.',
                        style: AppStyles.bodyMedium.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final conv = filtered[index];
                        return _buildConversationItem(
                          context,
                          conv,
                          vm,
                          colors,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationItem(
    BuildContext context,
    ConversationModel conv,
    JarvisMainViewModel vm,
    AppBrandColors colors,
  ) {
    final dateStr = DateFormat('MMM dd, yyyy • HH:mm').format(conv.updatedAt);

    return Dismissible(
      key: Key(conv.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: colors.crimsonAlert.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.crimsonAlert),
        ),
        child: Icon(Icons.delete_outline, color: colors.crimsonAlert),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: colors.bgSurface,
            title: Text(
              'Purge Archive?',
              style: AppStyles.titleMedium.copyWith(color: colors.textPrimary),
            ),
            content: Text(
              'Confirm purge of protocol archive "${conv.title}". This cannot be undone.',
              style: AppStyles.bodyMedium.copyWith(color: colors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: colors.textSecondary),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.crimsonAlert,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Purge'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        vm.deleteConversation(conv.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.cyanAccent.withOpacity(0.12),
              border: Border.all(color: colors.borderCyan),
            ),
            child: Icon(
              Icons.forum_outlined,
              color: colors.cyanAccent,
              size: 20,
            ),
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                conv.lastMessagePreview ?? 'No transmission logs recorded.',
                style: AppStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                dateStr,
                style: AppStyles.hudMono.copyWith(
                  color: colors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.info_outline, color: colors.cyanAccent, size: 20),
            tooltip: 'Protocol Details',
            onPressed: () {
              vm.selectConversation(conv.id);
              Navigator.pushNamed(context, AppRoutes.conversationDetails);
            },
          ),
          onTap: () {
            vm.selectConversation(conv.id);
            Navigator.pushNamed(context, AppRoutes.chat);
          },
        ),
      ),
    );
  }
}
