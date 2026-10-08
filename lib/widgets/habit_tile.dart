import 'package:flutter/material.dart';

import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final DateTime today;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const HabitTile({
    super.key,
    required this.habit,
    required this.today,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final done = habit.isDoneOn(today);
    final streak = habit.currentStreak(today);
    final color = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key(habit.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onLongPress();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: color.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline, color: color.onErrorContainer),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          onTap: onTap,
          onLongPress: onLongPress,
          leading: Text(habit.emoji, style: const TextStyle(fontSize: 28)),
          title: Text(
            habit.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: done ? TextDecoration.lineThrough : null,
              color: done ? color.outline : null,
            ),
          ),
          subtitle: streak > 0
              ? Text('🔥 $streak дн. подряд')
              : const Text('Начни сегодня'),
          trailing: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? color.primary : Colors.transparent,
              border: Border.all(
                color: done ? color.primary : color.outline,
                width: 2,
              ),
            ),
            child: done
                ? Icon(Icons.check, size: 20, color: color.onPrimary)
                : null,
          ),
        ),
      ),
    );
  }
}
