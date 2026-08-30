// settings_screen.dart - AM ANFANG
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import '../services/settings_service.dart';
import '../services/meal_service.dart';
import '../services/export_service.dart';
import '../services/notification_service.dart';
import 'package:mealbox/l10n/generated/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'meal_names_screen.dart';
import '../models/meal.dart';
import '../constants.dart';
import 'home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsService _settingsService;
  final MealService _mealService = MealService();
  bool _simpleMode = false;
  bool _notifications = true;
  bool _showStats = true;
  bool _trackMedications = false;
  bool _isExporting = false;
  bool _isImporting = false;
  String _appVersion = '1.0.0';
  
  @override
  void initState() {
    super.initState();
    _settingsService = SettingsService.instance;
    _loadSettings();

    _settingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (_settingsService.simpleMode != _simpleMode) {
      setState(() {
        _simpleMode = _settingsService.simpleMode;
      });
    }
    if (_settingsService.notifications != _notifications) {
      setState(() {
        _notifications = _settingsService.notifications;
      });
    }
    if (_settingsService.showStats != _showStats) {
      setState(() {
        _showStats = _settingsService.showStats;
      });
    }
    if (_settingsService.trackMedications != _trackMedications) {
      setState(() {
        _trackMedications = _settingsService.trackMedications;
      });
    }
  }

  Future<void> _loadSettings() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _simpleMode = _settingsService.simpleMode;
      _notifications = _settingsService.notifications;
      _showStats = _settingsService.showStats;
      _trackMedications = _settingsService.trackMedications;
      _appVersion = '${packageInfo.version} "${AppConstants.appCodename}"';
    });
  }

  Future<void> _toggleSimpleMode(bool value) async {
    await _settingsService.setSimpleMode(value);
  }

  Future<void> _exportData() async {
    setState(() => _isExporting = true);

    try {
      // 1. Sammle alle Mahlzeiten und Wasser
      final allMeals = await _mealService.getAllMeals();
      final allWater = await _mealService.getAllWaterData();

      // 2. Konvertiere zu JSON
      final exportData = {
        'app': 'MealBox',
        'version': '1.1',
        'exportDate': DateTime.now().toIso8601String(),
        'simpleMode': _simpleMode,
        'safeFoods': _settingsService.safeFoods,
        'mealNames': _settingsService.mealNames,
        'waterData': allWater,
        'meals': allMeals.entries.map((entry) {
          return {
            'date': entry.key,
            'meals': entry.value.map((meal) => meal.toMap()).toList()
          };
        }).toList()
      };

      final jsonData = jsonEncode(exportData);

      // 3. Speichere lokal
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/mealbox_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonData);

      // 4. Teile/Exportiere
      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'MealBox Backup - ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())}',
        subject: 'MealBox Daten Export',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.exportSuccess),
          backgroundColor: Colors.teal,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.exportFailed(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _importData() async {
    setState(() => _isImporting = true);

    try {
      // 1. Datei auswählen
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        setState(() => _isImporting = false);
        return;
      }

      final file = File(result.files.first.path!);
      final jsonString = await file.readAsString();
      final importData = jsonDecode(jsonString);

      // 2. Validierung
      if (importData['app'] != 'MealBox') {
        throw Exception('Ungültige Backup-Datei');
      }

      // 3. Bestätigungs-Dialog
      final shouldImport = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.importDataConfirmTitle),
          content: Text(AppLocalizations.of(context)!.importDataConfirmDesc),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.importBtn, style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (shouldImport != true) {
        setState(() => _isImporting = false);
        return;
      }

      // 4. WICHTIG: MealService verwenden statt direkt Hive
      final mealService = Provider.of<MealService>(context, listen: false);

      // Alte Daten löschen
      await mealService.clearAllData();

      // Neue Daten importieren (Einstellungen)
      if (importData['safeFoods'] != null) {
        await _settingsService
            .setSafeFoods((importData['safeFoods'] as List).cast<String>());
      }
      if (importData['mealNames'] != null) {
        await _settingsService
            .setMealNames((importData['mealNames'] as List).cast<String>());
      }
      if (importData['waterData'] != null) {
        await mealService.importWaterData(
            Map<String, dynamic>.from(importData['waterData']));
      }

      // Neue Daten importieren (Mahlzeiten)
      if (importData['meals'] != null) {
        final List<Meal> importedMeals = [];

        for (final dayData in importData['meals']) {
          final dateKey = dayData['date'];
          final meals = dayData['meals'] as List;

          for (final mealMap in meals) {
            try {
              final meal = Meal.fromMap(Map<String, dynamic>.from(mealMap));
              importedMeals.add(meal);
            } catch (e) {
              print('Fehler beim Parsen einer Mahlzeit: $e');
            }
          }
        }

        // Alle importierten Mahlzeiten hinzufügen
        for (final meal in importedMeals) {
          await mealService.addMeal(meal.type, customTime: meal.dateTime);
        }

        print('✅ ${importedMeals.length} Mahlzeiten importiert');
      }

      // 5. Settings importieren
      if (importData['simpleMode'] != null) {
        await _settingsService.setSimpleMode(importData['simpleMode']);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.importSuccess),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 3),
        ),
      );

      // 6. WICHTIG: Zurück zur Startseite mit Navigation, die den State resettet
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.importFailed(e.toString())),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() => _isImporting = false);
    }
  }

  Future<void> _clearAllData() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearDataConfirmTitle),
        content: Text(AppLocalizations.of(context)!.clearDataConfirmDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.clearDataBtn, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldClear == true) {
      try {
        // WICHTIG: MealService über Provider verwenden statt direkt Hive
        final mealService = Provider.of<MealService>(context, listen: false);
        await mealService.clearAllData(); // Ruft notifyListeners() auf

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.clearDataSuccess),
            backgroundColor: Colors.teal,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.clearDataFailed(e.toString())),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: ListView(
        children: [
          // Simple Mode
          ListTile(
            leading: Icon(Icons.accessibility_new, color: Colors.teal),
            title: Text(AppLocalizations.of(context)!.simpleMode),
            subtitle: Text(AppLocalizations.of(context)!.simpleModeDescSub),
            trailing: Switch(
              value: _simpleMode,
              onChanged: _toggleSimpleMode,
              activeColor: Colors.teal,
            ),
          ),
          Divider(),

          // Meal Names
          ListTile(
            leading: Icon(Icons.edit_note, color: Colors.teal),
            title: Text(AppLocalizations.of(context)!.renameMeals),
            subtitle: Text(AppLocalizations.of(context)!.renameMealsDesc),
            trailing:
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MealNamesScreen()),
              );
            },
          ),
          Divider(),

          // Notifications
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.teal),
            title: Text(AppLocalizations.of(context)!.notifications),
            subtitle: Text(AppLocalizations.of(context)!.remindersDesc),
            trailing: Switch(
              value: _notifications,
              onChanged: (value) async {
                await _settingsService.setNotifications(value);
                if (value) {
                  await NotificationService().requestPermissions();
                  await NotificationService().scheduleMealReminders(AppLocalizations.of(context)!);
                } else {
                  await NotificationService().cancelAllNotifications();
                }
              },
              activeColor: Colors.teal,
            ),
          ),

          if (_notifications) // Zeige den Test-Button nur, wenn Benachrichtigungen an sind
            ListTile(
              leading: Icon(Icons.notification_add, color: Colors.teal),
              title: Text(AppLocalizations.of(context)!.testNotification),
              subtitle: Text(AppLocalizations.of(context)!.testNotificationDesc),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                await NotificationService().testNotification(AppLocalizations.of(context)!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.testNotificationSent),
                      backgroundColor: Colors.teal,
                    ),
                  );
                }
              },
            ),
          Divider(),

          // Medication Tracker
          ListTile(
            leading: Icon(Icons.medication, color: Colors.teal),
            title: Text(AppLocalizations.of(context)!.medicationTracker),
            subtitle: Text(AppLocalizations.of(context)!.medicationTrackerDesc),
            trailing: Switch(
              value: _trackMedications,
              onChanged: (value) async {
                await _settingsService.setTrackMedications(value);
              },
              activeColor: Colors.teal,
            ),
          ),
          Divider(),

          // Weekly Stats
          ListTile(
            leading: Icon(Icons.bar_chart, color: Colors.teal),
            title: Text(AppLocalizations.of(context)!.weeklyStats),
            subtitle: Text(AppLocalizations.of(context)!.weeklyStatsDesc),
            trailing: Switch(
              value: _showStats,
              onChanged: (value) async {
                await _settingsService.setShowStats(value);
              },
              activeColor: Colors.teal,
            ),
          ),
          Divider(),

          // Therapie-Export Section
          Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              AppLocalizations.of(context)!.therapyExport,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.picture_as_pdf, color: Colors.redAccent),
            title: Text(AppLocalizations.of(context)!.exportPdf),
            subtitle: Text(AppLocalizations.of(context)!.exportPdfDesc),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              try {
                await ExportService().exportAsPdf();
              } catch (e) {
                if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fehler: $e')));
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.table_chart, color: Colors.green),
            title: Text(AppLocalizations.of(context)!.exportCsvName),
            subtitle: Text(AppLocalizations.of(context)!.exportCsvDesc),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              try {
                await ExportService().exportAsCsv();
              } catch (e) {
                if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fehler: $e')));
              }
            },
          ),
          Divider(),

          // Data Management Section
          Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              AppLocalizations.of(context)!.dataManagement,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),

          // Export Data
          ListTile(
            leading: _isExporting
                ? CircularProgressIndicator(color: Colors.teal, strokeWidth: 2)
                : Icon(Icons.backup, color: Colors.teal),
            title: Text(AppLocalizations.of(context)!.exportData),
            subtitle: Text(AppLocalizations.of(context)!.exportDataDesc),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _isExporting ? null : _exportData,
          ),

          // Import Data
          ListTile(
            leading: _isImporting
                ? CircularProgressIndicator(color: Colors.teal, strokeWidth: 2)
                : Icon(Icons.upload_file, color: Colors.teal),
            title: Text(AppLocalizations.of(context)!.importData),
            subtitle: Text(AppLocalizations.of(context)!.importDataDesc),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _isImporting ? null : _importData,
          ),

          // Clear Data
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red),
            title:
                Text(AppLocalizations.of(context)!.deleteData, style: TextStyle(color: Colors.red)),
            subtitle: Text(AppLocalizations.of(context)!.clearDataWarn),
            trailing:
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
            onTap: _clearAllData,
          ),
          Divider(),

          // Dark Mode
          ListTile(
            leading: Icon(Icons.dark_mode, color: Colors.teal),
            title: Text(AppLocalizations.of(context)!.themeMode),
            subtitle: Text(AppLocalizations.of(context)!.darkModeDesc),
            trailing: Switch(
              value: _settingsService.themeMode == ThemeMode.dark,
              onChanged: (value) {
                _settingsService
                    .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
              },
              activeColor: Colors.teal,
            ),
          ),

          // Privacy
          ListTile(
            leading: Icon(Icons.security, color: Colors.teal),
            title: Text(AppLocalizations.of(context)!.privacy),
            subtitle: Text(AppLocalizations.of(context)!.privacyDesc),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.privacy),
                  content: Text(AppLocalizations.of(context)!.privacyDialogText),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.ok),
                    ),
                  ],
                ),
              );
            },
          ),

          // Entwickler Links
          Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              AppLocalizations.of(context)!.developer,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.code, color: Colors.teal),
            title: Text(AppLocalizations.of(context)!.githubRepo),
            subtitle: Text(AppLocalizations.of(context)!.githubRepoDesc),
            trailing: Icon(Icons.open_in_new, size: 16, color: Colors.grey),
            onTap: () async {
              if (!await launchUrl(Uri.parse(AppConstants.githubRepoUrl), mode: LaunchMode.externalApplication)) {
                if (context.mounted)
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.linkError)));
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.language, color: Colors.teal),
            title: Text(AppLocalizations.of(context)!.devWebsite),
            subtitle: Text(AppLocalizations.of(context)!.devWebsiteDesc),
            trailing: Icon(Icons.open_in_new, size: 16, color: Colors.grey),
            onTap: () async {
              if (!await launchUrl(Uri.parse(AppConstants.developerWebsiteUrl), mode: LaunchMode.externalApplication)) {
                if (context.mounted)
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.linkError)));
              }
            },
          ),
          Divider(),

          // App Info
          ListTile(
            leading: Icon(Icons.info, color: Colors.teal),
            title: Text(AppLocalizations.of(context)!.aboutApp),
            subtitle: Text('${AppLocalizations.of(context)!.appVersion(_appVersion)} • Open Source'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'MealBox',
                applicationVersion: _appVersion,
                applicationLegalese: AppConstants.appLegalese,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Made with ❤️ for the neurodivergent community',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
