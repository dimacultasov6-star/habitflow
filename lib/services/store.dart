import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';

class AppStore {
  static const _habitsKey = 'habits';
  static const _premiumKey = 'premium';

  final SharedPreferences _prefs;
  AppStore._(this._prefs);

  static Future<AppStore> load() async =>
      AppStore._(await SharedPreferences.getInstance());

  List<Habit> habits() {
    final raw = _prefs.getString(_habitsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => Habit.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveHabits(List<Habit> habits) => _prefs.setString(
      _habitsKey, jsonEncode(habits.map((h) => h.toJson()).toList()));

  bool get isPremium => _prefs.getBool(_premiumKey) ?? false;

  Future<void> setPremium(bool value) => _prefs.setBool(_premiumKey, value);
}
