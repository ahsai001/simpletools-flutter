import 'dart:io';

//import 'dart:js' as js;

import 'package:android_intent_plus/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:simpletools/src/util/widget_util.dart';
import 'package:simpletools/src/widget/custom_padding.dart';

class QuranLog extends StatefulWidget {
  const QuranLog({Key? key}) : super(key: key);

  @override
  _QuranLogState createState() => _QuranLogState();
}

class _QuranLogState extends State<QuranLog> {
  User? _firebaseUser;
  List<List<dynamic>> _quranInfo = [];
  int _nomor = 1;
  int _ayat = 0;
  final TextEditingController _ayatController = TextEditingController();
  Stream<QuerySnapshot<Object?>>? _stream;
  CollectionReference<Map<String, dynamic>>? _collectionRef;

  @override
  void initState() {
    super.initState();
    _firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        setState(() {
          _firebaseUser = null;
        });
      } else {
        print('User is signed in!');
        setState(() {
          _firebaseUser = user;
        });
      }
    });
    _loadQuranCSV();
    _loadStream();
  }

  _loadQuranCSV() async {
    final quranCsvString =
        await rootBundle.loadString("assets/raw/alquran.csv");
    _quranInfo = const CsvToListConverter().convert(quranCsvString);
  }

  _loadStream() {
    _collectionRef = FirebaseFirestore.instance
        .collection("quranreadinglogs")
        .doc(_firebaseUser?.uid)
        .collection("logs");
    _stream =
        _collectionRef?.orderBy("_created_at", descending: true).snapshots();

    _collectionRef
        ?.orderBy("_created_at", descending: true)
        .get()
        .then((value) {
      setState(() {
        _nomor = value.docs[0]["nomor"];
        _ayat = value.docs[0]["ayat"];
      });
      _ayatController.text = value.docs[0]["ayat"].toString();
    });
  }

  _showInfo(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmark Al Qur'an"),
      ),
      body: CustomPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  DropdownButton<int>(
                      value: _nomor,
                      hint: const Text("Pilih surat"),
                      items: _quranInfo.map((List<dynamic> item) {
                        return DropdownMenuItem<int>(
                            value: item[0] as int,
                            child: Text("${item[0].toString()} ${item[1]}"));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _nomor = value!;
                        });
                      }),
                  TextField(
                    controller: _ayatController,
                    decoration:
                        const InputDecoration(hintText: "Masukan nomor ayat"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _ayat = int.parse(value);
                      } else {
                        _ayat = 0;
                      }
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_ayat <= 0) {
                          _showInfo("ayat tidak boleh kosong");
                          return;
                        }
                        _collectionRef?.add({
                          "ayat": _ayat,
                          "surat": "$_nomor ${_quranInfo[_nomor - 1][1]}",
                          "nomor": _nomor,
                          "_created_at": DateTime.now()
                        }).then((value) {
                          print("sukses tambah catatan");
                        }).catchError((error) {
                          print("gagal tambah catatan : $error");
                        });
                      },
                      child: const Text("Tambah catatan")),
                ],
              ),
            ),
            spaceH(),
            const Text(
              "List catatan terakhir :",
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Dismissible(
                          key: Key(document.id),
                          child: InkWell(
                            onTap: () {
                              _openQuran(data["nomor"], data["ayat"]);
                            },
                            child: ListTile(
                              title: Text(
                                  "${data["surat"]} ${data["ayat"].toString()}"),
                              subtitle: data["_created_at"] != null
                                  ? Text(DateFormat("d MMMM yyyy hh:mm:ss")
                                      .format((data["_created_at"] as Timestamp)
                                          .toDate()))
                                  : const Text("date empty"),
                            ),
                          ),
                          background: Container(
                            padding: const EdgeInsets.only(left: 10.0),
                            color: Colors.red,
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          secondaryBackground: Container(
                            color: Colors.green,
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              var isOkay = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Delete Confirmation"),
                                      content: const Text("Are you sure?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text("Cancel")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: const Text("Ok"))
                                      ],
                                    );
                                  });
                              if (isOkay) {
                                return Future.value(true);
                              } else {
                                return Future.value(false);
                              }
                            } else {
                              //_openQuran(data["nomor"], data["ayat"]);
                              return Future.value(false);
                            }
                          },
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              _collectionRef
                                  ?.doc(document.id)
                                  .delete()
                                  .then((value) {
                                print("delete log berhasil");
                              }).catchError((error) {
                                print("delete log gagal : $error");
                              });
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              _openQuran(data["nomor"], data["ayat"]);
                            }
                          },
                        );
                      }).toList(),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Future _openQuran(int nomor, int ayat) async {
    if (kIsWeb) {
      //open web
      //js.context.callMethod('open', ["https://beta.quran.com/$nomor/$ayat"]);
    } else {
      if (Platform.isAndroid) {
        AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data: "quran://$nomor/$ayat",
          arguments: {'': ""},
        );
        await intent.launch();
      } else {
        //js.context.callMethod('open', ["https://beta.quran.com/$nomor/$ayat"]);
      }
    }
  }
}
