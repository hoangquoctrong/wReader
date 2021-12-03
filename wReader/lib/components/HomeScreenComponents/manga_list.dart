import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:wreader/components/HomeScreenComponents/manga_cards.dart';
import 'package:wreader/constants/constants.dart';

class MangaList extends StatefulWidget {
  final List<Map<String, dynamic>>? mangaList;
  final List<Map<String, dynamic>>? mangaUrlList;
  const MangaList({Key? key, this.mangaList, this.mangaUrlList})
      : super(key: key);

  @override
  _MangaListState createState() => _MangaListState();
}

class _MangaListState extends State<MangaList> {
  List<Map<String, dynamic>>? mangaList;
  List<Map<String, dynamic>>? mangaUrlList;
  List<Map<String, dynamic>>? newmangaList;
  List<Map<String, dynamic>>? newmangaUrlList;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isLoading = false;
  int page = 2;
  void _onRefresh() async {
    // monitor network fetch
    await RefreshData();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future<void> RefreshData() async {
    setState(() {});
    final webscraper = WebScraper(Constants.baseUrl);
    final webTemp = 'comic?page=1';
    if (await webscraper.loadWebPage(webTemp)) {
      mangaList = webscraper.getElement(
        'div.content > div.box > div.card-list > div.card > a > img.card-img',
        ['src', 'alt'],
      );
      mangaUrlList = webscraper.getElement(
        'div.content > div.box > div.card-list > div.card > a',
        ['href'],
      );
      page = 2;
      setState(() {});
      print(mangaList);
    }
  }

  void _onLoading() async {
    // monitor network fetch
    await _getMoreData(page);
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<void> _getMoreData(int index) async {
    final webscraper = WebScraper(Constants.baseUrl);
    final webTemp = 'comic?page=' + page.toString();
    if (await webscraper.loadWebPage(webTemp)) {
      newmangaList = webscraper.getElement(
        'div.content > div.box > div.card-list > div.card > a > img.card-img',
        ['src', 'alt'],
      );
      newmangaUrlList = webscraper.getElement(
        'div.content > div.box > div.card-list > div.card > a',
        ['href'],
      );
      mangaList!.addAll(newmangaList!);
      mangaUrlList!.addAll(newmangaUrlList!);
    }
    setState(() {
      page++;
    });
  }

  @override
  void initState() {
    mangaList = widget.mangaList;
    mangaUrlList = widget.mangaUrlList;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height,
      width: double.infinity,
      color: Constants.black,
      child: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        controller: _refreshController,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Wrap(
                children: [
                  Center(
                    child: isLoading ? CircularProgressIndicator() : SizedBox(),
                  ),
                  Container(
                    width: double.infinity,
                    height: 30,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Mới cập nhật",
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  for (int i = 0; i < mangaList!.length; i++)
                    mangaCard(
                      mangaImg: mangaList![i]['attributes']['src'],
                      mangaTitle: mangaList![i]['attributes']['alt'],
                      mangaUrl: mangaUrlList![i]['attributes']['href'],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
// class MangaList extends StatelessWidget {
//   final List<Map<String, dynamic>>? mangaList;
//   final List<Map<String, dynamic>>? mangaUrlList;
//   const MangaList({Key? key, this.mangaList, this.mangaUrlList})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     return Container(
//       height: screenSize.height,
//       width: double.infinity,
//       color: Constants.black,
//       child: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Wrap(
//           children: [
//             Container(
//               width: double.infinity,
//               height: 30,
//               padding: EdgeInsets.only(left: 10),
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 mangaList!.length.toString() + ' mangas',
//                 style: TextStyle(
//                   fontSize: 23,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             for (int i = 0; i < mangaList!.length; i++)
//               mangaCard(
//                 mangaImg: mangaList![i]['attributes']['src'],
//                 mangaTitle: mangaList![i]['attributes']['alt'],
//                 mangaUrl: mangaUrlList![i]['attributes']['href'],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
