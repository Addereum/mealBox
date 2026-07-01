import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // WICHTIG: Provider hinzufügen
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:home_widget/home_widget.dart';
import 'package:flutter/foundation.dart';
import 'app/mealbox_app.dart';
import 'services/meal_service.dart';
import 'services/settings_service.dart';
import 'services/notification_service.dart';
import 'models/meal.dart';

// Callback für das Homescreen-Widget (muss Top-Level sein)
@pragma('vm:entry-point')
Future<void> interactiveCallback(Uri? uri) async {
  if (uri?.host == 'log_simple_meal') {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MealAdapter());
    }
    final mealService = MealService();
    await mealService.init();
    
    // Wir loggen eine schnelle Mahlzeit
    await mealService.addMeal('Widget Log 🍱', energyLevel: '🪫 Low');
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Widget Callback registrieren (HomeWidget funktioniert nicht im Web-Browser)
    if (!kIsWeb) {
      try {
        HomeWidget.registerInteractivityCallback(interactiveCallback);
      } catch (e) {
        debugPrint('HomeWidget Registrierungs-Fehler: $e');
      }
    }

    tz.initializeTimeZones();
    
    // Lokalisierung für Deutsch initialisieren
    await initializeDateFormatting('de_DE', null);
    
    await Hive.initFlutter();
    Hive.registerAdapter(MealAdapter());
    
    // MealService initialisieren
    final mealService = MealService();
    await mealService.init();

    // SettingsService initialisieren
    final settingsService = SettingsService.instance;

    // NotificationService initialisieren
    final notificationService = NotificationService();
    await notificationService.init();
    if (settingsService.notifications) {
      await notificationService.scheduleMealReminders();
    }
    
    runApp(
      ChangeNotifierProvider<MealService>.value(
        value: mealService,
        child: const MealBoxApp(),
      ),
    );
  } catch (e, stacktrace) {
    // Failsafe: Zeige den genauen Fehler auf dem Bildschirm an (auch im Release-Modus)
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  'Kritischer Start-Fehler:\n$e\n\n$stacktrace',
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}