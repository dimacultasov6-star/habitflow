import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../state/app_state.dart';
import '../widgets/habit_tile.dart';
import 'paywall_screen.dart';

class TodayScreen extends StatelessWidget {
  final AppState state;

  const TodayScreen({super.key, required this.state});

  Future<void> _addHabit(BuildContext context) async {
    if (!state.canAddHabit()) {
      final unlocked = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => PaywallScreen(purchases: state.purchases)),
      );
      if (unlocked != true) return;
    }
    if (!context.mounted) return;
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (_) => const _AddHabitDialog(),
    );
    if (result != null) {
      await state.addHabit(result.$1, result.$2);
    }
  }

  Future<void> _confirmDelete(BuildContext context, Habit habit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Удалить «${habit.name}»?'),
        content: const Text('Прогресс по этой привычке будет потерян.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed == true) await state.removeHabit(habit);
  }

  @override
  Widget build(BuildContext context) {
    final today = todayOnly();
    final habits = state.habits;
    final done = habits.where((h) => h.isDoneOn(today)).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitFlow'),
        actions: [
          if (!state.purchases.isPremium)
            IconButton(
              icon: const Icon(Icons.star_outline),
              tooltip: 'Premium',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => PaywallScreen(purchases: state.purchases)),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addHabit(context),
        icon: const Icon(Icons.add),
        label: const Text('Привычка'),
      ),
      body: habits.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🌱', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 16),
                    Text(
                      'Добавьте первую привычку',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Сегодня',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$done из ${habits.length} выполнено',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 48,
                          width: 48,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: habits.isEmpty ? 0 : done / habits.length,
                                strokeWidth: 5,
                              ),
                              Center(
                                child: Text(
                                  habits.isEmpty
                                      ? '0%'
                                      : '${(done / habits.length * 100).round()}%',
                                  style: const TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...habits.map(
                  (h) => HabitTile(
                    habit: h,
                    today: today,
                    onTap: () => state.toggle(h, today),
                    onLongPress: () => _confirmDelete(context, h),
                  ),
                ),
              ],
            ),
    );
  }
}

class _AddHabitDialog extends StatefulWidget {
  const _AddHabitDialog();

  @override
  State<_AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<_AddHabitDialog> {
  static const _emojis = ['💧', '🏃', '📚', '🧘', '💤', '🍎', '✍️', '🎸', '🧹', '💊'];

  final _controller = TextEditingController();
  String _emoji = _emojis.first;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новая привычка'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            maxLength: 40,
            decoration: const InputDecoration(
              labelText: 'Название',
              hintText: 'Например: Пить воду',
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _emojis
                .map(
                  (e) => ChoiceChip(
                    label: Text(e, style: const TextStyle(fontSize: 20)),
                    selected: _emoji == e,
                    onSelected: (_) => setState(() => _emoji = e),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Добавить')),
      ],
    );
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop((name, _emoji));
  }
}
