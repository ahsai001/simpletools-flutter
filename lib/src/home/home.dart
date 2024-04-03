import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alcore/flutter_alcore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simpletools/src/chatwa_unknown/chatwa_unknown_page.dart';
import 'package:simpletools/src/countdown/countdown_page.dart';
import 'package:simpletools/src/doa/doa_page.dart';
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
        child: Container(
          width: double.infinity,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: 5,
            runSpacing: 5,
            children: [
              GridItem(
                title: "Bookmark Al Qur'an",
                svgPath: "assets/images/menu/quran-icon.svg",
                iconColor: Colors.white,
                onTap: () async {
                  doingWithLogin(context, () {
                    pushNewPageWithTransition(
                        context, (context) => const QuranLog());
                  });
                },
              ),
              GridItem(
                title: "Dzikir Pagi",
                svgPath: "assets/images/menu/pray-welcome-icon.svg",
                iconColor: Colors.black,
                onTap: () {
                  _launchApp("https://ahsailabs.com/dzikirpagi");
                },
              ),
              GridItem(
                title: "Dzikir Petang",
                svgPath: "assets/images/menu/pray-welcome-icon.svg",
                iconColor: Colors.white,
                onTap: () async {
                  _launchApp("https://ahsailabs.com/dzikirpetang");
                },
              ),
              GridItem(
                title: "Dzikir Subuh",
                svgPath: "assets/images/menu/ramadan-icon.svg",
                iconColor: Colors.black,
                onTap: () async {
                  _launchApp("https://ahsailabs.com/dzikirsubuh");
                },
              ),
              GridItem(
                title: "Dzikir Maghrib",
                svgPath: "assets/images/menu/ramadan-icon.svg",
                iconColor: Colors.black,
                onTap: () async {
                  _launchApp("https://ahsailabs.com/dzikirmaghrib");
                },
              ),
              GridItem(
                title: "Dzikir Zhuhur/Ashar/Isya",
                svgPath: "assets/images/menu/ramadan-icon.svg",
                iconColor: Colors.white,
                onTap: () async {
                  _launchApp("https://ahsailabs.com/dzikirzhuhur");
                },
              ),
              GridItem(
                title: "Countdown Event",
                svgPath: "assets/images/menu/date-and-time-icon.svg",
                iconColor: Colors.white,
                onTap: () async {
                  doingWithLogin(context, () {
                    pushNewPageWithTransition(
                        context, (context) => const CountDownPage());
                  });
                },
              ),
              GridItem(
                title: "Chat wa ke nomor tertentu",
                pngPath: "assets/images/menu/wa-whatsapp-icon.png",
                onTap: () {
                  pushNewPageWithTransition(
                      context, (context) => const ChatWAUnknownPage());
                },
              ),
              GridItem(
                  title: "Doa",
                  svgPath: "assets/images/menu/hands-praying-icon.svg",
                  iconColor: Colors.white,
                  onTap: () {
                    pushNewPageWithTransition(
                        context, (context) => const DoaPage());
                  }),
              // GridItem(
              //   title: "Buat link cepat untuk kirim wa",
              //   icon: Icons.send,
              //   onTap: () {},
              // ),
            ],
          ),
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
    await _launchUrl(url);
    // if (await LaunchApp.openApp(
    //         androidPackageName: 'com.zaitunlabs.dzikirharian') ==
    //     0) {
    //   await _launchUrl(url);
    // }
    // if (!await DeviceApps.openApp("com.zaitunlabs.dzikirharian")) {
    //   await _launchUrl(url);
    // }
  }
}

class GridItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? svgPath;
  final String? pngPath;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;
  final VoidCallback onTap;
  const GridItem({
    Key? key,
    required this.title,
    this.icon,
    required this.onTap,
    this.iconColor,
    this.svgPath,
    this.pngPath,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.green,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 45,
                  color: iconColor,
                ),
              if (svgPath != null)
                SvgPicture.asset(
                  svgPath!,
                  width: 45,
                  height: 45,
                  colorFilter: iconColor != null
                      ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                      : null,
                ),
              if (pngPath != null)
                Image.asset(
                  pngPath!,
                  width: 45,
                  height: 45,
                  color: iconColor,
                ),
              const SpaceHeight(
                height: 3,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor!, fontSize: 12.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
