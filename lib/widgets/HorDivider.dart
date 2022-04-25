import 'package:flutter/material.dart';
import 'package:wreader/constants/constants.dart';

class HorDivider extends StatelessWidget {
  const HorDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: screenSize.height * 0.0009,
      color: Colors.grey,
    );
  }
}
