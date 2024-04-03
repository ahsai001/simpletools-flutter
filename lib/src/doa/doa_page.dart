import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alcore/flutter_alcore.dart';
import 'package:simpletools/src/doa/doa_detail_page.dart';

class DoaPage extends StatefulWidget {
  const DoaPage({Key? key}) : super(key: key);

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  bool showSearch = false;
  String newKeyword = "";
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;

  @override
  void initState() {
    super.initState();

    //final user = FirebaseAuth.instance.currentUser;
    final collectionRef = FirebaseFirestore.instance.collection("doa");
    stream = collectionRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchableAppBar(
        appBarTitleText: "Doa doa",
        searchHintText: "Search doa",
        onSubmitted: (value) {
          setState(() {
            newKeyword = value;
          });
        },
        onClosed: () {
          if (newKeyword != "") {
            setState(() {
              newKeyword = "";
            });
          }
        },
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
                  children: snapshot.data!.docs.where((doc) {
                    Map<String, dynamic> data =
                        doc.data()! as Map<String, dynamic>;
                    return (data['title'] as String)
                        .toLowerCase()
                        .contains(newKeyword.toLowerCase());
                  }).map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            pushNewPageWithTransition(context,
                                (context) => DoaDetailPage(data: data));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text(
                                  data["title"],
                                  // style: const TextStyle(
                                  //     fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              })),
    );
  }
}
