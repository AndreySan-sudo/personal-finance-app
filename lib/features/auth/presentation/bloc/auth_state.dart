part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class Authenticated extends AuthState {
  final UserEntity user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}
