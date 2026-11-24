import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/status_badge_widget.dart';
import '../home/home_view_model.dart';

class BackendConnectionScreen extends StatefulWidget {
  const BackendConnectionScreen({super.key});

  @override
  State<BackendConnectionScreen> createState() =>
      _BackendConnectionScreenState();
}

class _BackendConnectionScreenState extends State<BackendConnectionScreen> {
  late TextEditingController _urlController;
  bool _isCheckingHealth = false;
  String? _healthLog;

  @override
  void initState() {
    super.initState();
    final vm = context.read<JarvisMainViewModel>();
    _urlController = TextEditingController(text: vm.apiClient.config.baseUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pingBackend(JarvisMainViewModel vm) async {
    setState(() {
      _isCheckingHealth = true;
      _healthLog = 'Pinging /api/health at ${_urlController.text.trim()}...';
    });

    vm.apiClient.updateBaseUrl(_urlController.text.trim());
    final isHealthy = await vm.apiClient.checkHealth();

    setState(() {
      _isCheckingHealth = false;
      _healthLog = isHealthy
          ? 'SUCCESS: [200 OK] Backend active & neural link established.'
          : 'WARNING: Connection refused or non-200. Check if jarvic_backend Shelf server is running on ${_urlController.text.trim()}.';
    });

    await vm.refreshConnectionStatus();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.brand;
    final vm = context.watch<JarvisMainViewModel>();
    final config = vm.apiClient.config;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        backgroundColor: colors.bgSecondary,
        elevation: 1,
        title: Text(
          'BACKEND RELAY LINK',
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
            // Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.bgSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.borderCyan),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CURRENT RELAY STATUS',
                        style: AppStyles.hudMono.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      StatusBadgeWidget(status: vm.connectionStatus),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    config.useMock
                        ? 'Active Mode: Simulation Matrix (Mock Repository)'
                        : 'Active Mode: Live REST Link (${config.baseUrl})',
                    style: AppStyles.bodyMedium.copyWith(
                      color: colors.cyanAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Mode Selector
            Text(
              'NETWORK ARCHITECTURE MODE',
              style: AppStyles.hudMono.copyWith(
                color: colors.cyanAccent,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: colors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: SwitchListTile(
                title: Text(
                  'Simulation / Mock Repository',
                  style: AppStyles.bodyLarge.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  'Enable to use realistic mock data while Phase 5 Shelf REST API is pending',
                  style: AppStyles.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                secondary: Icon(
                  Icons.science_outlined,
                  color: colors.cyanAccent,
                ),
                value: config.useMock,
                activeColor: colors.cyanAccent,
                onChanged: (val) {
                  setState(() => config.useMock = val);
                  vm.refreshConnectionStatus();
                },
              ),
            ),
            const SizedBox(height: 24),

            // Endpoint Configuration
            Text(
              'SHELF REST API HOST CONFIG',
              style: AppStyles.hudMono.copyWith(
                color: colors.cyanAccent,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _urlController,
              style: AppStyles.bodyMedium.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Base URL',
                labelStyle: TextStyle(color: colors.textSecondary),
                hintText: 'http://localhost:8080 or http://10.0.2.2:8080',
                prefixIcon: Icon(Icons.link, color: colors.cyanAccent),
                filled: true,
                fillColor: colors.bgSurface,
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
            ),
            const SizedBox(height: 16),

            // Ping Button
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: colors.cyanAccent,
                foregroundColor: colors.bgPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isCheckingHealth
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.bgPrimary,
                      ),
                    )
                  : const Icon(Icons.network_ping),
              label: Text(
                _isCheckingHealth
                    ? 'PINGING /api/health...'
                    : 'TEST HEALTH ENDPOINT',
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _isCheckingHealth ? null : () => _pingBackend(vm),
            ),

            if (_healthLog != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.bgSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.borderCyan),
                ),
                child: Text(
                  _healthLog!,
                  style: AppStyles.hudMono.copyWith(
                    color: _healthLog!.startsWith('SUCCESS')
                        ? colors.neonTeal
                        : colors.amberWarning,
                    fontSize: 11,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
            // Endpoints list summary
            Text(
              'PLANNED PHASE 5 CONTRACTS',
              style: AppStyles.hudMono.copyWith(
                color: colors.cyanAccent,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEndpointRow(
                    'GET',
                    '/api/health',
                    'Health check ping',
                    colors,
                  ),
                  _buildEndpointRow(
                    'POST',
                    '/api/chat',
                    'Stream/Send prompt',
                    colors,
                  ),
                  _buildEndpointRow(
                    'POST',
                    '/api/conversations',
                    'Create thread',
                    colors,
                  ),
                  _buildEndpointRow(
                    'GET',
                    '/api/conversations',
                    'Fetch history',
                    colors,
                  ),
                  _buildEndpointRow(
                    'GET',
                    '/api/conversations/:id',
                    'Inspect thread',
                    colors,
                  ),
                  _buildEndpointRow(
                    'DELETE',
                    '/api/conversations/:id',
                    'Purge thread',
                    colors,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndpointRow(
    String method,
    String path,
    String desc,
    AppBrandColors colors,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: colors.cyanAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              method,
              style: AppStyles.hudMono.copyWith(
                color: colors.cyanAccent,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              path,
              style: AppStyles.hudMono.copyWith(
                color: colors.textPrimary,
                fontSize: 11,
              ),
            ),
          ),
          Text(
            desc,
            style: AppStyles.caption.copyWith(
              color: colors.textMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
