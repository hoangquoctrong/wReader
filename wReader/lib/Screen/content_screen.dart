import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:wreader/components/Databases/favoriteDAO.dart';
import 'package:wreader/components/Databases/history.dart';
import 'package:wreader/constants/constants.dart';
import 'package:wreader/widgets/HorDivider.dart';

class ContentScreen extends StatefulWidget {
  final String mangaLink;
  final String mangaTitle;
  final String mangaImg;
  final String mangaDesc;
  final String mangaGenres;
  final String mangaAuthor;
  final int index;
  final String mangaChapterLink;
  final int id;
  final List<Map<String, dynamic>>? mangaChapter;
  const ContentScreen({
    Key? key,
    required this.mangaLink,
    this.mangaChapter,
    required this.index,
    required this.mangaTitle,
    required this.mangaImg,
    required this.mangaDesc,
    required this.mangaGenres,
    required this.mangaAuthor,
    required this.mangaChapterLink,
    required this.id,
  }) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  List<Map<String, dynamic>>? contentPages;
  List<Map<String, dynamic>>? chapterChanges;
  List<Map<String, dynamic>>? chapterTitle;
  bool dataFetched = false;
  String? mangaUrl;
  int? indexChap;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
        sourceID: widget.id);
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

  void ChapterChange(String mangaLink, int index) async {
    mangaUrl = mangaLink;
    indexChap = index;
    SaveIntoDB(mangaLink, index);
    await getContent();
    setState(() {});
  }

  Future<void> PreviousChap() async {
    if (chapterChanges![0]['attributes']['class'] == "previous-chapter" &&
        chapterChanges!.length == 1) {
      Fluttertoast.showToast(
        msg: "Đây là chap đầu tiên",
        toastLength: Toast.LENGTH_SHORT,
      );
    } else if (chapterChanges![0]['attributes']['class'] == "next-chapter") {
      mangaUrl = chapterChanges![0]['attributes']['href'];
      indexChap = indexChap! + 1;
      SaveIntoDB(mangaUrl.toString(), indexChap!);
      getContent();
    } else {
      mangaUrl = chapterChanges![1]['attributes']['href'];
      indexChap = indexChap! + 1;
      SaveIntoDB(mangaUrl.toString(), indexChap!);
      getContent();
    }
    setState(() {});
  }

  Future<void> NextChap() async {
    if (chapterChanges![0]['attributes']['class'] == "next-chapter" &&
        chapterChanges!.length == 1) {
      Fluttertoast.showToast(
        msg: "Đây là chap cuối cùng",
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      mangaUrl = chapterChanges![0]['attributes']['href'];
      indexChap = indexChap! - 1;
      SaveIntoDB(mangaUrl.toString(), indexChap!);
      getContent();
    }
    setState(() {});
  }

  Future<void> getContent() async {
    setState(() {
      dataFetched = false;
    });

    switch (widget.id) {
      case 2:
        {
          String tempBaseUrl = mangaUrl!.split(".com")[0] + ".com";
          String tempRoute = mangaUrl!.split(".com")[1];
          final webscraper = WebScraper(tempBaseUrl);

          if (await webscraper.loadWebPage(tempRoute)) {
            contentPages = webscraper.getElement(
              'div.page-chapter > img',
              ['data-original'],
            );
            chapterChanges = webscraper.getElement(
              'div.chapter-nav-bottom.text-center.mrt5.mrb5 > a',
              ['href', 'class'],
            );
            print(chapterChanges);

            setState(() {
              dataFetched = true;
            });
          }
          break;
        }
      default:
        {
          String tempBaseUrl = mangaUrl!.split(".net")[0] + ".net";
          String tempRoute = mangaUrl!.split(".net")[1];
          final webscraper = WebScraper(tempBaseUrl);

          if (await webscraper.loadWebPage(tempRoute)) {
            contentPages = webscraper.getElement(
              'div.manga-reading-box > div.page-chapter > img',
              ['src'],
            );
            chapterChanges = webscraper.getElement(
              'div.reading-control > div.chapter-nav > a',
              ['href', 'class'],
            );
            chapterTitle = webscraper.getElement(
              'div.section.section-nav-chapter > div.container > div.header-section-nav > ul > li',
              ['title'],
            );
            print(chapterChanges);
            setState(() {
              dataFetched = true;
            });
          }
        }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mangaUrl = widget.mangaChapterLink;
    print("Manga URL : " + mangaUrl!);
    indexChap = widget.index;
    print(widget.id);
    getContent();
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
                                                        widget.mangaChapter![
                                                                    index]
                                                                ['attributes']
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
                  enablePullUp: true,
                  enablePullDown: true,
                  onLoading: _onNext,
                  onRefresh: _onPrevious,
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
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: widget.id == 2
                                  ? "https:" +
                                      contentPages![index]['attributes']
                                              ['data-original']
                                          .toString()
                                          .trim()
                                  : contentPages![index]['attributes']['src']
                                      .toString()
                                      .trim(),
                              fit: BoxFit.fitWidth,
                            ),
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
