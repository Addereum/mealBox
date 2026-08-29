// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'MealBox 🍱';

  @override
  String get breakfast => 'Frühstück';

  @override
  String get lunch => 'Mittagessen';

  @override
  String get dinner => 'Abendessen';

  @override
  String get snack => 'Snack';

  @override
  String get meal => 'Mahlzeit';

  @override
  String get addMeal => 'Hinzufügen';

  @override
  String get addMealTitle => 'Mahlzeit hinzufügen';

  @override
  String get history => 'Historie';

  @override
  String get settings => 'Einstellungen';

  @override
  String get safeFoods => 'Safe Foods';

  @override
  String get safeFoodsDesc =>
      'Füge Lebensmittel hinzu, die du immer essen kannst, wenn gar nichts anderes geht.';

  @override
  String get therapyExport => 'Therapie-Export';

  @override
  String get exportPdf => 'Als PDF exportieren';

  @override
  String get exportCsv => 'Als CSV exportieren';

  @override
  String get exportSuccess => '✅ Daten erfolgreich exportiert';

  @override
  String get noEnergy => 'Gar keine Energie?';

  @override
  String get sosTitle => 'SOS 🆘';

  @override
  String get sosMessageFallback =>
      'Trink ein Glas Wasser, iss einen Löffel Erdnussbutter oder beiß in einen Apfel. Hauptsache etwas!';

  @override
  String get sosMessagePrefix =>
      'Gar keine Energie? Versuch doch mal das hier:\n\n';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get logNow => 'Jetzt loggen!';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteConfirmTitle => 'Löschen bestätigen';

  @override
  String deleteConfirmMessage(String mealType, String time) {
    return 'Möchtest du $mealType von $time wirklich löschen?';
  }

  @override
  String todayEaten(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mahlzeiten',
      one: 'Mahlzeit',
    );
    return 'Heute gegessen: $count $_temp0';
  }

  @override
  String water(int count) {
    return 'Wasser: $count Glas';
  }

  @override
  String get weeklyStats => 'Wochen-Statistik';

  @override
  String streakDays(int count) {
    return '$count Tage';
  }

  @override
  String get statsEncouragement =>
      'Gut gemacht! An Tagen mit 3+ Mahlzeiten ist deine Energie spürbar besser. 🚀';

  @override
  String get energyHigh => '⚡ High';

  @override
  String get energyMed => '🔋 Med';

  @override
  String get energyLow => '🪫 Low';

  @override
  String get tookMeds => 'Medikamente genommen?';

  @override
  String get loggedLate => 'Nachgetragen';

  @override
  String timeAt(String time) {
    return 'um $time Uhr';
  }

  @override
  String get noMealsToday => 'Noch keine Mahlzeiten heute';

  @override
  String get pressAddToStart => 'Drücke auf Hinzufügen, um zu beginnen!';

  @override
  String get breakfastReminderTitle => 'Frühstückszeit! 🍳';

  @override
  String get breakfastReminderBody =>
      'Hast du heute schon gefrühstückt? Logge deine Mahlzeit.';

  @override
  String get lunchReminderTitle => 'Mittagessen! 🥗';

  @override
  String get lunchReminderBody => 'Vergiss nicht dein Mittagessen zu loggen.';

  @override
  String get dinnerReminderTitle => 'Abendessen! 🍽️';

  @override
  String get dinnerReminderBody => 'Zeit für dein Abendessen. Denk ans Loggen!';

  @override
  String get testNotificationTitle => 'Test Benachrichtigung 🚀';

  @override
  String get testNotificationBody =>
      'Wenn du das siehst, funktionieren die Benachrichtigungen!';

  @override
  String get noMealsDesc => 'Tippe auf Hinzufügen, um deinen Tag zu tracken.';

  @override
  String get simpleMode => 'Simple';

  @override
  String mealAdded(String mealType) {
    return '$mealType hinzugefügt ✅';
  }

  @override
  String get themeMode => 'Erscheinungsbild';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get reminders => 'Erinnerungen (Frühstück, Mittag, Abend)';

  @override
  String get simpleModeDesc => 'Einfacher Modus (Ohne Zeit/Energie abzufragen)';

  @override
  String get showStats => 'Wochen-Statistik auf Startseite anzeigen';

  @override
  String get addSafeFood => 'Safe Food hinzufügen';

  @override
  String get newSafeFood => 'Neues Safe Food';

  @override
  String get save => 'Speichern';

  @override
  String get deleteData => 'Alle Daten löschen';

  @override
  String get deleteDataWarning =>
      'Dies löscht alle deine geloggten Mahlzeiten. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get dataDeleted => 'Alle Daten wurden gelöscht';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get todayMealsTitle => 'Heutige Mahlzeiten';

  @override
  String exportFailed(String error) {
    return '❌ Export fehlgeschlagen: $error';
  }

  @override
  String get importDataConfirmTitle => 'Daten importieren?';

  @override
  String get importDataConfirmDesc =>
      'Dies wird ALLE bestehenden Mahlzeiten ersetzen.\nSicher fortfahren?';

  @override
  String get importBtn => 'Importieren';

  @override
  String get importSuccess => '✅ Daten erfolgreich importiert';

  @override
  String importFailed(String error) {
    return '❌ Import fehlgeschlagen: $error';
  }

  @override
  String get clearDataConfirmTitle => 'Alle Daten löschen?';

  @override
  String get clearDataConfirmDesc =>
      'Diese Aktion löscht ALLE gespeicherten Mahlzeiten und kann nicht rückgängig gemacht werden.\n\nSicher fortfahren?';

  @override
  String get clearDataBtn => 'Löschen';

  @override
  String get clearDataSuccess => '✅ Alle Daten wurden gelöscht';

  @override
  String clearDataFailed(String error) {
    return '❌ Fehler beim Löschen: $error';
  }

  @override
  String get simpleModeDescSub => 'Nur ein Button, keine Auswahl';

  @override
  String get renameMeals => 'Mahlzeiten umbenennen';

  @override
  String get renameMealsDesc => 'Eigene Namen und Emojis für Buttons festlegen';

  @override
  String get remindersDesc => 'Sanfte Erinnerungen aktivieren';

  @override
  String get testNotification => 'Benachrichtigung testen';

  @override
  String get testNotificationDesc => 'Sende eine sofortige Test-Nachricht';

  @override
  String get testNotificationSent => 'Test-Benachrichtigung gesendet!';

  @override
  String get medicationTracker => 'Medikamenten-Tracker';

  @override
  String get medicationTrackerDesc =>
      'Frage beim Essen-Loggen nach Medikamenten';

  @override
  String get weeklyStatsDesc => 'Streak-Übersicht auf Startseite anzeigen';

  @override
  String get exportPdfDesc => 'Tagebuch für den Arzt/Therapeuten';

  @override
  String get exportCsvName => 'Als CSV (Excel) exportieren';

  @override
  String get exportCsvDesc => 'Rohdaten als Tabelle';

  @override
  String get dataManagement => 'Datenverwaltung';

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get exportDataDesc => 'Sicherheitskopie als JSON erstellen';

  @override
  String get importData => 'Daten importieren';

  @override
  String get importDataDesc => 'Backup-Datei wiederherstellen';

  @override
  String get clearDataWarn => 'Vorsicht: Diese Aktion ist unwiderruflich';

  @override
  String get darkModeDesc => 'Dunkles Design aktivieren';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get privacyDesc => 'Alle Daten werden lokal gespeichert';

  @override
  String get privacyDialogText =>
      'Alle Daten sind lokal auf Ihrem Gerät gespeichert. Es gehen keine Informationen an einen Server.\n\nBackups werden nur mit Ihrer expliziten Zustimmung erstellt.';

  @override
  String get ok => 'OK';

  @override
  String get developer => 'Entwickler';

  @override
  String get githubRepo => 'GitHub Repository';

  @override
  String get githubRepoDesc => 'Quellcode ansehen & beitragen';

  @override
  String get devWebsite => 'Entwickler Webseite';

  @override
  String get devWebsiteDesc => 'Mehr über den Autor erfahren';

  @override
  String get linkError => 'Konnte Link nicht öffnen';

  @override
  String get aboutApp => 'Über MealBox';

  @override
  String get historyTitle => 'Mahlzeiten-Historie 📅';

  @override
  String get mealDeleted => 'Mahlzeit gelöscht';

  @override
  String get noMealsOnDay => 'Keine Mahlzeiten an diesem Tag';

  @override
  String totalMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mahlzeiten',
      one: 'Mahlzeit',
    );
    return 'Gesamt: $count $_temp0';
  }

  @override
  String get safeFoodsTitle => 'Safe Foods 🛟';

  @override
  String get noSafeFoods => 'Noch keine Safe Foods hinzugefügt.';

  @override
  String get safeFoodName => 'Name des Lebensmittels';

  @override
  String get safeFoodAction => 'Was möchtest du tun?';

  @override
  String get logFood => 'Loggen (Low Energy)';

  @override
  String get time => 'Uhrzeit';

  @override
  String get energyLevelText => 'Energie Level';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get weekPrefix => 'Woche vom';

  @override
  String get whatDidYouEat => 'Was hast du gegessen? 🍽️';

  @override
  String get selectTime => 'Zeit auswählen';

  @override
  String get resetToNow => 'Auf jetzt zurücksetzen';

  @override
  String get loggedLateHint => 'Wird als nachgetragene Mahlzeit gespeichert';

  @override
  String get currentTimeHint => 'Ohne Auswahl wird die aktuelle Zeit verwendet';

  @override
  String get energyLevelOpt => 'Energie-Level (optional):';

  @override
  String get addPhoto => 'Foto hinzufügen';

  @override
  String mealNumber(int number) {
    return 'Mahlzeit $number';
  }
}
