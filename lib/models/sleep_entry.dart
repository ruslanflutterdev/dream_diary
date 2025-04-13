class SleepEntry {
  DateTime sleepTime;
  DateTime wakeTime;
  int sleepQuality;
  String note;

  SleepEntry({
    required this.sleepTime,
    required this.wakeTime,
    required this.sleepQuality,
    required this.note,
  });

  Duration get duration => wakeTime.difference(sleepTime);

  Map<String, dynamic> toJson() => {
    'sleepTime': sleepTime.toIso8601String(),
    'wakeTime': wakeTime.toIso8601String(),
    'sleepQuality': sleepQuality,
    'note': note,
  };

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      sleepTime: DateTime.parse(json['sleepTime']),
      wakeTime: DateTime.parse(json['wakeTime']),
      sleepQuality: json['sleepQuality'],
      note: json['note'],
    );
  }
}
