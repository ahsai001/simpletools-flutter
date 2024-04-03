import 'package:flutter/material.dart';
import 'package:flutter_alcore/flutter_alcore.dart';

class DoaDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const DoaDetailPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: AppBarTitleText(data['title']),
      ),
      body: CustomPadding(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data['arabic'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: "usmani", fontSize: 30)),
              const SpaceHeight(
                height: 20,
              ),
              const Text(
                "Transliterasi",
                style: TextStyle(fontSize: 20),
              ),
              Text(data['trans'], style: const TextStyle(fontSize: 15)),
              const SpaceHeight(
                height: 20,
              ),
              const Text(
                "Terjemah",
                style: TextStyle(fontSize: 20),
              ),
              Text(data['arti'], style: const TextStyle(fontSize: 15)),
              const SpaceHeight(
                height: 20,
              ),
              const Text(
                "Referensi",
                style: TextStyle(fontSize: 20),
              ),
              Text(data['ref'], style: const TextStyle(fontSize: 15))
            ],
          ),
        ),
      ),
    );
  }
}
