import 'package:asa_server_eye/app/app.dart';
import 'package:asa_server_eye/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:asa_server_eye/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('shows sign in screen when user is signed out', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const AsaServerEyeApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(SignInScreen), findsOneWidget);
  });
}
