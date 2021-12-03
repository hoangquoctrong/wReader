import 'package:flutter/material.dart';
import 'package:wreader/constants/constants.dart';

class MangaDesc extends StatefulWidget {
  final String? mangaDesc, mangaGenres;
  const MangaDesc({Key? key, this.mangaDesc, this.mangaGenres})
      : super(key: key);

  @override
  _MangaDescState createState() => _MangaDescState();
}

class _MangaDescState extends State<MangaDesc> {
  bool readMore = false;

  void ToggleRead() {
    setState(() {
      readMore = !readMore;
    });
  }

  Widget overMultiLine() {
    return (widget.mangaDesc!.trim()).split(" ").length > 40
        ? GestureDetector(
            onTap: ToggleRead,
            child: Text(
              readMore ? "Rút ngắn" : "Đọc thêm",
              style: TextStyle(color: Constants.lightblue),
            ),
          )
        : Container();
  }

  _MangaDescState();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mô tả",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.mangaDesc!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            maxLines: readMore ? 100 : 3,
            overflow: TextOverflow.ellipsis,
          ),
          overMultiLine(),
          Text(
            "Thể loại",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.mangaGenres!,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
