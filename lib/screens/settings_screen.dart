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
  }
  
  Future<void> _loadSettings() async {
    _simpleMode = await _settingsService.getSimpleMode();
    setState(() {});
  }
  
  Future<void> _toggleSimpleMode(bool value) async {
    setState(() {
      _simpleMode = value;
    });
    await _settingsService.setSimpleMode(value);
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
            title: Text('Einfacher Modus'),
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
            subtitle: Text('Sanfte Erinnerungen an Mahlzeiten'),
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
            title: Text('Design'),
            subtitle: Text('Farbschema ändern'),
            onTap: () {
              // Später implementieren
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: Colors.teal),
            title: Text('Datenschutz'),
            subtitle: Text('Alle Daten sind lokal gespeichert'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Datenschutz'),
                  content: Text(
                    'Alle Daten werden nur lokal auf deinem Gerät gespeichert. '
                    'Keine Informationen werden an Server gesendet.',
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