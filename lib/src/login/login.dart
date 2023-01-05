import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpletools/src/login/bloc/login_bloc.dart';
import 'package:simpletools/src/register/register.dart';
import 'package:simpletools/src/widget/custom_padding.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
        child: CustomPadding(
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: ((context, state) {
              if (state is LoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Masuk sukses")));
                Navigator.pop(context, true);
              } else if (state is LoginError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Masuk gagal")));
              }
            }),
            builder: (context, state) {
              return Form(
                child: ListView(
                  children: [
                    Image.asset(
                      "assets/images/simple_tools_icon.png",
                      width: 100.0,
                      height: 100.0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (String value) {
                        context
                            .read<LoginBloc>()
                            .add(LoginEmailChanged(email: value));
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "password",
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        context
                            .read<LoginBloc>()
                            .add(LoginPasswordChanged(password: value));
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is LoginLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ElevatedButton(
                              onPressed: () {
                                context.read<LoginBloc>().add(LoginSubmitted());
                              },
                              child: const Text("Login"));
                        }
                      },
                    ),
                    Row(
                      children: [
                        const Text("Belum punya akun?"),
                        const SizedBox(
                          width: 5.0,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return const Register();
                              }));
                            },
                            child: const Text("Daftar"))
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
