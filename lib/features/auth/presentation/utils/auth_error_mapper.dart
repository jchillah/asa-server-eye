// features/auth/presentation/utils/auth_error_mapper.dart
abstract final class AuthErrorMapper {
  static String mapSignInError({
    required String code,
    required String invalidEmailFormat,
    required String userDisabled,
    required String invalidCredentials,
    required String networkError,
    required String genericError,
  }) {
    switch (code) {
      case 'invalid-email':
        return invalidEmailFormat;
      case 'user-disabled':
        return userDisabled;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return invalidCredentials;
      case 'network-request-failed':
        return networkError;
      default:
        return genericError;
    }
  }

  static String mapSignUpError({
    required String code,
    required String invalidEmailFormat,
    required String emailAlreadyInUse,
    required String weakPassword,
    required String networkError,
    required String genericError,
  }) {
    switch (code) {
      case 'invalid-email':
        return invalidEmailFormat;
      case 'email-already-in-use':
        return emailAlreadyInUse;
      case 'weak-password':
        return weakPassword;
      case 'network-request-failed':
        return networkError;
      default:
        return genericError;
    }
  }
}
