import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:wreader/components/HomeScreenComponents/detailScreen/manga_chapters.dart';
import 'package:wreader/components/HomeScreenComponents/detailScreen/manga_desc.dart';
import 'package:wreader/components/HomeScreenComponents/detailScreen/manga_info.dart';
import 'package:wreader/constants/constants.dart';
import 'package:wreader/widgets/HorDivider.dart';

class DetailScreen extends StatefulWidget {
  final String? mangaImg, mangaTitle, mangaLink;

  const DetailScreen({Key? key, this.mangaImg, this.mangaTitle, this.mangaLink})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? mangaGenres, mangaStatus, mangaAuthor, mangaDesc;
  bool mangaLoaded = false;
  List<Map<String, dynamic>>? mangaDetail;
  List<Map<String, dynamic>>? mangaDescList;
  List<Map<String, dynamic>>? mangaChapterList;
  List<Map<String, dynamic>>? mangaArtist;
  void getMangaInfos() async {
    String tempBaseUrl = widget.mangaLink!.split(".net")[0] + ".net";
    String tempRoute = widget.mangaLink!.split(".net")[1];
    print(tempBaseUrl);
    print(tempRoute);

    final webscraper = WebScraper(tempBaseUrl);
    if (await webscraper.loadWebPage(tempRoute)) {
      mangaDetail = webscraper.getElement(
        // "div.detail-info > div.row > div.col-xs-8.col-info > ul.list-info > li >p.col-xs-8",
        "div.detail-banner-info > ul > li > a",
        [],
      );
      mangaDescList = webscraper.getElement(
        "div.detail-manga-intro",
        [],
      );
      mangaArtist = webscraper.getElement(
        'div.detail-banner-info > ul > li > a > span',
        [],
      );
      print(mangaArtist);
    }

    setState(() {
      mangaLoaded = true;
    });
    mangaGenres = "";
    for (int i = 0; i < mangaDetail!.length; i++) {
      if (i == mangaDetail!.length - 1) {
        mangaGenres = mangaGenres! + mangaDetail![i]['title'].toString().trim();
      } else {
        mangaGenres =
            mangaGenres! + mangaDetail![i]['title'].toString().trim() + " - ";
      }
    }
    mangaDesc = mangaDescList![0]['title'].toString().trim();
    mangaAuthor = mangaArtist![0]['title'].toString().trim();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMangaInfos();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Constants.darkgray,
        appBar: AppBar(
          title: Text(
            widget.mangaTitle!,
            maxLines: 1,
            style: TextStyle(fontFamily: ('Calibri')),
          ),
          centerTitle: true,
          backgroundColor: Constants.blue,
          elevation: 0.0,
        ),
        body: mangaLoaded
            ? Container(
                width: screenSize.width,
                height: screenSize.height,
                color: Constants.darkgray,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MangaInfo(
                      mangaImg: widget.mangaImg,
                      mangaStatus: mangaStatus.toString(),
                      mangaAuthor: mangaAuthor.toString(),
                      mangaTitle: widget.mangaTitle,
                      mangaLink: widget.mangaLink,
                    ),
                    MangaDesc(
                      mangaDesc: mangaDesc,
                      mangaGenres: mangaGenres,
                    ),
                  ],
                )),
              )
            : const Center(child: CircularProgressIndicator()));
  }
}