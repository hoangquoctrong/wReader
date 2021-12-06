import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:wreader/components/HomeScreenComponents/manga_cards.dart';
import 'package:wreader/constants/constants.dart';

class MangaList extends StatefulWidget {
  final List<String> titleList;
  final List<String> urlList;
  final List<String> imgList;
  const MangaList({
    Key? key,
    required this.titleList,
    required this.urlList,
    required this.imgList,
  }) : super(key: key);

  @override
  _MangaListState createState() => _MangaListState();
}

class _MangaListState extends State<MangaList> {
  List<String>? titleList = [];
  List<String>? urlList = [];
  List<String>? imgList = [];
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
    setState(() {
      titleList = [];
      urlList = [];
      imgList = [];
    });
    final webscraper = WebScraper(Constants.baseUrl);
    switch (Constants.id) {
      case 1:
        {
          if (await webscraper.loadWebPage("?page=" + page.toString())) {
            newmangaList = webscraper.getElement(
                'div.manga-content > div.row.px-2.list-item > div.col-6.col-md-3.badge-pos-1.px-2 > div.page-item-detail > div.item-thumb.hover-details.c-image-hover > a > img.img-responsive',
                [
                  'src',
                  'title',
                  'data-src',
                ]);
            newmangaUrlList = webscraper.getElement(
              'div.manga-content > div.row.px-2.list-item > div.col-6.col-md-3.badge-pos-1.px-2 > div.page-item-detail > div.item-thumb.hover-details.c-image-hover > a',
              ['href'],
            );
            for (int i = 0; i < newmangaList!.length; i++) {
              titleList!.add(newmangaList![i]['attributes']['title']);
              urlList!.add(newmangaUrlList![i]['attributes']['href']);
              newmangaList![i]['attributes']['src'] == null
                  ? imgList!.add(newmangaList![i]['attributes']['data-src'])
                  : imgList!.add(newmangaList![i]['attributes']['src']);
            }
            page = 2;
            setState(() {});
          }
          break;
        }
      case 3:
        {
          if (await webscraper.loadWebPage("")) {
            newmangaList = webscraper.getElement(
              'div.ModuleContent > div.items > div.row > div.item > figure.clearfix > div.image > a > img.lazy',
              ['data-original', 'alt'],
            );
            newmangaUrlList = webscraper.getElement(
              'div.ModuleContent > div.items > div.row > div.item > figure.clearfix > div.image > a',
              ['href'],
            );
            for (int i = 0; i < newmangaList!.length; i++) {
              titleList!.add(newmangaList![i]['attributes']['alt']
                  .toString()
                  .substring(13,
                      newmangaList![i]['attributes']['alt'].toString().length));
              urlList!.add(newmangaUrlList![i]['attributes']['href']);

              imgList!.add(newmangaList![i]['attributes']['data-original']);
            }
            page = 2;

            setState(() {});
          }
          break;
        }
      case 4:
        {
          if (await webscraper.loadWebPage(
              "danh-sach?truyendich=1&sapxep=capnhat&page=" +
                  page.toString())) {
            newmangaList = webscraper.getElement(
                'main.row > div.thumb-item-flow.col-4.col-md-3.col-lg-2 > div.thumb-wrapper.ln-tooltip > a > div.a6-ratio > div.content',
                [
                  'data-bg',
                ]);
            newmangaUrlList = webscraper.getElement(
              'main.row > div.thumb-item-flow.col-4.col-md-3.col-lg-2 > div.thumb_attr.series-title > a',
              ['href'],
            );
            for (int i = 0; i < newmangaList!.length; i++) {
              titleList!.add(newmangaUrlList![i]['title']);
              urlList!.add("https://ln.hako.re" +
                  newmangaUrlList![i]['attributes']['href']);
              imgList!.add(newmangaList![i]['attributes']['data-bg']);
            }
            page = 2;

            setState(() {});
          }
          break;
        }
      default:
        final webTemp = 'comic?page=1';
        if (await webscraper.loadWebPage(webTemp)) {
          newmangaList = webscraper.getElement(
            'div.content > div.box > div.card-list > div.card > a > img.card-img',
            ['src', 'alt'],
          );
          newmangaUrlList = webscraper.getElement(
            'div.content > div.box > div.card-list > div.card > a',
            ['href'],
          );
          for (int i = 0; i <= newmangaList!.length - 1; i++) {
            titleList!.add(newmangaList![i]['attributes']['alt']);
            urlList!.add(newmangaUrlList![i]['attributes']['href']);
            imgList!.add(newmangaList![i]['attributes']['data-original']);
          }
          page = 2;
          setState(() {});
        }
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
    switch (Constants.id) {
      case 4:
        {
          if (await webscraper.loadWebPage(
              "danh-sach?truyendich=1&sapxep=capnhat&page=" +
                  page.toString())) {
            newmangaList = webscraper.getElement(
                'main.row > div.thumb-item-flow.col-4.col-md-3.col-lg-2 > div.thumb-wrapper.ln-tooltip > a > div.a6-ratio > div.content',
                [
                  'data-bg',
                ]);
            newmangaUrlList = webscraper.getElement(
              'main.row > div.thumb-item-flow.col-4.col-md-3.col-lg-2 > div.thumb_attr.series-title > a',
              ['href'],
            );
            for (int i = 0; i < newmangaList!.length; i++) {
              titleList!.add(newmangaUrlList![i]['title']);
              urlList!.add("https://ln.hako.re" +
                  newmangaUrlList![i]['attributes']['href']);
              imgList!.add(newmangaList![i]['attributes']['data-bg']);
            }
            page++;
            print(page);
            setState(() {});
          }
          break;
        }
      case 1:
        {
          if (await webscraper.loadWebPage("?page=" + page.toString())) {
            newmangaList = webscraper.getElement(
                'div.manga-content > div.row.px-2.list-item > div.col-6.col-md-3.badge-pos-1.px-2 > div.page-item-detail > div.item-thumb.hover-details.c-image-hover > a > img.img-responsive',
                [
                  'src',
                  'title',
                  'data-src',
                ]);
            newmangaUrlList = webscraper.getElement(
              'div.manga-content > div.row.px-2.list-item > div.col-6.col-md-3.badge-pos-1.px-2 > div.page-item-detail > div.item-thumb.hover-details.c-image-hover > a',
              ['href'],
            );
            for (int i = 0; i < newmangaList!.length; i++) {
              titleList!.add(newmangaList![i]['attributes']['title']);
              urlList!.add(newmangaUrlList![i]['attributes']['href']);
              newmangaList![i]['attributes']['src'] == null
                  ? imgList!.add(newmangaList![i]['attributes']['data-src'])
                  : imgList!.add(newmangaList![i]['attributes']['src']);
            }
            page++;

            setState(() {});
          }
          break;
        }
      case 3:
        if (await webscraper.loadWebPage("?page=" + page.toString())) {
          newmangaList = webscraper.getElement(
            'div.ModuleContent > div.items > div.row > div.item > figure.clearfix > div.image > a > img.lazy',
            ['data-original', 'alt'],
          );
          newmangaUrlList = webscraper.getElement(
            'div.ModuleContent > div.items > div.row > div.item > figure.clearfix > div.image > a',
            ['href'],
          );
          for (int i = 0; i < newmangaList!.length; i++) {
            titleList!.add(newmangaList![i]['attributes']['alt']
                .toString()
                .substring(13,
                    newmangaList![i]['attributes']['alt'].toString().length));
            urlList!.add(newmangaUrlList![i]['attributes']['href']);

            imgList!.add(newmangaList![i]['attributes']['data-original']);
          }
          page++;

          setState(() {});
        }
        break;
      default:
        {
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
            for (int i = 0; i <= newmangaList!.length - 1; i++) {
              titleList!.add(newmangaList![i]['attributes']['alt']);
              urlList!.add(newmangaUrlList![i]['attributes']['href']);
              imgList!.add(newmangaList![i]['attributes']['src']);
            }
            setState(() {
              page++;
            });
          }
        }
    }
  }

  @override
  void initState() {
    titleList = widget.titleList;
    imgList = widget.imgList;
    urlList = widget.urlList;
    print(imgList!.length.toString() + "titleList length");
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
                    height: screenSize.height * 0.1,
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Mới cập nhật",
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  for (int i = 0; i < titleList!.length; i++)
                    mangaCard(
                      mangaImg: imgList![i],
                      mangaTitle: titleList![i],
                      mangaUrl: urlList![i],
                      sourceID: Constants.id,
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
