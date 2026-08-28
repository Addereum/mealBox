import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import '../screens/home_screen.dart';
import '../services/settings_service.dart';

class MealBoxApp extends StatelessWidget {
  const MealBoxApp({Key? key}) : super(key: key);

  static const Color defaultSeedColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    final settings = SettingsService.instance;

    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            ColorScheme lightColorScheme;
            ColorScheme darkColorScheme;

            if (lightDynamic != null && darkDynamic != null) {
              lightColorScheme = lightDynamic.harmonized();
              darkColorScheme = darkDynamic.harmonized();
            } else {
              lightColorScheme = ColorScheme.fromSeed(
                seedColor: defaultSeedColor,
              );
              darkColorScheme = ColorScheme.fromSeed(
                seedColor: defaultSeedColor,
                brightness: Brightness.dark,
              );
            }

            return MaterialApp(
              title: 'MealBox',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorScheme,
                appBarTheme: AppBarTheme(
                  centerTitle: true,
                  elevation: 2,
                  backgroundColor: lightColorScheme.primary,
                  foregroundColor: lightColorScheme.onPrimary,
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkColorScheme,
                appBarTheme: AppBarTheme(
                  centerTitle: true,
                  elevation: 2,
                  backgroundColor: darkColorScheme.primary,
                  foregroundColor: darkColorScheme.onPrimary,
                ),
              ),
              themeMode: settings.themeMode,
              home: const HomeScreen(),
            );
          },
        );
      },
    );
  }
}
