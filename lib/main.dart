import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_routes.dart';
import 'core/theme/app_brand_colors.dart';
import 'data/repositories/mock_jarvis_repository.dart';
import 'data/repositories/remote_jarvis_repository.dart';
import 'data/services/jarvis_api_client.dart';
import 'features/chat/chat_screen.dart';
import 'features/conversations/conversation_details_screen.dart';
import 'features/conversations/conversation_history_screen.dart';
import 'features/home/home_screen.dart';
import 'features/home/home_view_model.dart';
import 'features/home/splash_screen.dart';
import 'features/settings/backend_connection_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/voice/voice_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JarvisApp());
}

class JarvisApp extends StatefulWidget {
  const JarvisApp({super.key});

  @override
  State<JarvisApp> createState() => _JarvisAppState();
}

class _JarvisAppState extends State<JarvisApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _updateThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    final apiClient = JarvisApiClient(
      config: BackendConfig(
        baseUrl: 'http://localhost:8080',
        useMock: true,
      ),
    );
    final mockRepo = MockJarvisRepository();
    final remoteRepo = RemoteJarvisRepository(apiClient);
    final voiceService = JarvisVoiceService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => JarvisMainViewModel(
            repository: remoteRepo,
            mockRepository: mockRepo,
            voiceService: voiceService,
            apiClient: apiClient,
          ),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'JARVIS — Personal AI Assistant',
            debugShowCheckedModeBanner: false,
            themeMode: _themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: AppBrandColors.light.bgPrimary,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppBrandColors.light.cyanAccent,
                brightness: Brightness.light,
              ),
              extensions: const [AppBrandColors.light],
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppBrandColors.dark.bgPrimary,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppBrandColors.dark.cyanAccent,
                brightness: Brightness.dark,
              ),
              extensions: const [AppBrandColors.dark],
              useMaterial3: true,
            ),
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (context) => const SplashScreen(),
              AppRoutes.home: (context) => const HomeScreen(),
              AppRoutes.chat: (context) => const ChatScreen(),
              AppRoutes.conversationHistory: (context) =>
                  const ConversationHistoryScreen(),
              AppRoutes.conversationDetails: (context) =>
                  const ConversationDetailsScreen(),
              AppRoutes.settings: (context) => SettingsScreen(
                    currentThemeMode: _themeMode,
                    onThemeModeChanged: _updateThemeMode,
                  ),
              AppRoutes.backendConnection: (context) =>
                  const BackendConnectionScreen(),
            },
          );
        },
      ),
    );
  }
}
