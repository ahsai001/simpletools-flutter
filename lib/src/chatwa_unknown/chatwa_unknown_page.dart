// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_alcore/flutter_alcore.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatWAUnknownPage extends StatelessWidget {
  const ChatWAUnknownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberTEC = TextEditingController();
    final messageTEC = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitleText("Chat WA to number"),
      ),
      body: CustomPadding(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledTextField(
            controller: numberTEC,
            label: "WA Number",
            decoration:
                const InputDecoration(hintText: "format 6285611111111111"),
          ),
          const SpaceHeight(),
          LabeledTextField(
            controller: messageTEC,
            label: "Message",
            maxLines: 5,
          ),
          const SpaceHeight(),
          RoundedElevatedButton(
            child: const Text("Open WA"),
            onPressed: () async {
              if (!await launchUrl(
                  Uri.parse(
                      "https://wa.me/${numberTEC.text}?text=${Uri.encodeFull(messageTEC.text)}"),
                  mode: LaunchMode.externalApplication)) {
                throw 'Gagal luncurkan';
              }
            },
          )
        ],
      )),
    );
  }
}
