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
  searchResult() async {
    isLoading = true;
    String search = widget.query;
    search.replaceAll(" ", "+");
    final webscraper = WebScraper(Constants.baseUrl);
    print(Constants.baseUrl);
    switch (Constants.id) {
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
            print(mangaList);
            mangaUrlList = webscraper.getElement(
              'div.Module.Module-170 > div.ModuleContent > div.items > div.row > div.item > figure.clearfix > div.image > a > img.lazy',
              ['href'],
            );
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
                        mangaLink: mangaUrlList![index]['attributes']['href'],
                        mangaImg: Constants.id == 1
                            ? mangaList![index]['attributes']['src']
                            : "https:" + mangaList![index]['attributes']['src'],
                        mangaTitle: Constants.id == 1
                            ? mangaList![index]['attributes']['alt']
                            : mangaList![index]['attributes']['alt']
                                .toString()
                                .substring(
                                    13,
                                    mangaList![index]['attributes']['alt']
                                        .toString()
                                        .length),
                        sourceID: Constants.id,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: screenSize.width * 0.12,
                          child: Image.network(
                            Constants.id == 1
                                ? mangaList![index]['attributes']['src']
                                : "https:" +
                                    mangaList![index]['attributes']['src'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.05,
                        ),
                        Container(
                          width: screenSize.width * 0.75,
                          child: Text(
                            Constants.id == 1
                                ? mangaList![index]['attributes']['alt']
                                : mangaList![index]['attributes']['alt']
                                    .toString()
                                    .substring(
                                        13,
                                        mangaList![index]['attributes']['alt']
                                            .toString()
                                            .length),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
  }
}
