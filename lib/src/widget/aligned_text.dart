import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AlignedText extends StatelessWidget {
  final String text;
  final AlignmentGeometry? alignment;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final TextStyle? style;
  const AlignedText(
    this.text, {
    Key? key,
    this.alignment,
    this.textAlign,
    this.textOverflow,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.centerRight,
      child: Text(
        text,
        textAlign: textAlign ?? TextAlign.left,
        overflow: textOverflow ?? TextOverflow.visible,
        style: style,
      ),
    );
  }
}
