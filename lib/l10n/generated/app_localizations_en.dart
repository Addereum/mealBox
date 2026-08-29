// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MealBox 🍱';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get snack => 'Snack';

  @override
  String get meal => 'Meal';

  @override
  String get addMeal => 'Add';

  @override
  String get addMealTitle => 'Add Meal';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get safeFoods => 'Safe Foods';

  @override
  String get safeFoodsDesc =>
      'Add foods that you can always eat when nothing else works.';

  @override
  String get therapyExport => 'Therapy Export';

  @override
  String get exportPdf => 'Export as PDF';

  @override
  String get exportCsv => 'Export as CSV';

  @override
  String get exportSuccess => '✅ Data exported successfully';

  @override
  String get noEnergy => 'No energy at all?';

  @override
  String get sosTitle => 'SOS 🆘';

  @override
  String get sosMessageFallback =>
      'Drink a glass of water, eat a spoonful of peanut butter, or take a bite of an apple. Just something!';

  @override
  String get sosMessagePrefix => 'No energy at all? Try this:\n\n';

  @override
  String get cancel => 'Cancel';

  @override
  String get logNow => 'Log now!';

  @override
  String get delete => 'Delete';

  @override
  String get deleteConfirmTitle => 'Confirm deletion';

  @override
  String deleteConfirmMessage(String mealType, String time) {
    return 'Do you really want to delete $mealType from $time?';
  }

  @override
  String todayEaten(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'meals',
      one: 'meal',
    );
    return 'Eaten today: $count $_temp0';
  }

  @override
  String water(int count) {
    return 'Water: $count glass';
  }

  @override
  String get weeklyStats => 'Weekly Stats';

  @override
  String streakDays(int count) {
    return '$count days';
  }

  @override
  String get statsEncouragement =>
      'Great job! On days with 3+ meals, your energy is noticeably better. 🚀';

  @override
  String get energyHigh => '⚡ High';

  @override
  String get energyMed => '🔋 Med';

  @override
  String get energyLow => '🪫 Low';

  @override
  String get tookMeds => 'Took medication?';

  @override
  String get loggedLate => 'Logged late';

  @override
  String timeAt(String time) {
    return 'at $time';
  }

  @override
  String get noMealsToday => 'No meals today yet';

  @override
  String get pressAddToStart => 'Press Add to get started!';

  @override
  String get breakfastReminderTitle => 'Breakfast time! 🍳';

  @override
  String get breakfastReminderBody =>
      'Have you had breakfast yet? Log your meal.';

  @override
  String get lunchReminderTitle => 'Lunch time! 🥗';

  @override
  String get lunchReminderBody => 'Don\'t forget to log your lunch.';

  @override
  String get dinnerReminderTitle => 'Dinner time! 🍽️';

  @override
  String get dinnerReminderBody => 'Time for dinner. Remember to log!';

  @override
  String get testNotificationTitle => 'Test notification 🚀';

  @override
  String get testNotificationBody =>
      'If you see this, notifications are working!';

  @override
  String get noMealsDesc => 'Tap add to start tracking your day.';

  @override
  String get simpleMode => 'Simple';

  @override
  String mealAdded(String mealType) {
    return '$mealType added ✅';
  }

  @override
  String get themeMode => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get notifications => 'Notifications';

  @override
  String get reminders => 'Reminders (Breakfast, Lunch, Dinner)';

  @override
  String get simpleModeDesc => 'Simple mode (Skip time/energy prompts)';

  @override
  String get showStats => 'Show weekly stats on home screen';

  @override
  String get addSafeFood => 'Add Safe Food';

  @override
  String get newSafeFood => 'New Safe Food';

  @override
  String get save => 'Save';

  @override
  String get deleteData => 'Delete all data';

  @override
  String get deleteDataWarning =>
      'This deletes all your logged meals. This cannot be undone.';

  @override
  String get dataDeleted => 'All data has been deleted';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get todayMealsTitle => 'Today\'s Meals';

  @override
  String exportFailed(String error) {
    return '❌ Export failed: $error';
  }

  @override
  String get importDataConfirmTitle => 'Import data?';

  @override
  String get importDataConfirmDesc =>
      'This will replace ALL existing meals.\nAre you sure you want to continue?';

  @override
  String get importBtn => 'Import';

  @override
  String get importSuccess => '✅ Data imported successfully';

  @override
  String importFailed(String error) {
    return '❌ Import failed: $error';
  }

  @override
  String get clearDataConfirmTitle => 'Clear all data?';

  @override
  String get clearDataConfirmDesc =>
      'This action deletes ALL saved meals and cannot be undone.\n\nAre you sure you want to continue?';

  @override
  String get clearDataBtn => 'Clear';

  @override
  String get clearDataSuccess => '✅ All data has been cleared';

  @override
  String clearDataFailed(String error) {
    return '❌ Error clearing data: $error';
  }

  @override
  String get simpleModeDescSub => 'Just one button, no options';

  @override
  String get renameMeals => 'Rename meals';

  @override
  String get renameMealsDesc => 'Set custom names and emojis for buttons';

  @override
  String get remindersDesc => 'Enable gentle reminders';

  @override
  String get testNotification => 'Test notification';

  @override
  String get testNotificationDesc => 'Send an immediate test message';

  @override
  String get testNotificationSent => 'Test notification sent!';

  @override
  String get medicationTracker => 'Medication Tracker';

  @override
  String get medicationTrackerDesc => 'Ask for medications when logging a meal';

  @override
  String get weeklyStatsDesc => 'Show streak overview on home screen';

  @override
  String get exportPdfDesc => 'Diary for doctor/therapist';

  @override
  String get exportCsvName => 'Export as CSV (Excel)';

  @override
  String get exportCsvDesc => 'Raw data as table';

  @override
  String get dataManagement => 'Data management';

  @override
  String get exportData => 'Export data';

  @override
  String get exportDataDesc => 'Create a JSON backup';

  @override
  String get importData => 'Import data';

  @override
  String get importDataDesc => 'Restore from backup file';

  @override
  String get clearDataWarn => 'Warning: This action cannot be undone';

  @override
  String get darkModeDesc => 'Enable dark theme';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyDesc => 'All data is stored locally';

  @override
  String get privacyDialogText =>
      'All data is stored locally on your device. No information is sent to a server.\n\nBackups are only created with your explicit consent.';

  @override
  String get ok => 'OK';

  @override
  String get developer => 'Developer';

  @override
  String get githubRepo => 'GitHub Repository';

  @override
  String get githubRepoDesc => 'View source code & contribute';

  @override
  String get devWebsite => 'Developer Website';

  @override
  String get devWebsiteDesc => 'Learn more about the author';

  @override
  String get linkError => 'Could not open link';

  @override
  String get aboutApp => 'About MealBox';

  @override
  String get historyTitle => 'Meal History 📅';

  @override
  String get mealDeleted => 'Meal deleted';

  @override
  String get noMealsOnDay => 'No meals on this day';

  @override
  String totalMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'meals',
      one: 'meal',
    );
    return 'Total: $count $_temp0';
  }

  @override
  String get safeFoodsTitle => 'Safe Foods 🛟';

  @override
  String get noSafeFoods => 'No safe foods added yet.';

  @override
  String get safeFoodName => 'Food name';

  @override
  String get safeFoodAction => 'What do you want to do?';

  @override
  String get logFood => 'Log (Low Energy)';

  @override
  String get time => 'Time';

  @override
  String get energyLevelText => 'Energy Level';

  @override
  String get unknown => 'Unknown';

  @override
  String get weekPrefix => 'Week of';

  @override
  String get whatDidYouEat => 'What did you eat? 🍽️';

  @override
  String get selectTime => 'Select time';

  @override
  String get resetToNow => 'Reset to now';

  @override
  String get loggedLateHint => 'Will be saved as logged late';

  @override
  String get currentTimeHint => 'Without selection, current time is used';

  @override
  String get energyLevelOpt => 'Energy level (optional):';

  @override
  String get addPhoto => 'Add photo';

  @override
  String mealNumber(int number) {
    return 'Meal $number';
  }
}
