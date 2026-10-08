import '../services/store.dart';

class PurchaseService {
  static const freeHabitLimit = 3;
  static const monthlyPrice = '\$2.99/мес';
  static const yearlyPrice = '\$19.99/год';

  final AppStore _store;
  PurchaseService(this._store);

  bool get isPremium => _store.isPremium;
  bool canAddHabit(int currentCount) =>
      isPremium || currentCount < freeHabitLimit;

  Future<bool> buyLifetime() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    await _store.setPremium(true);
    return true;
  }

  Future<void> restore() async {}
}
