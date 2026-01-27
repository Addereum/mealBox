import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../services/settings_service.dart';

class MealBoxApp extends StatelessWidget {
  const MealBoxApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = SettingsService.instance;

    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        return MaterialApp(
          title: 'MealBox',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 2,
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 2,
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: settings.themeMode, // WICHTIG
          home: HomeScreen(),
        );
      },
    );
  }
}
