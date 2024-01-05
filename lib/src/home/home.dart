import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alcore/flutter_alcore.dart';
import 'package:simpletools/src/quranlog/quran_log.dart';
import 'package:simpletools/src/util/widget_util.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Tools"), actions: [
        IconButton(
            onPressed: () async {
              if (firebaseUser != null) {
                if (await logout(context)) {
                  setState(() {});
                }
              } else {
                if (await login(context)) {
                  setState(() {});
                }
              }
            },
            icon: Icon(firebaseUser != null ? Icons.logout : Icons.login))
      ]),
      body: CustomPadding(
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.65,
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0),
          children: [
            GridItem(
              title: "Bookmark Al Qur'an",
              icon: Icons.send,
              onTap: () async {
                doingWithLogin(context, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const QuranLog();
                  }));
                });
              },
            ),
            GridItem(
              title: "Dzikir Pagi",
              icon: Icons.send,
              onTap: () {
                _launchApp("https://ahsailabs.com/dzikirpagi/");
              },
            ),
            GridItem(
              title: "Dzikir Petang",
              icon: Icons.send,
              onTap: () async {
                _launchApp("https://ahsailabs.com/dzikirpetang/");
              },
            ),
            // GridItem(
            //   title: "Chat wa ke nomor tertentu",
            //   icon: Icons.send,
            //   onTap: () {},
            // ),
            // GridItem(
            //   title: "Buat link cepat untuk kirim wa",
            //   icon: Icons.send,
            //   onTap: () {},
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Gagal luncurkan $url';
    }
  }

  Future<void> _launchApp(String url) async {
    if (!await DeviceApps.openApp("com.zaitunlabs.dzikirharian")) {
      await _launchUrl(url);
    }
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
