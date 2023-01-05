import 'package:flutter/material.dart';

class CustomDarkThemeWidget extends StatelessWidget {
  final Widget child;
  const CustomDarkThemeWidget({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
        data: theme.copyWith(
            textSelectionTheme:
                theme.textSelectionTheme.copyWith(cursorColor: Colors.white),
            iconTheme: theme.iconTheme.copyWith(color: Colors.white),
            textButtonTheme: const TextButtonThemeData(),
            textTheme: theme.textTheme.copyWith(
              headline1: const TextStyle(color: Colors.white),
              headline2: const TextStyle(color: Colors.white),
              headline3: const TextStyle(color: Colors.white),
              headline4: const TextStyle(color: Colors.white),
              headline5: const TextStyle(color: Colors.white),
              headline6: const TextStyle(color: Colors.white),
              bodyText1: const TextStyle(color: Colors.white),
              bodyText2: const TextStyle(color: Colors.white),
              caption: const TextStyle(color: Colors.white),
              subtitle1: const TextStyle(color: Colors.white),
              subtitle2: const TextStyle(color: Colors.white),
            ),
            inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(1000))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(1000))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(1000))))),
        child: child);
  }
}
