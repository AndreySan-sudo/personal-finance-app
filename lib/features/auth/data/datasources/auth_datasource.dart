import 'package:firebase_auth/firebase_auth.dart';

class AuthDatasource {
  final FirebaseAuth _auth;
  AuthDatasource(this._auth);

  Future<User> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user!;
  }

  Future<User> register(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user!;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
