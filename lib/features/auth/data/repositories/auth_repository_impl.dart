import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final user = await datasource.login(email, password);
      return UserModel.fromFirebase(user);
    } on InvalidCredentialsException {
      throw const InvalidCredentialsFailure();
    } on UserNotFoundException {
      throw const UserNotFoundFailure();
    } on WrongPasswordException {
      throw const WrongPasswordFailure();
    } on InvalidEmailException {
      throw const InvalidEmailFailure();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on NetworkException {
      throw const NetworkFailure();
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  @override
  Future<UserEntity> register(String email, String password) async {
    try {
      final user = await datasource.register(email, password);
      return UserModel.fromFirebase(user);
    } on EmailAlreadyInUseException {
      throw const EmailAlreadyInUseFailure();
    } on WeakPasswordException {
      throw const WeakPasswordFailure();
    } on InvalidEmailException {
      throw const InvalidEmailFailure();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on NetworkException {
      throw const NetworkFailure();
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await datasource.logout();
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return datasource.authStateChanges().map((u) {
      if (u == null) return null;
      return UserModel.fromFirebase(u);
    });
  }
}
