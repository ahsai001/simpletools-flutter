import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alcore/flutter_alcore.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:intl/intl.dart';

class CountDownPage extends StatelessWidget {
  const CountDownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final collectionRef = FirebaseFirestore.instance
        .collection("countdown_events")
        .doc(user?.uid)
        .collection("events");
    final stream = collectionRef.orderBy("date", descending: false).snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitleText("Count Down Events"),
      ),
      body: CustomPadding(
          child: StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          'Something went wrong : ${snapshot.error.toString()} '));
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
                          //
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(data["name"]),
                              trailing: data["date"] != null
                                  ? Text(DateFormat("d MMMM yyyy").format(
                                      (data["date"] as Timestamp).toDate()))
                                  : const Text("-"),
                            ),
                            TimerCountdown(
                              endTime: (data["date"] as Timestamp).toDate(),
                            )
                          ],
                        ),
                      ),
                      background: Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        color: Colors.red,
                        child: const Row(
                          children: [
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
                          return Future.value(false);
                        }
                      },
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          collectionRef.doc(document.id).delete().then((value) {
                            print("delete log berhasil");
                          }).catchError((error) {
                            print("delete log gagal : $error");
                          });
                        } else if (direction == DismissDirection.endToStart) {
                          //_openQuran(data["nomor"], data["ayat"]);
                        }
                      },
                    );
                  }).toList(),
                );
              })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showConfirmationAndProcessingDialog<Map<String, String>,
              DocumentReference<Map<String, dynamic>>>(
            context,
            "Add Event Confirmation",
            "are you sure?",
            extraBodyBuilder: (context, request, processState, stateSetter) {
              return Column(
                children: [
                  LabeledTextField(
                    label: "Name",
                    onChanged: (value) {
                      request?["name"] = value;
                    },
                  ),
                  const SpaceHeight(),
                  DateTextField(controller: DateTextFieldController())
                ],
              );
            },
            getRequest: (context) {
              return {};
            },
            actionFunction: (context, request) {
              return FirebaseFirestore.instance
                  .collection("countdown_events/${user?.uid}/events")
                  .add({"name": request?["name"], "date": DateTime.now()});
            },
            isSuccessfull: (response) {
              return true;
            },
            getMessage: (response) {
              return "";
            },
            resultCallback: (request, response, message, state) {
              if (state.isSuccess()) {}
            },
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
    );
  }
}
