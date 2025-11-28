// import '../../../core/errors/exceptions.dart'; // opcional para errores
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<UserEntity> login(String email, String password) async {
    final user = await datasource.login(email, password);
    return UserModel.fromFirebase(user);
  }

  @override
  Future<UserEntity> register(String email, String password) async {
    final user = await datasource.register(email, password);
    return UserModel.fromFirebase(user);
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
