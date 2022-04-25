import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wreader/constants/constants.dart';

class LinkDialog extends StatefulWidget {
  final String mangaLink;
  const LinkDialog({Key? key, required this.mangaLink}) : super(key: key);

  @override
  _LinkDialogState createState() => _LinkDialogState();
}

class _LinkDialogState extends State<LinkDialog> {
  void _lauchURL() async {
    if (await launch(widget.mangaLink))
      throw 'Could not launch ${widget.mangaLink}';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => Dialogs.materialDialog(
          msg: widget.mangaLink,
          title: "Mở đường link ",
          color: Constants.lightgray,
          context: context,
          actions: [
            IconsOutlineButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'Hủy',
              iconData: Icons.cancel_outlined,
              textStyle: TextStyle(color: Colors.grey),
              iconColor: Colors.grey,
            ),
            IconsButton(
              onPressed: () {
                _lauchURL();
              },
              text: "Mở",
              iconData: Icons.link,
              color: Colors.green,
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ]),
      child: Icon(Icons.link),
    );
  }
}
// class LinkDialog extends StatelessWidget {
//   final String MangaLink;
//   const LinkDialog({Key? key, required this.MangaLink}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialButton(
//       color: Colors.grey[300],
//       minWidth: 300,
//       onPressed: () => Dialogs.materialDialog(
//           msg: MangaLink,
//           title: "Di chuyển đến đường dẫn",
//           color: Colors.white,
//           context: context,
//           actions: [
//             IconsOutlineButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               text: 'Hủy',
//               iconData: Icons.cancel_outlined,
//               textStyle: TextStyle(color: Colors.grey),
//               iconColor: Colors.grey,
//             ),
//             IconsButton(
//               onPressed: () {},
//               text: "Mở trình duyệt",
//               iconData: Icons.delete,
//               color: Colors.red,
//               textStyle: TextStyle(color: Colors.white),
//               iconColor: Colors.white,
//             ),
//           ]),
//       child: Text("Show Material Dialog"),
//     );
//   }
// }
