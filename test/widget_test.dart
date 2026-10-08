import 'package:flutter_test/flutter_test.dart';
import 'package:habitflow/main.dart';
import 'package:habitflow/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows empty state and today screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = await AppState.create();
    await tester.pumpWidget(HabitFlowApp(state: state));
    await tester.pumpAndSettle();

    expect(find.text('HabitFlow'), findsOneWidget);
    expect(find.text('Добавьте первую привычку'), findsOneWidget);
  });
}
