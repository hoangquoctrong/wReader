import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wreader/components/googleSignInProvider.dart';
import 'package:wreader/constants/constants.dart';

class GoogleSignIn extends StatefulWidget {
  const GoogleSignIn({Key? key}) : super(key: key);

  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoogleSignInProvider>(
      create: (context) => GoogleSignInProvider(),
      child: Consumer<GoogleSignInProvider>(
        builder: (context, provider, child) => Container(
          color: Constants.darkgray,
          child: Center(
              child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
            icon: FaIcon(FontAwesomeIcons.google),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            },
            label: Text("Đăng nhập với google"),
          )),
        ),
      ),
    );
  }
}
