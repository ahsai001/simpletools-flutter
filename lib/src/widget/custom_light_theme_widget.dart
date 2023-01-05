import 'package:flutter/material.dart';

class CustomLightThemeWidget extends StatelessWidget {
  final Widget child;
  const CustomLightThemeWidget({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
        data: theme.copyWith(
            textSelectionTheme:
                theme.textSelectionTheme.copyWith(cursorColor: Colors.black),
            iconTheme: theme.iconTheme.copyWith(color: Colors.black),
            textButtonTheme: const TextButtonThemeData(),
            textTheme: theme.textTheme.copyWith(
              headline1: const TextStyle(color: Colors.black),
              headline2: const TextStyle(color: Colors.black),
              headline3: const TextStyle(color: Colors.black),
              headline4: const TextStyle(color: Colors.black),
              headline5: const TextStyle(color: Colors.black),
              headline6: const TextStyle(color: Colors.black),
              bodyText1: const TextStyle(color: Colors.black),
              bodyText2: const TextStyle(color: Colors.black),
              caption: const TextStyle(color: Colors.black),
              subtitle1: const TextStyle(color: Colors.black),
              subtitle2: const TextStyle(color: Colors.black),
            ),
            inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10))))),
        child: child);
  }
}
