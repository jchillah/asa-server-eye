import 'package:asa_server_eye/features/profile/presentation/widgets/delete_account_dialog.dart';
import 'package:asa_server_eye/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('requires a password and returns its trimmed value', (
    tester,
  ) async {
    String? result;

    await tester.pumpWidget(
      MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () async {
                result = await showDialog<String>(
                  context: context,
                  builder: (_) =>
                      const DeleteAccountDialog(email: 'user@example.test'),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Delete account'), findsWidgets);
    expect(
      find.text(
        'Please enter your password for user@example.test to delete your '
        'account.',
      ),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), '  secret-password  ');
    await tester.tap(find.widgetWithText(FilledButton, 'Delete Account'));
    await tester.pumpAndSettle();

    expect(find.byType(DeleteAccountDialog), findsNothing);
    expect(result, 'secret-password');
  });
}
