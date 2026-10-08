import 'package:flutter/foundation.dart';

import '../models/habit.dart';
import '../services/purchase_service.dart';
import '../services/store.dart';

class AppState extends ChangeNotifier {
  final AppStore store;
  final PurchaseService purchases;
  List<Habit> habits;

  AppState({required this.store, required this.purchases})
      : habits = store.habits();

  static Future<AppState> create() async {
    final store = await AppStore.load();
    return AppState(store: store, purchases: PurchaseService(store));
  }

  void toggle(Habit habit, DateTime day) {
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index == -1) return;
    habits[index] = habit.toggle(day);
    store.saveHabits(habits);
    notifyListeners();
  }

  bool canAddHabit() => purchases.canAddHabit(habits.length);

  Future<void> addHabit(String name, String emoji) async {
    habits.add(Habit(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      emoji: emoji,
    ));
    await store.saveHabits(habits);
    notifyListeners();
  }

  Future<void> removeHabit(Habit habit) async {
    habits.removeWhere((h) => h.id == habit.id);
    await store.saveHabits(habits);
    notifyListeners();
  }
}
