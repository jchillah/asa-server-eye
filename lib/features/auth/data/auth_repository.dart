// features/auth/data/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signIn({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signUp({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
