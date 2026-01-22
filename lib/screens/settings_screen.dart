// screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  bool _simpleMode = false;
  bool _notifications = true;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
    
    // Listen for changes in the service
    _settingsService.addListener(_onSettingsChanged);
  }
  
  @override
  void dispose() {
    // Remove listener to prevent memory leaks
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }
  
  void _onSettingsChanged() {
    // Called when service calls notifyListeners()
    if (_settingsService.simpleMode != _simpleMode) {
      setState(() {
        _simpleMode = _settingsService.simpleMode;
      });
    }
  }
  
  Future<void> _loadSettings() async {
    // Get current value directly from service
    setState(() {
      _simpleMode = _settingsService.simpleMode;
    });
  }
  
  Future<void> _toggleSimpleMode(bool value) async {
    // Set via service - it will call notifyListeners()
    await _settingsService.setSimpleMode(value);
    // NO setState() needed here - handled by _onSettingsChanged
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.accessibility_new, color: Colors.teal),
            title: Text('Simpler Modus'),
            subtitle: Text('Nur ein Button, keine Auswahl'),
            trailing: Switch(
              value: _simpleMode,
              onChanged: _toggleSimpleMode,
              activeColor: Colors.teal,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.teal),
            title: Text('Erinnerungen'),
            subtitle: Text('Sanfte Erinnerungen aktivieren'),
            trailing: Switch(
              value: _notifications,
              onChanged: (value) {
                setState(() {
                  _notifications = value;
                });
              },
              activeColor: Colors.teal,
            ),
          ),
          ListTile(
            leading: Icon(Icons.palette, color: Colors.teal),
            title: Text('Farbschema'),
            subtitle: Text('Farbschema auswählen'),
            onTap: () {
              // To be implemented later
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: Colors.teal),
            title: Text('Datenschutz'),
            subtitle: Text('Alle daten werden lokal gespeichert'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Privacy'),
                  content: Text(
                    'Alle daten sind lokal auf ihrem gerät gespeichert.'
                    'Es geht keine Information auf einen Server.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}