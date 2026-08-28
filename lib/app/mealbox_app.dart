import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dynamic_color/dynamic_color.dart';
import '../screens/home_screen.dart';
import '../services/settings_service.dart';

class MealBoxApp extends StatelessWidget {
  const MealBoxApp({Key? key}) : super(key: key);

  static const Color defaultSeedColor = Color(0xFF7A9E7E); // Sage Green

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

            final baseLightTextTheme = GoogleFonts.outfitTextTheme(ThemeData.light().textTheme);
            final baseDarkTextTheme = GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme);

            return MaterialApp(
              title: 'MealBox',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorScheme,
                textTheme: baseLightTextTheme,
                scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Off-white
                appBarTheme: AppBarTheme(
                  centerTitle: true,
                  elevation: 0, // Flat design, depth through layout
                  backgroundColor: lightColorScheme.surface,
                  foregroundColor: lightColorScheme.onSurface,
                ),
                cardTheme: const CardThemeData(
                  elevation: 0, // No default shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                ),
                dialogTheme: const DialogThemeData(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28))),
                ),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkColorScheme,
                textTheme: baseDarkTextTheme,
                scaffoldBackgroundColor: const Color(0xFF121212), // Premium off-black
                appBarTheme: AppBarTheme(
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: const Color(0xFF121212),
                  foregroundColor: darkColorScheme.onSurface,
                ),
                cardTheme: const CardThemeData(
                  elevation: 0, // Tinted shadows will be applied manually if needed
                  color: Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                ),
                dialogTheme: const DialogThemeData(
                  backgroundColor: Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28))),
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
