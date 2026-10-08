import 'package:flutter/material.dart';

import 'screens/stats_screen.dart';
import 'screens/today_screen.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = await AppState.create();
  runApp(HabitFlowApp(state: state));
}

class HabitFlowApp extends StatelessWidget {
  final AppState state;

  const HabitFlowApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return MaterialApp(
          title: 'HabitFlow',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D5B)),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2E7D5B),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: _Home(state: state),
        );
      },
    );
  }
}

class _Home extends StatefulWidget {
  final AppState state;

  const _Home({required this.state});

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          TodayScreen(state: widget.state),
          StatsScreen(state: widget.state),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today), label: 'Сегодня'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Статистика'),
        ],
      ),
    );
  }
}
