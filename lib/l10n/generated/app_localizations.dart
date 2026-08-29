import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'MealBox 🍱'**
  String get appTitle;

  /// No description provided for @breakfast.
  ///
  /// In de, this message translates to:
  /// **'Frühstück'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In de, this message translates to:
  /// **'Mittagessen'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In de, this message translates to:
  /// **'Abendessen'**
  String get dinner;

  /// No description provided for @snack.
  ///
  /// In de, this message translates to:
  /// **'Snack'**
  String get snack;

  /// No description provided for @meal.
  ///
  /// In de, this message translates to:
  /// **'Mahlzeit'**
  String get meal;

  /// No description provided for @addMeal.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get addMeal;

  /// No description provided for @addMealTitle.
  ///
  /// In de, this message translates to:
  /// **'Mahlzeit hinzufügen'**
  String get addMealTitle;

  /// No description provided for @history.
  ///
  /// In de, this message translates to:
  /// **'Historie'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settings;

  /// No description provided for @safeFoods.
  ///
  /// In de, this message translates to:
  /// **'Safe Foods'**
  String get safeFoods;

  /// No description provided for @safeFoodsDesc.
  ///
  /// In de, this message translates to:
  /// **'Füge Lebensmittel hinzu, die du immer essen kannst, wenn gar nichts anderes geht.'**
  String get safeFoodsDesc;

  /// No description provided for @therapyExport.
  ///
  /// In de, this message translates to:
  /// **'Therapie-Export'**
  String get therapyExport;

  /// No description provided for @exportPdf.
  ///
  /// In de, this message translates to:
  /// **'Als PDF exportieren'**
  String get exportPdf;

  /// No description provided for @exportCsv.
  ///
  /// In de, this message translates to:
  /// **'Als CSV exportieren'**
  String get exportCsv;

  /// No description provided for @exportSuccess.
  ///
  /// In de, this message translates to:
  /// **'✅ Daten erfolgreich exportiert'**
  String get exportSuccess;

  /// No description provided for @noEnergy.
  ///
  /// In de, this message translates to:
  /// **'Gar keine Energie?'**
  String get noEnergy;

  /// No description provided for @sosTitle.
  ///
  /// In de, this message translates to:
  /// **'SOS 🆘'**
  String get sosTitle;

  /// No description provided for @sosMessageFallback.
  ///
  /// In de, this message translates to:
  /// **'Trink ein Glas Wasser, iss einen Löffel Erdnussbutter oder beiß in einen Apfel. Hauptsache etwas!'**
  String get sosMessageFallback;

  /// No description provided for @sosMessagePrefix.
  ///
  /// In de, this message translates to:
  /// **'Gar keine Energie? Versuch doch mal das hier:\n\n'**
  String get sosMessagePrefix;

  /// No description provided for @cancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancel;

  /// No description provided for @logNow.
  ///
  /// In de, this message translates to:
  /// **'Jetzt loggen!'**
  String get logNow;

  /// No description provided for @delete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get delete;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In de, this message translates to:
  /// **'Löschen bestätigen'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du {mealType} von {time} wirklich löschen?'**
  String deleteConfirmMessage(String mealType, String time);

  /// No description provided for @todayEaten.
  ///
  /// In de, this message translates to:
  /// **'Heute gegessen: {count} {count, plural, =1{Mahlzeit} other{Mahlzeiten}}'**
  String todayEaten(int count);

  /// No description provided for @water.
  ///
  /// In de, this message translates to:
  /// **'Wasser: {count} Glas'**
  String water(int count);

  /// No description provided for @weeklyStats.
  ///
  /// In de, this message translates to:
  /// **'Wochen-Statistik'**
  String get weeklyStats;

  /// No description provided for @streakDays.
  ///
  /// In de, this message translates to:
  /// **'{count} Tage'**
  String streakDays(int count);

  /// No description provided for @statsEncouragement.
  ///
  /// In de, this message translates to:
  /// **'Gut gemacht! An Tagen mit 3+ Mahlzeiten ist deine Energie spürbar besser. 🚀'**
  String get statsEncouragement;

  /// No description provided for @energyHigh.
  ///
  /// In de, this message translates to:
  /// **'⚡ High'**
  String get energyHigh;

  /// No description provided for @energyMed.
  ///
  /// In de, this message translates to:
  /// **'🔋 Med'**
  String get energyMed;

  /// No description provided for @energyLow.
  ///
  /// In de, this message translates to:
  /// **'🪫 Low'**
  String get energyLow;

  /// No description provided for @tookMeds.
  ///
  /// In de, this message translates to:
  /// **'Medikamente genommen?'**
  String get tookMeds;

  /// No description provided for @loggedLate.
  ///
  /// In de, this message translates to:
  /// **'Nachgetragen'**
  String get loggedLate;

  /// No description provided for @timeAt.
  ///
  /// In de, this message translates to:
  /// **'um {time} Uhr'**
  String timeAt(String time);

  /// No description provided for @noMealsToday.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Mahlzeiten heute'**
  String get noMealsToday;

  /// No description provided for @pressAddToStart.
  ///
  /// In de, this message translates to:
  /// **'Drücke auf Hinzufügen, um zu beginnen!'**
  String get pressAddToStart;

  /// No description provided for @breakfastReminderTitle.
  ///
  /// In de, this message translates to:
  /// **'Frühstückszeit! 🍳'**
  String get breakfastReminderTitle;

  /// No description provided for @breakfastReminderBody.
  ///
  /// In de, this message translates to:
  /// **'Hast du heute schon gefrühstückt? Logge deine Mahlzeit.'**
  String get breakfastReminderBody;

  /// No description provided for @lunchReminderTitle.
  ///
  /// In de, this message translates to:
  /// **'Mittagessen! 🥗'**
  String get lunchReminderTitle;

  /// No description provided for @lunchReminderBody.
  ///
  /// In de, this message translates to:
  /// **'Vergiss nicht dein Mittagessen zu loggen.'**
  String get lunchReminderBody;

  /// No description provided for @dinnerReminderTitle.
  ///
  /// In de, this message translates to:
  /// **'Abendessen! 🍽️'**
  String get dinnerReminderTitle;

  /// No description provided for @dinnerReminderBody.
  ///
  /// In de, this message translates to:
  /// **'Zeit für dein Abendessen. Denk ans Loggen!'**
  String get dinnerReminderBody;

  /// No description provided for @testNotificationTitle.
  ///
  /// In de, this message translates to:
  /// **'Test Benachrichtigung 🚀'**
  String get testNotificationTitle;

  /// No description provided for @testNotificationBody.
  ///
  /// In de, this message translates to:
  /// **'Wenn du das siehst, funktionieren die Benachrichtigungen!'**
  String get testNotificationBody;

  /// No description provided for @noMealsDesc.
  ///
  /// In de, this message translates to:
  /// **'Tippe auf Hinzufügen, um deinen Tag zu tracken.'**
  String get noMealsDesc;

  /// No description provided for @simpleMode.
  ///
  /// In de, this message translates to:
  /// **'Simple'**
  String get simpleMode;

  /// No description provided for @mealAdded.
  ///
  /// In de, this message translates to:
  /// **'{mealType} hinzugefügt ✅'**
  String mealAdded(String mealType);

  /// No description provided for @themeMode.
  ///
  /// In de, this message translates to:
  /// **'Erscheinungsbild'**
  String get themeMode;

  /// No description provided for @themeSystem.
  ///
  /// In de, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In de, this message translates to:
  /// **'Hell'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In de, this message translates to:
  /// **'Dunkel'**
  String get themeDark;

  /// No description provided for @notifications.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen'**
  String get notifications;

  /// No description provided for @reminders.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen (Frühstück, Mittag, Abend)'**
  String get reminders;

  /// No description provided for @simpleModeDesc.
  ///
  /// In de, this message translates to:
  /// **'Einfacher Modus (Ohne Zeit/Energie abzufragen)'**
  String get simpleModeDesc;

  /// No description provided for @showStats.
  ///
  /// In de, this message translates to:
  /// **'Wochen-Statistik auf Startseite anzeigen'**
  String get showStats;

  /// No description provided for @addSafeFood.
  ///
  /// In de, this message translates to:
  /// **'Safe Food hinzufügen'**
  String get addSafeFood;

  /// No description provided for @newSafeFood.
  ///
  /// In de, this message translates to:
  /// **'Neues Safe Food'**
  String get newSafeFood;

  /// No description provided for @save.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get save;

  /// No description provided for @deleteData.
  ///
  /// In de, this message translates to:
  /// **'Alle Daten löschen'**
  String get deleteData;

  /// No description provided for @deleteDataWarning.
  ///
  /// In de, this message translates to:
  /// **'Dies löscht alle deine geloggten Mahlzeiten. Dies kann nicht rückgängig gemacht werden.'**
  String get deleteDataWarning;

  /// No description provided for @dataDeleted.
  ///
  /// In de, this message translates to:
  /// **'Alle Daten wurden gelöscht'**
  String get dataDeleted;

  /// No description provided for @appVersion.
  ///
  /// In de, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @todayMealsTitle.
  ///
  /// In de, this message translates to:
  /// **'Heutige Mahlzeiten'**
  String get todayMealsTitle;

  /// No description provided for @exportFailed.
  ///
  /// In de, this message translates to:
  /// **'❌ Export fehlgeschlagen: {error}'**
  String exportFailed(String error);

  /// No description provided for @importDataConfirmTitle.
  ///
  /// In de, this message translates to:
  /// **'Daten importieren?'**
  String get importDataConfirmTitle;

  /// No description provided for @importDataConfirmDesc.
  ///
  /// In de, this message translates to:
  /// **'Dies wird ALLE bestehenden Mahlzeiten ersetzen.\nSicher fortfahren?'**
  String get importDataConfirmDesc;

  /// No description provided for @importBtn.
  ///
  /// In de, this message translates to:
  /// **'Importieren'**
  String get importBtn;

  /// No description provided for @importSuccess.
  ///
  /// In de, this message translates to:
  /// **'✅ Daten erfolgreich importiert'**
  String get importSuccess;

  /// No description provided for @importFailed.
  ///
  /// In de, this message translates to:
  /// **'❌ Import fehlgeschlagen: {error}'**
  String importFailed(String error);

  /// No description provided for @clearDataConfirmTitle.
  ///
  /// In de, this message translates to:
  /// **'Alle Daten löschen?'**
  String get clearDataConfirmTitle;

  /// No description provided for @clearDataConfirmDesc.
  ///
  /// In de, this message translates to:
  /// **'Diese Aktion löscht ALLE gespeicherten Mahlzeiten und kann nicht rückgängig gemacht werden.\n\nSicher fortfahren?'**
  String get clearDataConfirmDesc;

  /// No description provided for @clearDataBtn.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get clearDataBtn;

  /// No description provided for @clearDataSuccess.
  ///
  /// In de, this message translates to:
  /// **'✅ Alle Daten wurden gelöscht'**
  String get clearDataSuccess;

  /// No description provided for @clearDataFailed.
  ///
  /// In de, this message translates to:
  /// **'❌ Fehler beim Löschen: {error}'**
  String clearDataFailed(String error);

  /// No description provided for @simpleModeDescSub.
  ///
  /// In de, this message translates to:
  /// **'Nur ein Button, keine Auswahl'**
  String get simpleModeDescSub;

  /// No description provided for @renameMeals.
  ///
  /// In de, this message translates to:
  /// **'Mahlzeiten umbenennen'**
  String get renameMeals;

  /// No description provided for @renameMealsDesc.
  ///
  /// In de, this message translates to:
  /// **'Eigene Namen und Emojis für Buttons festlegen'**
  String get renameMealsDesc;

  /// No description provided for @remindersDesc.
  ///
  /// In de, this message translates to:
  /// **'Sanfte Erinnerungen aktivieren'**
  String get remindersDesc;

  /// No description provided for @testNotification.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigung testen'**
  String get testNotification;

  /// No description provided for @testNotificationDesc.
  ///
  /// In de, this message translates to:
  /// **'Sende eine sofortige Test-Nachricht'**
  String get testNotificationDesc;

  /// No description provided for @testNotificationSent.
  ///
  /// In de, this message translates to:
  /// **'Test-Benachrichtigung gesendet!'**
  String get testNotificationSent;

  /// No description provided for @medicationTracker.
  ///
  /// In de, this message translates to:
  /// **'Medikamenten-Tracker'**
  String get medicationTracker;

  /// No description provided for @medicationTrackerDesc.
  ///
  /// In de, this message translates to:
  /// **'Frage beim Essen-Loggen nach Medikamenten'**
  String get medicationTrackerDesc;

  /// No description provided for @weeklyStatsDesc.
  ///
  /// In de, this message translates to:
  /// **'Streak-Übersicht auf Startseite anzeigen'**
  String get weeklyStatsDesc;

  /// No description provided for @exportPdfDesc.
  ///
  /// In de, this message translates to:
  /// **'Tagebuch für den Arzt/Therapeuten'**
  String get exportPdfDesc;

  /// No description provided for @exportCsvName.
  ///
  /// In de, this message translates to:
  /// **'Als CSV (Excel) exportieren'**
  String get exportCsvName;

  /// No description provided for @exportCsvDesc.
  ///
  /// In de, this message translates to:
  /// **'Rohdaten als Tabelle'**
  String get exportCsvDesc;

  /// No description provided for @dataManagement.
  ///
  /// In de, this message translates to:
  /// **'Datenverwaltung'**
  String get dataManagement;

  /// No description provided for @exportData.
  ///
  /// In de, this message translates to:
  /// **'Daten exportieren'**
  String get exportData;

  /// No description provided for @exportDataDesc.
  ///
  /// In de, this message translates to:
  /// **'Sicherheitskopie als JSON erstellen'**
  String get exportDataDesc;

  /// No description provided for @importData.
  ///
  /// In de, this message translates to:
  /// **'Daten importieren'**
  String get importData;

  /// No description provided for @importDataDesc.
  ///
  /// In de, this message translates to:
  /// **'Backup-Datei wiederherstellen'**
  String get importDataDesc;

  /// No description provided for @clearDataWarn.
  ///
  /// In de, this message translates to:
  /// **'Vorsicht: Diese Aktion ist unwiderruflich'**
  String get clearDataWarn;

  /// No description provided for @darkModeDesc.
  ///
  /// In de, this message translates to:
  /// **'Dunkles Design aktivieren'**
  String get darkModeDesc;

  /// No description provided for @privacy.
  ///
  /// In de, this message translates to:
  /// **'Datenschutz'**
  String get privacy;

  /// No description provided for @privacyDesc.
  ///
  /// In de, this message translates to:
  /// **'Alle Daten werden lokal gespeichert'**
  String get privacyDesc;

  /// No description provided for @privacyDialogText.
  ///
  /// In de, this message translates to:
  /// **'Alle Daten sind lokal auf Ihrem Gerät gespeichert. Es gehen keine Informationen an einen Server.\n\nBackups werden nur mit Ihrer expliziten Zustimmung erstellt.'**
  String get privacyDialogText;

  /// No description provided for @ok.
  ///
  /// In de, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @developer.
  ///
  /// In de, this message translates to:
  /// **'Entwickler'**
  String get developer;

  /// No description provided for @githubRepo.
  ///
  /// In de, this message translates to:
  /// **'GitHub Repository'**
  String get githubRepo;

  /// No description provided for @githubRepoDesc.
  ///
  /// In de, this message translates to:
  /// **'Quellcode ansehen & beitragen'**
  String get githubRepoDesc;

  /// No description provided for @devWebsite.
  ///
  /// In de, this message translates to:
  /// **'Entwickler Webseite'**
  String get devWebsite;

  /// No description provided for @devWebsiteDesc.
  ///
  /// In de, this message translates to:
  /// **'Mehr über den Autor erfahren'**
  String get devWebsiteDesc;

  /// No description provided for @linkError.
  ///
  /// In de, this message translates to:
  /// **'Konnte Link nicht öffnen'**
  String get linkError;

  /// No description provided for @aboutApp.
  ///
  /// In de, this message translates to:
  /// **'Über MealBox'**
  String get aboutApp;

  /// No description provided for @historyTitle.
  ///
  /// In de, this message translates to:
  /// **'Mahlzeiten-Historie 📅'**
  String get historyTitle;

  /// No description provided for @mealDeleted.
  ///
  /// In de, this message translates to:
  /// **'Mahlzeit gelöscht'**
  String get mealDeleted;

  /// No description provided for @noMealsOnDay.
  ///
  /// In de, this message translates to:
  /// **'Keine Mahlzeiten an diesem Tag'**
  String get noMealsOnDay;

  /// No description provided for @totalMeals.
  ///
  /// In de, this message translates to:
  /// **'Gesamt: {count} {count, plural, =1{Mahlzeit} other{Mahlzeiten}}'**
  String totalMeals(int count);

  /// No description provided for @safeFoodsTitle.
  ///
  /// In de, this message translates to:
  /// **'Safe Foods 🛟'**
  String get safeFoodsTitle;

  /// No description provided for @noSafeFoods.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Safe Foods hinzugefügt.'**
  String get noSafeFoods;

  /// No description provided for @safeFoodName.
  ///
  /// In de, this message translates to:
  /// **'Name des Lebensmittels'**
  String get safeFoodName;

  /// No description provided for @safeFoodAction.
  ///
  /// In de, this message translates to:
  /// **'Was möchtest du tun?'**
  String get safeFoodAction;

  /// No description provided for @logFood.
  ///
  /// In de, this message translates to:
  /// **'Loggen (Low Energy)'**
  String get logFood;

  /// No description provided for @time.
  ///
  /// In de, this message translates to:
  /// **'Uhrzeit'**
  String get time;

  /// No description provided for @energyLevelText.
  ///
  /// In de, this message translates to:
  /// **'Energie Level'**
  String get energyLevelText;

  /// No description provided for @unknown.
  ///
  /// In de, this message translates to:
  /// **'Unbekannt'**
  String get unknown;

  /// No description provided for @weekPrefix.
  ///
  /// In de, this message translates to:
  /// **'Woche vom'**
  String get weekPrefix;

  /// No description provided for @whatDidYouEat.
  ///
  /// In de, this message translates to:
  /// **'Was hast du gegessen? 🍽️'**
  String get whatDidYouEat;

  /// No description provided for @selectTime.
  ///
  /// In de, this message translates to:
  /// **'Zeit auswählen'**
  String get selectTime;

  /// No description provided for @resetToNow.
  ///
  /// In de, this message translates to:
  /// **'Auf jetzt zurücksetzen'**
  String get resetToNow;

  /// No description provided for @loggedLateHint.
  ///
  /// In de, this message translates to:
  /// **'Wird als nachgetragene Mahlzeit gespeichert'**
  String get loggedLateHint;

  /// No description provided for @currentTimeHint.
  ///
  /// In de, this message translates to:
  /// **'Ohne Auswahl wird die aktuelle Zeit verwendet'**
  String get currentTimeHint;

  /// No description provided for @energyLevelOpt.
  ///
  /// In de, this message translates to:
  /// **'Energie-Level (optional):'**
  String get energyLevelOpt;

  /// No description provided for @addPhoto.
  ///
  /// In de, this message translates to:
  /// **'Foto hinzufügen'**
  String get addPhoto;

  /// No description provided for @mealNumber.
  ///
  /// In de, this message translates to:
  /// **'Mahlzeit {number}'**
  String mealNumber(int number);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
