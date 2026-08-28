import 'package:intl/intl.dart'; // WICHTIG: Diesen Import hinzufügen!
import 'package:hive/hive.dart';

part 'meal.g.dart';

@HiveType(typeId: 0)
class Meal {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String type;
  
  @HiveField(2)
  final DateTime dateTime;
  
  @HiveField(3)
  final String timeString;
  
  @HiveField(4)
  final bool isLoggedLate;
  
  @HiveField(5)
  final String? energyLevel;
  
  @HiveField(6)
  final bool? tookMeds;
  
  @HiveField(7)
  final String? imagePath;

  Meal({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.timeString,
    this.isLoggedLate = false,
    this.energyLevel,
    this.tookMeds,
    this.imagePath,
  });


  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: map['type'],
      dateTime: DateTime.parse(map['dateTime']),
      timeString: map['timeString'],
      isLoggedLate: map['isLoggedLate'] ?? false,
      energyLevel: map['energyLevel'],
      tookMeds: map['tookMeds'],
      imagePath: map['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'dateTime': dateTime.toIso8601String(),
      'timeString': timeString,
      'isLoggedLate': isLoggedLate,
      'energyLevel': energyLevel,
      'tookMeds': tookMeds,
      'imagePath': imagePath,
    };
  }

  String get dateKey => '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  
  // Factory für nachgetragene Mahlzeiten
  factory Meal.loggedLater(String mealType, DateTime actualTime, {String? energyLevel, bool? tookMeds, String? imagePath}) {
    final now = DateTime.now();
    return Meal(
      id: now.millisecondsSinceEpoch.toString(),
      type: mealType,
      dateTime: actualTime,
      timeString: DateFormat('HH:mm').format(actualTime),
      isLoggedLate: true,
      energyLevel: energyLevel,
      tookMeds: tookMeds,
      imagePath: imagePath,
    );
  }
}