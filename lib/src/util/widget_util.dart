import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simpletools/src/login/login.dart';

Future<bool> logout(BuildContext context) async {
  var isLogout = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout Confirmation"),
          content: const Text("Are you sure?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text("Logout"))
          ],
        );
      });
  if (isLogout) {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Logout berhasil")));

    return true;
  }
  return false;
}

Future<bool> login(BuildContext context) async {
  final result =
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
    return const Login();
  }));

  if (result != null && result == true) {
    return true;
  }
  return false;
}

Future<void> doingWithLogin(
    BuildContext context, void Function() actionWhenLoggedIn) async {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser == null) {
    bool result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Perlu masuk"),
            content: const Text("Silakan masuk untuk menggunakan fitur ini"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text("Masuk")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("Batal")),
            ],
          );
        });
    if (result) {
      if (await login(context)) {
        actionWhenLoggedIn.call();
      }
    }
  } else {
    actionWhenLoggedIn.call();
  }
}
