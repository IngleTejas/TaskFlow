import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    // Build the app widget tree
    await tester.pumpWidget(const TaskManagerApp());

    // The TaskFlow title in AppBar should be present
    expect(find.text('TaskFlow'), findsOneWidget);
  });
}
