import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'configs/app_configs.dart';
import 'features/home/view_model/home_view_model.dart';
import 'features/settings/view/settings_screen.dart';
import 'utils/brand_colors.dart';
import 'utils/routes.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => JarvisMainViewModel(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: AppConfigs.appName,
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
            initialRoute: Routes.splash,
            routes: {
              ...Routes.routes,
              Routes.settings: (context) => SettingsScreen(
                    currentThemeMode: _themeMode,
                    onThemeModeChanged: _updateThemeMode,
                  ),
            },
          );
        },
      ),
    );
  }
}
