import 'package:flutter/material.dart';
import 'package:wreader/Screen/content_screen.dart';
import 'package:wreader/Screen/detail_screen.dart';
import 'package:wreader/Screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomeScreen(),
      // home: DetailScreen(
      //   mangaImg:
      //       "http://st.imageinstant.net/data/comics/133/khong-doi-nao-mot-nhan-vat-phu-nhu-toi-c-8908.jpg",
      //   mangaTitle:
      //       "KHÔNG ĐỜI NÀO MỘT NHÂN VẬT PHỤ NHƯ TÔI CÓ THỂ NỔI TIẾNG , .... NHỈ?",
      //   mangaLink:
      //       "http://www.nettruyenpro.com/truyen-tranh/khong-doi-nao-mot-nhan-vat-phu-nhu-toi-co-the-noi-tieng-nhi-40581",
      // ),
    );
  }
}
