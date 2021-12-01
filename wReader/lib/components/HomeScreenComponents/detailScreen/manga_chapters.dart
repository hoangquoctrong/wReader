import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:wreader/Screen/content_screen.dart';
import 'package:wreader/constants/constants.dart';
import 'package:wreader/widgets/HorDivider.dart';

class MangaChapters extends StatefulWidget {
  final String? mangaLink;
  final String? mangaTitle;
  const MangaChapters({Key? key, this.mangaLink, required this.mangaTitle})
      : super(key: key);

  @override
  _MangaChaptersState createState() => _MangaChaptersState();
}

class _MangaChaptersState extends State<MangaChapters> {
  bool isLoading = true;
  List<Map<String, dynamic>>? mangaChapter;
  void getChapters() async {
    isLoading = true;
    String tempBaseUrl = widget.mangaLink!.split(".net")[0] + ".net";
    String tempRoute = widget.mangaLink!.split(".net")[1];
    print(tempBaseUrl);
    print(tempRoute);

    final webscraper = WebScraper(tempBaseUrl);
    if (await webscraper.loadWebPage(tempRoute)) {
      mangaChapter = webscraper.getElement(
        "div.chapter-list-item-box > div.chapter-select > a",
        ['href'],
      );
      print(mangaChapter);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getChapters();
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
                    itemCount: mangaChapter!.length,
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
                                  Navigator.of(context).push(
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new ContentScreen(
                                        mangaLink: mangaChapter![index]
                                            ['attributes']['href'],
                                        mangaChapter: mangaChapter,
                                        index: index,
                                      ),
                                    ),
                                  ),
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    mangaChapter![index]['title'],
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
