import 'package:flutter/material.dart';

class VertDivider extends StatelessWidget {
  const VertDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      color: Colors.white,
      indent: 10,
      endIndent: 10,
      thickness: 1,
    );
  }
}
