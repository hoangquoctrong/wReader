import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wreader/components/firebaseapi.dart';
import 'package:wreader/components/googleSignInProvider.dart';
import 'package:wreader/constants/constants.dart';

class DriveScreen extends StatefulWidget {
  const DriveScreen({Key? key}) : super(key: key);

  @override
  _DriveScreenState createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  String DateAdded = "";
  UploadTask? task;
  double? _progress;
  final user = FirebaseAuth.instance.currentUser!;
  File? file;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    List<String> dir = directory.path.split("/app_flutter");
    print(dir[0]);
    return dir[0];
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/databases');
  }

  Future uploadFile() async {
    FirebaseFirestore.instance
        .collection('store data')
        .doc(user.uid.toString())
        .set({'Date': DateTime.now().toString(), 'Email': user.email});
    if (file == null) {
      print("Lỗi data");

      return;
    }

    final destination = '${user.email}/mangas.db';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) {
      print("lỗi task");
      return;
    }
    task!.snapshotEvents.listen((event) {
      setState(() {
        _progress =
            event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
        print(_progress.toString());
      });
      if (event.state == TaskState.success) {
        _progress = null;
        Fluttertoast.showToast(msg: 'Sao lưu file thành công');
      }
    }).onError((error) {
      // do something to handle error
    });
    final snapshot = await task!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download Link: $urlDownload');
  }

  getLastestDate() {
    return FirebaseFirestore.instance
        .collection('store data')
        .where('Email', isEqualTo: user.email)
        .get();
  }

  void getFile() async {
    file = await _localFile;
  }

  @override
  void initState() {
    // QuerySnapshot querySnapshot = getLastestDate();
    getFile();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ChangeNotifierProvider<GoogleSignInProvider>(
      create: (context) => GoogleSignInProvider(),
      child: Consumer<GoogleSignInProvider>(
          builder: (context, provider, child) => Container(
                color: Constants.darkgray,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenSize.height * 0.05,
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(user.photoURL!),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.01,
                    ),
                    Text("hoangquoctrong1111@gmail.com"),
                    SizedBox(
                      height: screenSize.height * 0.01,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          provider.Logout();
                        },
                        child: Text("Đăng xuất")),
                    SizedBox(
                      height: screenSize.height * 0.10,
                    ),
                    Text("Lần cuối cùng sao lưu : 8/12/2021 12:22P.M"),
                    SizedBox(
                      height: screenSize.height * 0.1,
                    ),
                    SizedBox(
                      height: screenSize.height * 0.1,
                    ),
                    _progress != null
                        ? Container(
                            height: screenSize.height * 0.05,
                            child: const CircularProgressIndicator())
                        : SizedBox(
                            height: screenSize.height * 0.05,
                          ),
                    SizedBox(
                      height: screenSize.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              uploadFile();
                            },
                            child: Text("Sao lưu")),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {}, child: Text("Phục hồi"))
                      ],
                    ),
                  ],
                ),
              )),
    );
  }

  Widget buildUpLoadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            return Text(
              '$percentage %',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          } else {
            return Container();
          }
        },
      );
}
