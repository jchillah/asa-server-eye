import 'package:asa_server_eye/features/auth/presentation/utils/auth_error_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthErrorMapper.mapPasswordResetError', () {
    const invalidEmail = 'invalid email';
    const userDisabled = 'user disabled';
    const networkError = 'network error';
    const genericError = 'generic error';

    String map(String code) {
      return AuthErrorMapper.mapPasswordResetError(
        code: code,
        invalidEmailFormat: invalidEmail,
        userDisabled: userDisabled,
        networkError: networkError,
        genericError: genericError,
      );
    }

    test('maps invalid email errors', () {
      expect(map('invalid-email'), invalidEmail);
    });

    test('maps disabled user errors', () {
      expect(map('user-disabled'), userDisabled);
    });

    test('maps network errors', () {
      expect(map('network-request-failed'), networkError);
    });

    test('does not expose unknown Firebase errors', () {
      expect(map('internal-error'), genericError);
    });
  });
}
