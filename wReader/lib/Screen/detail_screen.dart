import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:wreader/components/Databases/favoriteDAO.dart';
import 'package:wreader/components/HomeScreenComponents/detailScreen/manga_chapters.dart';
import 'package:wreader/components/HomeScreenComponents/detailScreen/manga_desc.dart';
import 'package:wreader/components/HomeScreenComponents/detailScreen/manga_info.dart';
import 'package:wreader/components/dialogs/linkDialog.dart';
import 'package:wreader/constants/constants.dart';
import 'package:wreader/widgets/HorDivider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final String? mangaImg, mangaTitle, mangaLink;
  final int sourceID;

  const DetailScreen({
    Key? key,
    this.mangaImg,
    this.mangaTitle,
    this.mangaLink,
    required this.sourceID,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? mangaGenres, mangaStatus, mangaAuthor, mangaDesc;
  bool mangaLoaded = false;
  bool isFavorite = false;
  List<Map<String, dynamic>>? mangaDetail;
  List<Map<String, dynamic>>? mangaDescList;
  List<Map<String, dynamic>>? mangaChapterList;
  List<Map<String, dynamic>>? mangaArtist;
  void getMangaInfos() async {
    switch (widget.sourceID) {
      case 2:
        {
          String tempBaseUrl = widget.mangaLink!.split(".com")[0] + ".com";
          String tempRoute = widget.mangaLink!.split(".com")[1];

          final webscraper = WebScraper(tempBaseUrl);
          if (await webscraper.loadWebPage(tempRoute)) {
            mangaDetail = webscraper.getElement(
              "div.detail-info > div.row > div.col-xs-8.col-info > ul.list-info > li >p.col-xs-8",
              // "div.detai-info > div.row > div.col-xs-8.col-info > ul.list-info > li.author.row > p",
              [],
            );
            mangaDescList = webscraper.getElement(
              "div.detail-content > p",
              [],
            );
            mangaChapterList = webscraper.getElement(
              "div.list-chapter > nav > ul > li.row > div.col-xs-5.chapter > a",
              ['href'],
            );
            mangaDesc = mangaDescList![0]['title'].toString().trim();
            mangaAuthor = mangaDetail![0]['title'].toString().trim();
            mangaGenres = mangaDetail![2]['title'].toString().trim();
            print("mangaDetail:" + mangaDetail.toString());
            setState(() {
              mangaLoaded = true;
            });
          }

          break;
        }
      default:
        String tempBaseUrl = widget.mangaLink!.split(".net")[0] + ".net";
        String tempRoute = widget.mangaLink!.split(".net")[1];

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
          mangaChapterList = webscraper.getElement(
            "div.chapter-list-item-box > div.chapter-select > a",
            ['href'],
          );
          print(mangaDetail);
          setState(() {
            mangaLoaded = true;
          });
        }

        mangaGenres = "";
        for (int i = 0; i < mangaDetail!.length; i++) {
          if (i == mangaDetail!.length - 1) {
            mangaGenres =
                mangaGenres! + mangaDetail![i]['title'].toString().trim();
          } else {
            mangaGenres = mangaGenres! +
                mangaDetail![i]['title'].toString().trim() +
                " - ";
          }
        }
        mangaDesc = mangaDescList![0]['title'].toString().trim();
        mangaAuthor = mangaArtist![0]['title'].toString().trim();
    }
  }

  checkFavorite() async {
    setState(() {
      mangaLoaded = false;
    });

    if (await FavoriteDatabase.instance
            .checkFavorite(widget.mangaLink.toString()) ==
        true) {
      isFavorite = true;
      setState(() {});
    } else {
      isFavorite = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMangaInfos();
    checkFavorite();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Constants.darkgray,
        appBar: AppBar(
            title: Text(
              "Chi tiết",
              maxLines: 1,
              style: TextStyle(fontFamily: ('Calibri')),
            ),
            centerTitle: true,
            elevation: 0.0,
            actions: [
              LinkDialog(
                mangaLink: widget.mangaLink!,
              )
            ]),
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
                      isFavorite: isFavorite,
                      mangaChapter: mangaChapterList,
                      sourceID: widget.sourceID,
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
