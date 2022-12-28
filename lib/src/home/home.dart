import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simpletools/src/login/login.dart';
import 'package:simpletools/src/quranlog/quran_log.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? firebaseUser;

  @override
  void initState() {
    super.initState();
    firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        firebaseUser = null;
      } else {
        print('User is signed in!');
        firebaseUser = user;
      }
    });
  }

  _logout() async {
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
      setState(() {});
    }
  }

  _login() async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const Login();
    }));

    if (result != null && result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Tools"), actions: [
        IconButton(
            onPressed: () {
              if (firebaseUser != null) {
                _logout();
              } else {
                _login();
              }
            },
            icon: Icon(firebaseUser != null ? Icons.logout : Icons.login))
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0),
          children: [
            GridItem(
              title: "Bookmark Al Qur'an",
              icon: Icons.send,
              onTap: () async {
                if (firebaseUser == null) {
                  bool result = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Perlu masuk"),
                          content: const Text(
                              "Silakan masuk untuk menggunakan fitur ini"),
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
                    _login();
                  }
                } else {
                  //go quran log
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const QuranLog();
                  }));
                }
              },
            ),
            GridItem(
              title: "Dzikir Pagi",
              icon: Icons.send,
              onTap: () {
                if (kIsWeb) {
                  _launchUrl("https://dzikirpagi.zaitunlabs.com");
                } else if (Platform.isAndroid) {
                  _launchApp();
                }
              },
            ),
            GridItem(
              title: "Dzikir Petang",
              icon: Icons.send,
              onTap: () async {
                if (kIsWeb) {
                  _launchUrl("https://dzikirpetang.zaitunlabs.com");
                } else if (Platform.isAndroid) {
                  _launchApp();
                }
              },
            ),
            GridItem(
              title: "Chat wa ke nomor tertentu",
              icon: Icons.send,
              onTap: () {},
            ),
            GridItem(
              title: "Buat link cepat untuk kirim wa",
              icon: Icons.send,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Gagal luncurkan $url';
    }
  }

  Future<void> _launchApp() async {
    DeviceApps.openApp("com.zaitunlabs.dzikirharian");
  }
}

class GridItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const GridItem(
      {Key? key, required this.title, required this.icon, required this.onTap})
      : super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("hallo ${widget.title}");
        widget.onTap();
      },
      child: Container(
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 80.0,
              color: Colors.white,
            ),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            )
          ],
        ),
      ),
    );
  }
}
