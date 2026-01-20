class Meal {
  final String id;
  final String type;
  final DateTime dateTime;
  final String timeString;

  Meal({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.timeString,
  });

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: map['type'],
      dateTime: DateTime.parse(map['dateTime']),
      timeString: map['timeString'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'dateTime': dateTime.toIso8601String(),
      'timeString': timeString,
    };
  }

  String get dateKey => '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
}