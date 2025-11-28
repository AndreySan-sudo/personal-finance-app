import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('Usuario o contraseña inválidos');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure()
      : super('No se encontró una cuenta con este email');
}

class WrongPasswordFailure extends AuthFailure {
  const WrongPasswordFailure() : super('La contraseña es incorrecta');
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure() : super('Este email ya está registrado');
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure() : super('La contraseña es muy débil');
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure() : super('El formato del email es inválido');
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('Error de conexión. Verifica tu internet');
}

class UnknownFailure extends Failure {
  const UnknownFailure([String? customMessage])
      : super(customMessage ?? 'Ocurrió un error inesperado');
}
