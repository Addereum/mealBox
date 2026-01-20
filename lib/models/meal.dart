import 'package:intl/intl.dart'; // WICHTIG: Diesen Import hinzufügen!

class Meal {
  final String id;
  final String type;
  final DateTime dateTime;
  final String timeString;
  final bool isLoggedLate;

  Meal({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.timeString,
    this.isLoggedLate = false,
  });

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: map['type'],
      dateTime: DateTime.parse(map['dateTime']),
      timeString: map['timeString'],
      isLoggedLate: map['isLoggedLate'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'dateTime': dateTime.toIso8601String(),
      'timeString': timeString,
      'isLoggedLate': isLoggedLate,
    };
  }

  String get dateKey => '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  
  // Factory für nachgetragene Mahlzeiten
  factory Meal.loggedLater(String mealType, DateTime actualTime) {
    final now = DateTime.now();
    return Meal(
      id: now.millisecondsSinceEpoch.toString(),
      type: mealType,
      dateTime: actualTime,
      timeString: DateFormat('HH:mm').format(actualTime), // Jetzt sollte es funktionieren
      isLoggedLate: true,
    );
  }
}