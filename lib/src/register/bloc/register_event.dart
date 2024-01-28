part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterEmailChanged extends RegisterEvent {
  final String email;
  RegisterEmailChanged({required this.email});
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;
  RegisterPasswordChanged({required this.password});
}

class RegisterSubmitted extends RegisterEvent {}
