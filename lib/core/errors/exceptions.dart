class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException() : super('Invalid credentials');
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException() : super('User not found');
}

class WrongPasswordException extends AuthException {
  const WrongPasswordException() : super('Wrong password');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException() : super('Email already in use');
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException() : super('Weak password');
}

class InvalidEmailException extends AuthException {
  const InvalidEmailException() : super('Invalid email');
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}
