import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:wreader/Screen/detail_screen.dart';
import 'package:wreader/constants/constants.dart';

class SearchContent extends StatefulWidget {
  final String query;
  const SearchContent({Key? key, required this.query}) : super(key: key);

  @override
  _SearchContentState createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  bool isLoading = true;
  List<Map<String, dynamic>>? mangaList;
  List<Map<String, dynamic>>? mangaUrlList;
  List<String>? titleList = [];
  List<String>? imgList = [];
  List<String>? urlList = [];
  searchResult() async {
    titleList = [];
    imgList = [];
    urlList = [];
    isLoading = true;
    String search = widget.query;
    search.replaceAll(" ", "+");
    final webscraper = WebScraper(Constants.baseUrl);
    print(Constants.baseUrl);
    switch (Constants.id) {
      case 4:
        {
          if (await webscraper.loadWebPage('tim-kiem?keywords=' + search)) {
            mangaList = webscraper.getElement(
              'div.row > div.thumb-item-flow.col-4.col-md-3.col-lg-2 > div.thumb-wrapper > a > div.a6-ratio > div.content',
              ['data-bg'],
            );
            mangaUrlList = webscraper.getElement(
              'div.row > div.thumb-item-flow.col-4.col-md-3.col-lg-2 > div.thumb_attr.series-title > a',
              ['href'],
            );
            for (int i = 0; i < mangaList!.length; i++) {
              titleList!.add(mangaUrlList![i]['title']);
              urlList!.add("https://ln.hako.re" +
                  mangaUrlList![i]['attributes']['href']);
              imgList!.add(mangaList![i]['attributes']['data-bg']);
            }
            setState(() {
              isLoading = false;
            });
          }
          break;
        }
      case 1:
        if (await webscraper.loadWebPage('search?s=' + search)) {
          mangaList = webscraper.getElement(
            'div.item-thumb.hover-details.c-image-hover > a > img.img-responsive',
            ['src', 'alt'],
          );
          mangaUrlList = webscraper.getElement(
            'div.item-thumb.hover-details.c-image-hover > a',
            ['href'],
          );
          for (int i = 0; i < mangaList!.length; i++) {
            titleList!.add(mangaList![i]['attributes']['alt']);
            urlList!.add(mangaUrlList![i]['attributes']['href']);
            imgList!.add(mangaList![i]['attributes']['src']);
          }
          setState(() {
            isLoading = false;
          });
        }
        break;
      case 2:
        {
          if (await webscraper.loadWebPage('search?q=' + search)) {
            mangaList = webscraper.getElement(
              'div.content > div.box > div.card-list > div.card > a > img.card-img',
              ['src', 'alt'],
            );
            mangaUrlList = webscraper.getElement(
              'div.content > div.box > div.card-list > div.card > a',
              ['href'],
            );
            for (int i = 0; i < mangaList!.length; i++) {
              titleList!.add(mangaList![i]['attributes']['alt']);
              urlList!.add(mangaUrlList![i]['attributes']['href']);
              imgList!.add(mangaList![i]['attributes']['src']);
            }
            setState(() {
              isLoading = false;
            });
          }
          break;
        }
      default:
        {
          if (await webscraper.loadWebPage('tim-truyen?keyword=' + search)) {
            mangaList = webscraper.getElement(
              'div.Module.Module-170 > div.ModuleContent > div.items > div.row > div.item > figure.clearfix > div.image > a > img.lazy',
              ['src', 'alt'],
            );
            mangaUrlList = webscraper.getElement(
              'div.Module.Module-170 > div.ModuleContent > div.items > div.row > div.item > figure.clearfix > div.image > a > img.lazy',
              ['href'],
            );
            for (int i = 0; i < mangaList!.length; i++) {
              titleList!.add(mangaList![i]['attributes']['alt']
                  .toString()
                  .substring(13,
                      mangaList![i]['attributes']['alt'].toString().length));
              urlList!.add(mangaUrlList![i]['attributes']['href']);

              imgList!
                  .add("https:" + mangaList![i]['attributes']['data-original']);
            }
            setState(() {
              isLoading = false;
            });
          }
        }
    }
  }

  @override
  void initState() {
    searchResult();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: mangaList!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) => new DetailScreen(
                        mangaLink: urlList![index],
                        mangaImg: imgList![index],
                        mangaTitle: titleList![index],
                        sourceID: Constants.id,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        width: screenSize.width * 0.12,
                        child: Image.network(
                          imgList![index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width * 0.05,
                      ),
                      Container(
                        width: screenSize.width * 0.75,
                        child: Text(
                          titleList![index],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
  }
}
