import 'package:flutter/material.dart';
import 'package:wreader/components/HomeScreenComponents/detailScreen/manga_chapters.dart';
import 'package:wreader/widgets/VertDivider.dart';
import 'package:wreader/widgets/manga_info.dart';

class MangaInfo extends StatelessWidget {
  final String? mangaImg, mangaStatus, mangaAuthor, mangaLink, mangaTitle;

  const MangaInfo({
    Key? key,
    this.mangaImg,
    this.mangaStatus,
    this.mangaAuthor,
    this.mangaLink,
    this.mangaTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.4,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenSize.width * 0.05,
                ),
                Container(
                    width: screenSize.width * 0.29,
                    child: Image.network(
                      mangaImg!,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  width: screenSize.width * 0.05,
                ),
                Text(
                  "Tác giả: $mangaAuthor \n \nTrạng thái: $mangaStatus",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new MangaChapters(
                        mangaTitle: mangaTitle,
                        mangaLink: mangaLink,
                      ),
                    ));
                  },
                  child: MangaInfoBtn(
                    icon: Icons.menu_open_outlined,
                    title: "Chapters",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
