import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';

class AuthDatasource {
  final FirebaseAuth _auth;
  AuthDatasource(this._auth);

  Future<User> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw const UserNotFoundException();
        case 'wrong-password':
          throw const WrongPasswordException();
        case 'invalid-email':
          throw const InvalidEmailException();
        case 'user-disabled':
          throw const AuthException('Esta cuenta ha sido deshabilitada');
        case 'invalid-credential':
          throw const InvalidCredentialsException();
        default:
          throw AuthException(e.message ?? 'Error de autenticación');
      }
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  Future<User> register(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw const EmailAlreadyInUseException();
        case 'weak-password':
          throw const WeakPasswordException();
        case 'invalid-email':
          throw const InvalidEmailException();
        case 'operation-not-allowed':
          throw const AuthException('Operación no permitida');
        default:
          throw AuthException(e.message ?? 'Error de registro');
      }
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
