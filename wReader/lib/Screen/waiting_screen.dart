import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wreader/Screen/drive_screen.dart';
import 'package:wreader/Screen/google_sign_in.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sao lưu dữ liệu"),
      ),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return DriveScreen();
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Có lỗi xảy ra!"),
            );
          } else {
            return GoogleSignIn();
          }
        },
      ),
    );
  }
}
