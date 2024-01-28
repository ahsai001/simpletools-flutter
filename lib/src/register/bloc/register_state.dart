part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  RegisterSuccess({required String message}) : super();
}

class RegisterError extends RegisterState {
  RegisterError({required String message});
}
