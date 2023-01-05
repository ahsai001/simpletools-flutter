import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simpletools/src/widget/custom_light_theme_widget.dart';
import 'package:simpletools/src/widget/custom_padding.dart';

Widget spaceH([double h = 10]) {
  return SizedBox(height: h);
}

Widget spaceW([double w = 10]) {
  return SizedBox(width: w);
}

Widget spaceWH([double w = 10, double h = 10]) {
  return SizedBox(
    width: w,
    height: h,
  );
}

InputDecoration customInputDecoration(
    String hintText, String counterText, Widget suffixIcon) {
  return InputDecoration(
    counterText: counterText,
    suffixIcon: suffixIcon,
    //filled: false,
    //fillColor: color,
    hintText: hintText,
  );
}

String capitalize(String? str) {
  if (str == null) return '';
  return str[0].toUpperCase() + str.substring(1).toLowerCase();
}

String getNumber(String value) {
  return NumberFormat.decimalPattern().format(double.parse(value));
}

double getNumber2(String value) {
  return double.parse(value);
}

int getDateInMS(String? dateTime) {
  if (dateTime == null) return 0;
  return DateTime.parse(dateTime).millisecondsSinceEpoch;
}

Widget getKeyValueWidget(String key, String value, {double width = 80}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        width: width,
        child: Text(key),
      ),
      const Text(" : "),
      Expanded(
        child: Text(
          value,
          overflow: TextOverflow.visible,
        ),
      ),
    ],
  );
}

void showSnackBar(BuildContext context, String info) {
  var scaffoldMessengerState = ScaffoldMessenger.of(context);
  scaffoldMessengerState.hideCurrentSnackBar();
  scaffoldMessengerState.showSnackBar(SnackBar(content: Text(info)));
}

String convertDate(String? value, {String? fromFormat, String? toFormat}) {
  if (value == null) return "-";
  if (value.isEmpty) return "-";
  return DateFormat(toFormat ?? "dd MMM yyyy").format(fromFormat != null
      ? DateFormat(fromFormat).parse(value)
      : DateTime.parse(value));
}

String handleNullEmpty(String? value) {
  if (value == null) return "-";
  if (value.isEmpty) return "-";
  return value;
}

String titleCase(String name) {
  final stringBuffer = StringBuffer();

  var capitalizeNext = true;
  for (final letter in name.toLowerCase().codeUnits) {
    // UTF-16: A-Z => 65-90, a-z => 97-122.
    if (capitalizeNext && letter >= 97 && letter <= 122) {
      stringBuffer.writeCharCode(letter - 32);
      capitalizeNext = false;
    } else {
      // UTF-16: 32 == space, 46 == period
      if (letter == 32 || letter == 46) capitalizeNext = true;
      stringBuffer.writeCharCode(letter);
    }
  }

  return stringBuffer.toString();
}

Widget makeScrollable(Widget w,
    {double width = 2000.0, double height = 2000.0}) {
  return Scrollbar(
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
              width: width,
              height: height,
              child: ListView(
                children: [
                  SizedBox(
                    width: width,
                    height: height,
                    child: w,
                  )
                ],
              ))));
}

void showWidgetsInDialog(
    BuildContext context, String title, Widget widget) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomLightThemeWidget(
          child: AlertDialog(
            title: AppBar(
              title: Text(title,
                  style: const TextStyle(
                    fontSize: 14,
                  )),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            titlePadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(0),
            content: StatefulBuilder(builder: (context, setState) {
              final ScrollController controller = ScrollController();
              return Scrollbar(
                thumbVisibility: true,
                controller: controller,
                child: CustomPadding(
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                        mainAxisSize: MainAxisSize.min, children: [widget]),
                  ),
                ),
              );
            }),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(1000)))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"))
            ],
          ),
        );
      });
}
