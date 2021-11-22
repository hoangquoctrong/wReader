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
  void getMangaInfos() async {
    String tempBaseUrl = widget.mangaLink!.split(".com")[0] + ".com";
    String tempRoute = widget.mangaLink!.split(".com")[1];

    final webscraper = WebScraper(tempBaseUrl);
    if (await webscraper.loadWebPage(tempRoute)) {
      mangaDetail = webscraper.getElement(
        "div.detail-info > div.row > div.col-xs-8.col-info > ul.list-info > li >p.col-xs-8",
        [],
      );
      mangaDescList = webscraper.getElement(
        "div.detail-content > p",
        [],
      );
      mangaChapterList = webscraper.getElement(
        "div#nt_listchapter.list-chapter > nav > ul > li.row > div.col-xs-5.chapter > a",
        ['href'],
      );
    }

    setState(() {
      mangaLoaded = true;
    });
    mangaGenres = mangaDetail![2]['title'].toString().trim();
    mangaStatus = mangaDetail![1]['title'].toString().trim();
    mangaAuthor = mangaDetail![0]['title'].toString().trim();
    mangaDesc = mangaDescList![0]['title'].toString().trim();
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
          backgroundColor: Constants.darkgray,
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
                    ),
                    MangaDesc(
                      mangaDesc: mangaDesc,
                      mangaGenres: mangaGenres,
                    ),
                    Divider(),
                    Text(
                      "Chapters",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Divider(),
                    MangaChapters(mangaChapter: mangaChapterList)
                  ],
                )),
              )
            : const Center(child: CircularProgressIndicator()));
  }
}
