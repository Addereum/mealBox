import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/settings_service.dart';

class MealDialog extends StatefulWidget {
  final Function(String, DateTime?, String?) onMealSelected;

  const MealDialog({Key? key, required this.onMealSelected}) : super(key: key);

  @override
  _MealDialogState createState() => _MealDialogState();
}

class _MealDialogState extends State<MealDialog> {
  DateTime? _customTime;
  bool _showTimePicker = false;
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _selectedEnergy;
  final SettingsService _settingsService = SettingsService.instance;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _customTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _logMeal(String mealType) {
    widget.onMealSelected(mealType, _customTime, _selectedEnergy);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Text(
                  'Was hast du gegessen? 🍽️',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // Zeitauswahl
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.teal, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Zeitpunkt:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Spacer(),
                      Switch(
                        value: _showTimePicker,
                        onChanged: (value) {
                          setState(() {
                            _showTimePicker = value;
                            if (!value) {
                              _customTime = null;
                            } else {
                              _customTime = DateTime.now().subtract(Duration(hours: 1));
                            }
                          });
                        },
                        activeColor: Colors.teal,
                      ),
                    ],
                  ),
                  
                  if (_showTimePicker) ...[
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _selectTime(context),
                            icon: Icon(Icons.schedule),
                            label: Text(
                              _customTime != null
                                  ? DateFormat('HH:mm').format(_customTime!)
                                  : 'Zeit auswählen',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.withOpacity(0.1),
                              foregroundColor: Colors.teal,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _customTime = null;
                              _selectedTime = TimeOfDay.now();
                            });
                          },
                          icon: Icon(Icons.refresh, color: Colors.grey),
                          tooltip: 'Auf jetzt zurücksetzen',
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      _customTime != null
                          ? 'Wird als nachgetragene Mahlzeit gespeichert'
                          : 'Ohne Auswahl wird die aktuelle Zeit verwendet',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            
            Divider(height: 1),
            
            // Energy Level
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Energie-Level (optional):',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      _buildEnergyButton('🪫 Low', Colors.red),
                      _buildEnergyButton('🔋 Med', Colors.orange),
                      _buildEnergyButton('⚡ High', Colors.green),
                    ],
                  ),
                ],
              ),
            ),

            Divider(height: 1),
            
            // Meal Options Grid
            Padding(
              padding: EdgeInsets.all(20),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: List.generate(4, (index) {
                  final colors = [Colors.orange[100]!, Colors.green[100]!, Colors.blue[100]!, Colors.red[100]!];
                  final label = _settingsService.mealNames.length > index ? _settingsService.mealNames[index] : 'Mahlzeit ${index + 1}';
                  return _buildMealOption(label, colors[index]);
                }),
              ),
            ),
            
            // Cancel Button
            Padding(
              padding: EdgeInsets.only(bottom: 15, left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Text('Abbrechen'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyButton(String label, MaterialColor color) {
    final isSelected = _selectedEnergy == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedEnergy = selected ? label : null;
        });
      },
      selectedColor: color[100],
      backgroundColor: Colors.grey[100],
      side: BorderSide(
        color: isSelected ? color[300]! : Colors.grey[300]!,
      ),
      labelStyle: TextStyle(
        color: isSelected ? color[900] : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildMealOption(String label, Color color) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      color: color,
      child: InkWell(
        onTap: () => _logMeal(label),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}