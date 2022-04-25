import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:wreader/components/Databases/favoriteDAO.dart';
import 'package:wreader/components/Databases/history.dart';
import 'package:wreader/constants/constants.dart';
import 'package:wreader/widgets/HorDivider.dart';

class ContentScreenRead extends StatefulWidget {
  final String mangaLink;
  final String mangaTitle;
  final String mangaImg;
  final String mangaDesc;
  final String mangaGenres;
  final String mangaAuthor;
  final int index;
  final String mangaChapterLink;
  final List<Map<String, dynamic>>? mangaChapter;
  final int id;
  const ContentScreenRead({
    Key? key,
    required this.mangaLink,
    required this.mangaTitle,
    required this.mangaImg,
    required this.mangaDesc,
    required this.mangaGenres,
    required this.mangaAuthor,
    required this.index,
    required this.mangaChapterLink,
    required this.id,
    this.mangaChapter,
  }) : super(key: key);

  @override
  _ContentScreenReadState createState() => _ContentScreenReadState();
}

class _ContentScreenReadState extends State<ContentScreenRead> {
  List<Map<String, dynamic>>? contentPages;
  List<Map<String, dynamic>>? chapterChanges;
  List<Map<String, dynamic>>? chapterTitle;
  List<Map<String, dynamic>>? chapterHeader;
  bool dataFetched = false;
  String? mangaUrl;
  List<String>? cacheLink;
  int? indexChap;

  CacheManager? cacheManager;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void SaveIntoDB(String mangaChapterLink, int index) async {
    History history = new History(
      mangaTitle: widget.mangaTitle,
      mangaLink: widget.mangaLink,
      mangaImg: widget.mangaImg,
      mangaDesc: widget.mangaDesc,
      mangaGenres: widget.mangaGenres,
      mangaAuthor: widget.mangaAuthor,
      mangaChapter: widget.mangaChapter![index]['title'],
      mangaChapterLink: mangaChapterLink,
      mangaChapterIndex: index,
      id: DateTime.now().millisecondsSinceEpoch,
      sourceID: widget.id,
    );
    if (await FavoriteDatabase.instance
            .checkHistory(widget.mangaLink.toString()) ==
        true) {
      await FavoriteDatabase.instance.updateHistory(history);
    } else {
      await FavoriteDatabase.instance.createHistory(history);
    }
    print(widget.mangaLink.toString());
  }

  void _onPrevious() async {
    // monitor network fetch
    await PreviousChap();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onNext() async {
    await NextChap();
    _refreshController.loadComplete();
  }

  Future<void> PreviousChap() async {
    if (chapterChanges![0]['attributes']['class'] ==
        "rd_sd-button_item rd_top-left") {
      mangaUrl =
          "https://ln.hako.re" + chapterChanges![0]['attributes']['href'];
      indexChap = indexChap! - 1;
      SaveIntoDB(mangaUrl.toString(), indexChap!);
      getContent();
      setState(() {});
    }
  }

  Future<void> NextChap() async {
    {
      if (chapterChanges![5]['attributes']['class'] ==
          "rd_sd-button_item rd_top-right") {
        mangaUrl =
            "https://ln.hako.re" + chapterChanges![5]['attributes']['href'];
        indexChap = indexChap! + 1;
        SaveIntoDB(mangaUrl.toString(), indexChap!);
        getContent();
        setState(() {});
      }
    }
  }

  Future<void> getContent() async {
    setState(() {
      dataFetched = false;
    });
    String tempBaseUrl = mangaUrl!.split(".re")[0] + ".re";
    String tempRoute = mangaUrl!.split(".re")[1];
    final webscraper = WebScraper(tempBaseUrl);
    print(mangaUrl);

    if (await webscraper.loadWebPage(tempRoute)) {
      chapterHeader = webscraper.getElement('div.title-top', []);
      contentPages = webscraper.getElement(
          'div#chapter-content.long-text.no-select > p', ['src'],
          extraAddress: 'img');
      chapterChanges = webscraper.getElement(
        'section#rd-side_icon.none.force-block-l > a',
        ['href', 'class'],
      );
      print(chapterChanges);
      setState(() {
        dataFetched = true;
      });
    }
  }

  void ChapterChange(String mangaLink, int index) async {
    mangaUrl = mangaLink;
    indexChap = index;

    SaveIntoDB(mangaLink, index);
    await getContent();
    setState(() {});
  }

  @override
  void initState() {
    cacheLink = widget.mangaChapterLink.split(".re/");
    cacheManager = CacheManager(Config(cacheLink![1]));

    print(cacheLink![1]);

    ChapterChange(widget.mangaChapterLink, widget.index);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text(widget.mangaChapter![indexChap!]['title'].toString()),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (c) {
                          return DraggableScrollableSheet(
                              initialChildSize: 1.0,
                              maxChildSize: 1.0,
                              minChildSize: 0.5,
                              builder: (BuildContext ct,
                                  ScrollController scrollController) {
                                return Container(
                                  color: Constants.darkgray,
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
                                                    Navigator.of(ct).pop(),
                                                    ChapterChange(
                                                        "https://ln.hako.re" +
                                                            widget.mangaChapter![
                                                                        index][
                                                                    'attributes']
                                                                ['href'],
                                                        index)
                                                  },
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      widget.mangaChapter![
                                                          index]['title'],
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                );
                              });
                        });
                  },
                  icon: Icon(Icons.menu))
            ],
          )
        ],
        body: dataFetched
            ? Container(
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: _onPrevious,
                  onLoading: _onNext,
                  header: WaterDropHeader(
                    idleIcon: Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                    waterDropColor: Colors.blue,
                    refresh: Text("load thành công"),
                  ),
                  footer: ClassicFooter(
                    iconPos: IconPosition.top,
                    outerBuilder: (child) {
                      return Container(
                        width: 80.0,
                        child: Center(
                          child: child,
                        ),
                      );
                    },
                  ),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: contentPages!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Constants.lightgray,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              index == 0
                                  ? Text(
                                      chapterHeader![index]['title'] +
                                          "----------------------\n",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: 'Arial',
                                          color: Colors.white))
                                  : Container(),
                              Text(
                                contentPages![index]['title'],
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Arial',
                                    color: Colors.white),
                              ),
                              contentPages![index]['attributes']['src'] != null
                                  ? CachedNetworkImage(
                                      cacheManager: cacheManager,
                                      imageUrl: contentPages![index]
                                          ['attributes']['src'],
                                      fit: BoxFit.fitWidth,
                                      key: Key(widget.mangaLink),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        );

                        // Image.network(
                        //   contentPages![index]['attributes']['src']
                        //       .toString()
                        //       .trim(),
                        //   fit: BoxFit.fitWidth,
                        //   loadingBuilder: (context, child, loadingProgress) {
                        //     if (loadingProgress == null) return child;

                        //     return Center(child: CircularProgressIndicator());
                        //   },
                        // );
                      }),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
