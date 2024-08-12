part of 'auth_cubit.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final AuthDataModel authData;

  AuthSuccess(this.authData);
}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}
