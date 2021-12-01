import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:wreader/constants/constants.dart';

class ContentScreen extends StatefulWidget {
  final String mangaLink;
  final int index;
  final List<Map<String, dynamic>>? mangaChapter;
  const ContentScreen(
      {Key? key,
      required this.mangaLink,
      this.mangaChapter,
      required this.index})
      : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  List<Map<String, dynamic>>? contentPages;
  List<Map<String, dynamic>>? chapterChanges;
  List<Map<String, dynamic>>? chapterTitle;
  ScrollController? _controller = ScrollController();
  bool dataFetched = false;
  String? mangaUrl;
  int? indexChap;

  void getContent() async {
    dataFetched = false;
    String tempBaseUrl = mangaUrl!.split(".net")[0] + ".net";
    String tempRoute = mangaUrl!.split(".net")[1];
    final webscraper = WebScraper(tempBaseUrl);

    if (await webscraper.loadWebPage(tempRoute)) {
      contentPages = webscraper.getElement(
        'div.manga-reading-box > div.page-chapter > img',
        ['src'],
      );
      chapterChanges = webscraper.getElement(
        'div.header-chapter-selection > a',
        ['href', 'class'],
      );
      chapterTitle = webscraper.getElement(
        'div.section.section-nav-chapter > div.container > div.header-section-nav > ul > li',
        ['title'],
      );
      dataFetched = true;
      print(chapterTitle);
      setState(() {});
    }
  }

  ChapterChanged() {}

  _scrollListener() {
    if (_controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange) {
      if (chapterChanges![0]['attributes']['class'] == "next-chapter" &&
          chapterChanges!.length == 1) {
        Fluttertoast.showToast(
          msg: "Đây là chap cuối cùng",
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        mangaUrl = chapterChanges![0]['attributes']['href'];
        indexChap = indexChap! - 1;
        getContent();
      }
      setState(() {});
    }
    if (_controller!.offset <= _controller!.position.minScrollExtent &&
        !_controller!.position.outOfRange) {
      if (chapterChanges![0]['attributes']['class'] == "previous-chapter" &&
          chapterChanges!.length == 1) {
        Fluttertoast.showToast(
          msg: "Đây là chap đầu tiên",
          toastLength: Toast.LENGTH_SHORT,
        );
        // toastLength: Toast.LENGTH_SHORT,
        // gravity: ToastGravity.BOTTOM,
        // backgroundColor: Colors.black54,
        // textColor: Colors.white);
      } else if (chapterChanges![0]['attributes']['class'] == "next-chapter") {
        mangaUrl = chapterChanges![0]['attributes']['href'];
        indexChap = indexChap! + 1;
        getContent();
      } else {
        mangaUrl = chapterChanges![1]['attributes']['href'];
        indexChap = indexChap! + 1;
        getContent();
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller!.addListener(_scrollListener);
    mangaUrl = widget.mangaLink;
    indexChap = widget.index;
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
            title: Text(widget.mangaChapter![indexChap!]['title'].toString()),
            centerTitle: true,
            backgroundColor: Constants.black,
          )
        ],
        body: dataFetched
            ? Container(
                child: ListView.builder(
                    controller: _controller!,
                    shrinkWrap: true,
                    itemCount: contentPages!.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: contentPages![index]['attributes']['src']
                              .toString()
                              .trim(),
                          fit: BoxFit.fitWidth,
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
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
