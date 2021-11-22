import 'package:flutter/material.dart';
import 'package:wreader/widgets/VertDivider.dart';
import 'package:wreader/widgets/manga_info.dart';

class MangaInfo extends StatelessWidget {
  final String? mangaImg, mangaStatus, mangaAuthor;

  const MangaInfo({Key? key, this.mangaImg, this.mangaStatus, this.mangaAuthor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.4,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: screenSize.width * 0.3,
                      child: Image.network(
                        mangaImg!,
                        fit: BoxFit.cover,
                      )),
                  Text(
                    "Tác giả: $mangaAuthor \nTrạng thái: $mangaStatus",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            width: screenSize.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MangaInfoBtn(
                  icon: Icons.play_arrow_outlined,
                  title: "Read",
                ),
                VertDivider(),
                MangaInfoBtn(
                  icon: Icons.favorite_border_outlined,
                  title: "Favorite",
                ),
                VertDivider(),
                MangaInfoBtn(
                  icon: Icons.menu_open_outlined,
                  title: "Chapters",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
