import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:home_widget/home_widget.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'dart:isolate';

import 'app/mealbox_app.dart';
import 'package:mealbox/l10n/generated/app_localizations.dart';
import 'services/meal_service.dart';
import 'services/settings_service.dart';
import 'services/notification_service.dart';
import 'models/meal.dart';

// Callback for the homescreen widget (must be top-level)
@pragma('vm:entry-point')
Future<void> interactiveCallback(Uri? uri) async {
  if (uri?.host == 'log_simple_meal') {
    // 1. Check if the main app (Main Isolate) is still running in the background
    final SendPort? sendPort = IsolateNameServer.lookupPortByName('home_widget_port');
    if (sendPort != null) {
      // App is running! Delegate task to the main app to avoid Hive lock collisions
      sendPort.send('log_simple_meal');
      return;
    }

    // 2. App is completely closed. We can safely initialize Hive.
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MealAdapter());
    }
    final mealService = MealService();
    await mealService.init();
    
    await mealService.addMeal('Widget Log 🍱', energyLevel: '🪫 Low');
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Register widget callback (HomeWidget does not work in web browser)
    if (!kIsWeb) {
      try {
        HomeWidget.registerInteractivityCallback(interactiveCallback);
      } catch (e) {
        debugPrint('HomeWidget Registrierungs-Fehler: $e');
      }
    }

    tz.initializeTimeZones();
    
    await initializeDateFormatting('de_DE', null);
    
    await Hive.initFlutter();
    Hive.registerAdapter(MealAdapter());
    
    final mealService = MealService();
    await mealService.init();

    final settingsService = SettingsService.instance;

    final notificationService = NotificationService();
    await notificationService.init();
    if (settingsService.notifications) {
      Locale systemLocale = PlatformDispatcher.instance.locale;
      // Default to English if the system language is not German
      if (systemLocale.languageCode != 'de') {
        systemLocale = const Locale('en');
      }
      final l10n = lookupAppLocalizations(systemLocale);
      await notificationService.scheduleMealReminders(l10n);
    }
    
    // Setup background communication (IsolateNameServer)
    final port = ReceivePort();
    IsolateNameServer.removePortNameMapping('home_widget_port');
    IsolateNameServer.registerPortWithName(port.sendPort, 'home_widget_port');
    port.listen((message) async {
      if (message == 'log_simple_meal') {
        await mealService.addMeal('Widget Log 🍱', energyLevel: '🪫 Low');
      }
    });

    runApp(
      ChangeNotifierProvider<MealService>.value(
        value: mealService,
        child: const MealBoxApp(),
      ),
    );
  } catch (e, stacktrace) {
    // Failsafe: Show the exact error on screen (even in release mode)
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