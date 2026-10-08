import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../state/app_state.dart';

class StatsScreen extends StatelessWidget {
  final AppState state;

  const StatsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final habits = state.habits;
    final today = todayOnly();
    final weekStart = today.subtract(const Duration(days: 6));

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: habits.isEmpty
          ? const Center(child: Text('Пока нет данных'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Привычек',
                        value: '${habits.length}',
                        icon: Icons.list_alt,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Лучший стрик',
                        value:
                            '${habits.map((h) => h.currentStreak(today)).reduce((a, b) => a > b ? a : b)}',
                        icon: Icons.local_fire_department,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _StatCard(
                  label: 'Выполнено за 7 дней',
                  value:
                      '${habits.fold(0, (sum, h) => sum + h.completionsInRange(weekStart, today))} раз',
                  icon: Icons.bar_chart,
                ),
                const SizedBox(height: 24),
                Text('По привычкам', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...habits.map(
                  (h) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Text(h.emoji, style: const TextStyle(fontSize: 24)),
                      title: Text(h.name),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('🔥 ${h.currentStreak(today)}'),
                          Text(
                            '${h.completionsInRange(weekStart, today)}/7 за неделю',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
