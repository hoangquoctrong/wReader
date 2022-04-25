import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:wreader/Screen/content_screen.dart';
import 'package:wreader/Screen/content_screen_read.dart';
import 'package:wreader/components/Databases/favoriteDAO.dart';
import 'package:wreader/components/Databases/history.dart';
import 'package:wreader/constants/constants.dart';
import 'package:wreader/widgets/HorDivider.dart';

class MangaChapters extends StatefulWidget {
  final String mangaLink;
  final String mangaTitle;
  final String mangaImg;
  final String mangaDesc;
  final String mangaGenres;
  final String mangaAuthor;
  final int sourceID;
  final List<Map<String, dynamic>>? mangaChapter;
  const MangaChapters({
    Key? key,
    required this.mangaLink,
    required this.mangaTitle,
    required this.mangaImg,
    required this.mangaDesc,
    required this.mangaGenres,
    required this.mangaAuthor,
    this.mangaChapter,
    required this.sourceID,
  }) : super(key: key);

  @override
  _MangaChaptersState createState() => _MangaChaptersState();
}

class _MangaChaptersState extends State<MangaChapters> {
  bool isLoading = false;

  void SaveIntoDB(
      String mangaChapter, String mangaChapterLink, int index) async {
    History history = new History(
      mangaTitle: widget.mangaTitle,
      mangaLink: widget.mangaLink,
      mangaImg: widget.mangaImg,
      mangaDesc: widget.mangaDesc,
      mangaGenres: widget.mangaGenres,
      mangaAuthor: widget.mangaAuthor,
      mangaChapter: mangaChapter,
      mangaChapterLink: mangaChapterLink,
      mangaChapterIndex: index,
      sourceID: widget.sourceID,
      id: DateTime.now().millisecondsSinceEpoch,
    );
    if (await FavoriteDatabase.instance
            .checkHistory(widget.mangaLink.toString()) ==
        true) {
      await FavoriteDatabase.instance.updateHistory(history);
      print("run update");
    } else {
      await FavoriteDatabase.instance.createHistory(history);
      print("run create");
    }
    print(widget.mangaLink.toString());
  }

  @override
  void initState() {
    print("mangalink: " + widget.mangaLink);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.darkgray,
        appBar: AppBar(
          title: Text(widget.mangaTitle.toString()),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                child: ListView.builder(
                    itemCount: widget.mangaChapter!.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          HorDivider(),
                          Container(
                            height: 50,
                            width: double.infinity,
                            child: Material(
                              color: Constants.darkgray,
                              child: InkWell(
                                onTap: () => {
                                  widget.sourceID == 4
                                      ? {
                                          SaveIntoDB(
                                              widget.mangaChapter![index]
                                                  ['title'],
                                              "https://ln.hako.re" +
                                                  widget.mangaChapter![index]
                                                      ['attributes']['href'],
                                              index),
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new ContentScreenRead(
                                                mangaLink: widget.mangaLink,
                                                mangaChapter:
                                                    widget.mangaChapter,
                                                index: index,
                                                mangaAuthor: widget.mangaAuthor,
                                                mangaDesc: widget.mangaDesc,
                                                mangaGenres: widget.mangaGenres,
                                                mangaImg: widget.mangaImg,
                                                mangaTitle: widget.mangaTitle,
                                                mangaChapterLink:
                                                    "https://ln.hako.re" +
                                                        widget.mangaChapter![
                                                                    index]
                                                                ['attributes']
                                                            ['href'],
                                                id: widget.sourceID,
                                              ),
                                            ),
                                          )
                                        }
                                      : {
                                          SaveIntoDB(
                                              widget.mangaChapter![index]
                                                  ['title'],
                                              widget.mangaChapter![index]
                                                  ['attributes']['href'],
                                              index),
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new ContentScreen(
                                                mangaLink: widget.mangaLink,
                                                mangaChapter:
                                                    widget.mangaChapter,
                                                index: index,
                                                mangaAuthor: widget.mangaAuthor,
                                                mangaDesc: widget.mangaDesc,
                                                mangaGenres: widget.mangaGenres,
                                                mangaImg: widget.mangaImg,
                                                mangaTitle: widget.mangaTitle,
                                                mangaChapterLink:
                                                    widget.mangaChapter![index]
                                                        ['attributes']['href'],
                                                id: widget.sourceID,
                                              ),
                                            ),
                                          ),
                                        }
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.mangaChapter![index]['title'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ));
  }
}
// class MangaChapters extends StatelessWidget {
//   final List<Map<String, dynamic>>? mangaChapter;
//   const MangaChapters({Key? key, this.mangaChapter}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListView.builder(
//           itemCount: mangaChapter!.length,
//           shrinkWrap: true,
//           physics: BouncingScrollPhysics(),
//           itemBuilder: (context, index) {
//             return Column(
//               children: [
//                 HorDivider(),
//                 Container(
//                   height: 50,
//                   width: double.infinity,
//                   child: Material(
//                     color: Constants.darkgray,
//                     child: InkWell(
//                       onTap: () => {
//                         Navigator.of(context).push(
//                           new MaterialPageRoute(
//                             builder: (BuildContext context) =>
//                                 new ContentScreen(
//                               mangaLink: mangaChapter![index]['attributes']
//                                   ['href'],
//                               mangaChapter: mangaChapter,
//                               index: index,
//                             ),
//                           ),
//                         ),
//                       },
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           mangaChapter![index]['title'],
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }),
//     );
//   }
// }
