import 'package:flutter/material.dart';

import '../services/purchase_service.dart';

class PaywallScreen extends StatefulWidget {
  final PurchaseService purchases;

  const PaywallScreen({super.key, required this.purchases});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _buying = false;

  Future<void> _buy() async {
    setState(() => _buying = true);
    final ok = await widget.purchases.buyLifetime();
    if (!mounted) return;
    setState(() => _buying = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Premium активирован!')),
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('HabitFlow Premium')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Text('⭐', textAlign: TextAlign.center, style: TextStyle(fontSize: 64)),
            const SizedBox(height: 24),
            Text(
              'Больше никаких лимитов',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            const _Benefit(text: 'Безлимитное количество привычек'),
            const _Benefit(text: 'Детальная статистика'),
            const _Benefit(text: 'Экспорт данных'),
            const _Benefit(text: 'Поддержка разработки'),
            const Spacer(),
            FilledButton(
              onPressed: _buying ? null : _buy,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _buying
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Оформить — ${PurchaseService.monthlyPrice}'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _buying ? null : _buy,
              child: Text('Годовой доступ — ${PurchaseService.yearlyPrice}'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Не сейчас'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  final String text;

  const _Benefit({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
