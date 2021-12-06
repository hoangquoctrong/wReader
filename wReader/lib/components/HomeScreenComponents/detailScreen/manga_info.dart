import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:swipe_back_detector/swipe_back_detector.dart';
import 'package:wreader/Screen/content_screen.dart';
import 'package:wreader/Screen/content_screen_read.dart';
import 'package:wreader/components/Databases/favorite.dart';
import 'package:wreader/components/Databases/favoriteDAO.dart';
import 'package:wreader/components/Databases/history.dart';
import 'package:wreader/components/HomeScreenComponents/detailScreen/manga_chapters.dart';
import 'package:wreader/constants/constants.dart';
import 'package:wreader/widgets/VertDivider.dart';
import 'package:wreader/widgets/manga_info.dart';

class MangaInfo extends StatefulWidget {
  final String? mangaImg, mangaStatus, mangaAuthor, mangaLink, mangaTitle;
  final int sourceID;
  final List<Map<String, dynamic>>? mangaChapter;

  final bool? isFavorite;
  const MangaInfo({
    Key? key,
    this.mangaImg,
    this.mangaStatus,
    this.mangaAuthor,
    this.mangaLink,
    this.mangaTitle,
    this.isFavorite,
    this.mangaChapter,
    required this.sourceID,
  }) : super(key: key);

  @override
  _MangaInfoState createState() => _MangaInfoState();
}

class _MangaInfoState extends State<MangaInfo> {
  bool? isFavorite;
  List<Favorite>? mangaList;
  int id = DateTime.now().millisecondsSinceEpoch;
  History? history;
  Future<void> FavoriteChange() async {
    if (isFavorite == true) {
      isFavorite = false;
      await FavoriteDatabase.instance.delete(widget.mangaLink.toString());
      setState(() {});
    } else {
      mangaList = await FavoriteDatabase.instance.readAllFavorite();
      isFavorite = true;
      final favorite = Favorite(
        mangaLink: widget.mangaLink.toString(),
        mangaImg: widget.mangaImg.toString(),
        mangaDesc: "",
        mangaGenres: "",
        mangaAuthor: widget.mangaAuthor.toString(),
        mangaTitle: widget.mangaTitle.toString(),
        id: id,
        sourceID: widget.sourceID,
      );
      await FavoriteDatabase.instance.create(favorite);
      setState(() {});
    }
  }

  void checkHistory() async {
    if (await FavoriteDatabase.instance
            .checkHistory(widget.mangaLink.toString()) ==
        true) {
      List<History> historyList = await FavoriteDatabase.instance
          .readHistory(widget.mangaLink.toString());
      history = historyList[0];
      print("check history: " + history!.mangaChapterIndex.toString());
    } else {
      history = new History(
        mangaTitle: widget.mangaTitle.toString(),
        mangaLink: widget.mangaLink.toString(),
        mangaImg: widget.mangaImg.toString(),
        mangaDesc: "",
        mangaGenres: "",
        mangaAuthor: "",
        mangaChapter: widget.mangaChapter![widget.mangaChapter!.length - 1]
            ['title'],
        mangaChapterLink: widget.sourceID == 4
            ? "https://ln.hako.re" +
                widget.mangaChapter![0]['attributes']['href']
            : widget.mangaChapter![0]['attributes']['href'],
        mangaChapterIndex:
            widget.sourceID == 4 ? 0 : widget.mangaChapter!.length - 1,
        id: DateTime.now().millisecondsSinceEpoch,
        sourceID: Constants.id,
      );
      print(history!.mangaChapter);
      print(history!.mangaChapterLink);
      print(history!.mangaLink);
      print(history!.mangaChapterIndex);
      await FavoriteDatabase.instance.createHistory(history!);
      print("run create");
    }
  }

  void readHistory() async {
    List<History> readHistory =
        await FavoriteDatabase.instance.readHistory(widget.mangaLink!);
    history = readHistory[0];
  }

  void navigatorPush(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = Offset(1.0, 0.0);
          final end = Offset.zero;
          final curve = Curves.ease;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SwipeBackDetector(
            child: SlideTransition(
              position: animation.drive(tween),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    checkHistory();
    isFavorite = widget.isFavorite;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.45,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: screenSize.height * 0.3,
            width: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.mangaImg!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenSize.width * 0.05,
                ),
                Container(
                    width: screenSize.width * 0.29,
                    child: Image.network(
                      widget.mangaImg!,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  width: screenSize.width * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: screenSize.width * 0.6,
                        child: Text(
                          widget.mangaTitle!,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20.0),
                        width: screenSize.width * 0.6,
                        child: Text(
                          "Tác giả: " + widget.mangaAuthor.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            height: screenSize.height * 0.15,
            width: screenSize.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    readHistory();
                    widget.sourceID == 4
                        ? Navigator.of(context).push(
                            new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new ContentScreenRead(
                                      mangaLink: history!.mangaLink,
                                      mangaChapter: widget.mangaChapter,
                                      index: history!.mangaChapterIndex,
                                      mangaAuthor: history!.mangaAuthor,
                                      mangaDesc: history!.mangaDesc,
                                      mangaGenres: history!.mangaGenres,
                                      mangaImg: history!.mangaImg,
                                      mangaTitle: history!.mangaTitle,
                                      mangaChapterLink:
                                          history!.mangaChapterLink,
                                      id: history!.sourceID),
                            ),
                          )
                        : Navigator.of(context).push(
                            new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new ContentScreen(
                                      mangaLink: history!.mangaLink,
                                      mangaChapter: widget.mangaChapter,
                                      index: history!.mangaChapterIndex,
                                      mangaAuthor: history!.mangaAuthor,
                                      mangaDesc: history!.mangaDesc,
                                      mangaGenres: history!.mangaGenres,
                                      mangaImg: history!.mangaImg,
                                      mangaTitle: history!.mangaTitle,
                                      mangaChapterLink:
                                          history!.mangaChapterLink,
                                      id: history!.sourceID),
                            ),
                          );
                  },
                  child: MangaInfoBtn(
                    icon: Icons.play_arrow_outlined,
                    title: "Đọc",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FavoriteChange();
                    setState(() {});
                  },
                  child: isFavorite!
                      ? MangaInfoBtn(
                          icon: Icons.favorite,
                          title: "Yêu thích",
                        )
                      : MangaInfoBtn(
                          icon: Icons.favorite_border_outlined,
                          title: "Yêu thích",
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    navigatorPush(
                      context,
                      new MangaChapters(
                        mangaAuthor: widget.mangaAuthor.toString(),
                        mangaDesc: "",
                        mangaGenres: "",
                        mangaImg: widget.mangaImg.toString(),
                        mangaLink: widget.mangaLink.toString(),
                        mangaTitle: widget.mangaTitle.toString(),
                        mangaChapter: widget.mangaChapter,
                        sourceID: history!.sourceID,
                      ),
                    );
                  },
                  child: MangaInfoBtn(
                    icon: Icons.menu_open_outlined,
                    title: "Mục lục",
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
// class MangaInfo extends StatelessWidget {
//   final String? mangaImg, mangaStatus, mangaAuthor, mangaLink, mangaTitle;

//   const MangaInfo({
//     Key? key,
//     this.mangaImg,
//     this.mangaStatus,
//     this.mangaAuthor,
//     this.mangaLink,
//     this.mangaTitle,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     return Container(
//       height: screenSize.height * 0.4,
//       width: double.infinity,
//       child: Column(
//         children: [
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   width: screenSize.width * 0.05,
//                 ),
//                 Container(
//                     width: screenSize.width * 0.29,
//                     child: Image.network(
//                       mangaImg!,
//                       fit: BoxFit.cover,
//                     )),
//                 SizedBox(
//                   width: screenSize.width * 0.05,
//                 ),
//                 Text(
//                   "Tác giả: $mangaAuthor \n \nTrạng thái: $mangaStatus",
//                   style: TextStyle(color: Colors.white, fontSize: 15),
//                 )
//               ],
//             ),
//           ),
//           Container(
//             height: 60,
//             width: screenSize.width,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 MangaInfoBtn(
//                   icon: Icons.play_arrow_outlined,
//                   title: "Read",
//                 ),
//                 VertDivider(),
//                 MangaInfoBtn(
//                   icon: Icons.favorite_border_outlined,
//                   title: "Favorite",
//                 ),
//                 VertDivider(),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).push(new MaterialPageRoute(
//                       builder: (BuildContext context) => new MangaChapters(
//                         mangaTitle: mangaTitle,
//                         mangaLink: mangaLink,
//                       ),
//                     ));
//                   },
//                   child: MangaInfoBtn(
//                     icon: Icons.menu_open_outlined,
//                     title: "Chapters",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
