import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String email = "";
  String password = "";

  LoginBloc() : super(LoginInitial()) {
    on<LoginEmailChanged>((event, emit) {
      email = event.email.trim();
    });
    on<LoginPasswordChanged>((event, emit) {
      password = event.password.trim();
    });
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      print("email : $email and password : $password");
      //await Future.delayed(const Duration(seconds: 1));
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          emit(LoginSuccess(message: "Login berhasil"));
        } else {
          emit(LoginError(message: "Login gagal"));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(LoginError(message: "No user found for that email."));
        } else if (e.code == 'wrong-password') {
          emit(LoginError(message: "Wrong password provided for that user."));
        }
      }
    });
  }
}
