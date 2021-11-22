import 'package:flutter/material.dart';
import 'package:wreader/components/HomeScreenComponents/manga_cards.dart';
import 'package:wreader/constants/constants.dart';

class MangaList extends StatelessWidget {
  final List<Map<String, dynamic>>? mangaList;
  final List<Map<String, dynamic>>? mangaUrlList;
  const MangaList({Key? key, this.mangaList, this.mangaUrlList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height,
      width: double.infinity,
      color: Constants.black,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Wrap(
          children: [
            Container(
              width: double.infinity,
              height: 30,
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                mangaList!.length.toString() + ' mangas',
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.white,
                ),
              ),
            ),
            for (int i = 0; i < mangaList!.length; i++)
              mangaCard(
                mangaImg: mangaList![i]['attributes']['data-original'],
                mangaTitle: mangaList![i]['attributes']['alt']
                    .toString()
                    .substring(13,
                        mangaList![i]['attributes']['alt'].toString().length),
                mangaUrl: mangaUrlList![i]['attributes']['href'],
              ),
          ],
        ),
      ),
    );
  }
}
