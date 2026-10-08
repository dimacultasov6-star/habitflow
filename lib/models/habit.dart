class Habit {
  final String id;
  final String name;
  final String emoji;
  final List<String> doneDates;

  Habit({
    required this.id,
    required this.name,
    required this.emoji,
    List<String>? doneDates,
  }) : doneDates = doneDates ?? [];

  bool isDoneOn(DateTime day) => doneDates.contains(dateKey(day));

  int currentStreak(DateTime today) {
    var streak = 0;
    var cursor = DateTime(today.year, today.month, today.day);
    if (!isDoneOn(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    while (isDoneOn(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int completionsInRange(DateTime from, DateTime to) {
    var count = 0;
    for (var d = DateTime(from.year, from.month, from.day);
        !d.isAfter(to);
        d = d.add(const Duration(days: 1))) {
      if (isDoneOn(d)) count++;
    }
    return count;
  }

  Habit toggle(DateTime day) {
    final key = dateKey(day);
    final updated = List<String>.from(doneDates);
    updated.remove(key);
    if (updated.length == doneDates.length) updated.add(key);
    updated.sort();
    return Habit(id: id, name: name, emoji: emoji, doneDates: updated);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'doneDates': doneDates,
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'] as String,
        name: json['name'] as String,
        emoji: json['emoji'] as String,
        doneDates: (json['doneDates'] as List).cast<String>(),
      );
}

String dateKey(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

DateTime todayOnly() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}
