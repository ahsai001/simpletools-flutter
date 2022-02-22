import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  String email = "";
  String password = "";

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterEmailChanged>((event, emit) {
      email = event.email.trim();
    });
    on<RegisterPasswordChanged>((event, emit) {
      password = event.password.trim();
    });
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      print("email : $email and password : $password");

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          emit(RegisterSuccess(message: "Register berhasil"));
        } else {
          emit(RegisterError(message: "Register gagal"));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          emit(RegisterError(message: 'The password provided is too weak.'));
        } else if (e.code == 'email-already-in-use') {
          emit(RegisterError(
              message: 'The account already exists for that email.'));
        }
      } catch (e) {
        print(e);
      }

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          emit(RegisterSuccess(message: "Register berhasil"));
        } else {
          emit(RegisterError(message: "Register gagal"));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(RegisterError(message: "No user found for that email."));
        } else if (e.code == 'wrong-password') {
          emit(
              RegisterError(message: "Wrong password provided for that user."));
        }
      }
    });
  }
}
