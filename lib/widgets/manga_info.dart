import 'package:flutter/material.dart';

class MangaInfoBtn extends StatelessWidget {
  final IconData? icon;
  final String? title;
  const MangaInfoBtn({Key? key, this.icon, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: Colors.lightBlue,
        ),
        Text(
          title!,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
