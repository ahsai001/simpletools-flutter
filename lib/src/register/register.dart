import 'package:flutter/material.dart';
import 'package:flutter_alcore/flutter_alcore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpletools/src/register/bloc/register_bloc.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(),
        child: CustomPadding(
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listener: ((context, state) {
              if (state is RegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Daftar sukses")));
                Navigator.pop(context, true);
              } else if (state is RegisterError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Daftar gagal")));
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
                            .read<RegisterBloc>()
                            .add(RegisterEmailChanged(email: value));
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "password",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        context
                            .read<RegisterBloc>()
                            .add(RegisterPasswordChanged(password: value));
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        if (state is RegisterLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ElevatedButton(
                              onPressed: () {
                                context
                                    .read<RegisterBloc>()
                                    .add(RegisterSubmitted());
                              },
                              child: const Text("Daftar"));
                        }
                      },
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
