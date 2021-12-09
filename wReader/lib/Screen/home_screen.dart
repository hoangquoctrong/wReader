import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:wreader/Screen/cache_screen.dart';
import 'package:wreader/Screen/detail_screen.dart';
import 'package:wreader/Screen/drive_screen.dart';
import 'package:wreader/Screen/favourite_screen.dart';
import 'package:wreader/Screen/google_sign_in.dart';
import 'package:wreader/Screen/history_screen.dart';
import 'package:wreader/Screen/waiting_screen.dart';
import 'package:wreader/components/Databases/favoriteDAO.dart';
import 'package:wreader/components/Databases/id.dart';
import 'package:wreader/components/HomeScreenComponents/search_screen.dart';
import 'package:wreader/components/HomeScreenComponents/manga_cards.dart';
import 'package:wreader/components/HomeScreenComponents/manga_list.dart';
import 'package:wreader/components/dialogs/simpleDialog.dart';
import 'package:wreader/constants/constants.dart';
import 'package:wreader/widgets/bot_nav_item.dart';
import 'package:web_scraper/web_scraper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedNavIndex = 0;
  bool mangaLoaded = false;
  List<Map<String, dynamic>>? mangaList;
  List<Map<String, dynamic>>? mangaUrlList;
  List<String>? titleList = [];
  List<String>? imgList = [];
  List<String>? urlList = [];
  List<ID>? ids;

  void navBarTab(int index) {
    setState(() {
      selectedNavIndex = index;
    });
  }

  Widget _buildChild() {
    switch (selectedNavIndex) {
      case 1:
        return FavouriteScreen();
        break;
      case 2:
        return HistoryScreen();
        break;
      default:
        return MangaList(
          titleList: titleList!,
          urlList: urlList!,
          imgList: imgList!,
        );
        break;
    }
  }

  void fetchManga() async {
    final webscraper = WebScraper(Constants.baseUrl);
    print(Constants.baseUrl);
    print(Constants.id);
    switch (Constants.id) {
      case 1:
        if (await webscraper.loadWebPage("")) {
          mangaList = webscraper.getElement(
              'div.manga-content > div.row.px-2.list-item > div.col-6.col-md-3.badge-pos-1.px-2 > div.page-item-detail > div.item-thumb.hover-details.c-image-hover > a > img.img-responsive',
              [
                'src',
                'title',
                'data-src',
              ]);
          mangaUrlList = webscraper.getElement(
            'div.manga-content > div.row.px-2.list-item > div.col-6.col-md-3.badge-pos-1.px-2 > div.page-item-detail > div.item-thumb.hover-details.c-image-hover > a',
            ['href'],
          );
          for (int i = 0; i < mangaList!.length; i++) {
            titleList!.add(mangaList![i]['attributes']['title']);
            urlList!.add(mangaUrlList![i]['attributes']['href']);
            mangaList![i]['attributes']['src'] == null
                ? imgList!.add(mangaList![i]['attributes']['data-src'])
                : imgList!.add(mangaList![i]['attributes']['src']);
          }
          setState(() {
            mangaLoaded = true;
          });
        }
        break;
      case 3:
        {
          if (await webscraper.loadWebPage("")) {
            mangaList = webscraper.getElement(
              'div.ModuleContent > div.items > div.row > div.item > figure.clearfix > div.image > a > img.lazy',
              ['data-original', 'alt'],
            );
            mangaUrlList = webscraper.getElement(
              'div.ModuleContent > div.items > div.row > div.item > figure.clearfix > div.image > a',
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
              mangaLoaded = true;
            });
          }
          break;
        }
      case 4:
        {
          if (await webscraper
              .loadWebPage("danh-sach?truyendich=1&sapxep=capnhat")) {
            mangaList = webscraper.getElement(
                'main.row > div.thumb-item-flow.col-4.col-md-3.col-lg-2 > div.thumb-wrapper.ln-tooltip > a > div.a6-ratio > div.content',
                [
                  'data-bg',
                ]);
            mangaUrlList = webscraper.getElement(
              'main.row > div.thumb-item-flow.col-4.col-md-3.col-lg-2 > div.thumb_attr.series-title > a',
              ['href'],
            );
            for (int i = 0; i < mangaList!.length; i++) {
              titleList!.add(mangaUrlList![i]['title']);
              urlList!.add("https://ln.hako.re" +
                  mangaUrlList![i]['attributes']['href']);
              imgList!.add(mangaList![i]['attributes']['data-bg']);
            }
            setState(() {
              mangaLoaded = true;
            });
          }
          break;
        }
      default:
        {
          if (await webscraper.loadWebPage('comic?page=1/')) {
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
              mangaLoaded = true;
            });
          }
        }
    }
  }

  void checkSource() async {
    await checkAdd().then((value) => {
          checkEmpty()
              .then((value) => {checkID(), fetchManga(), print(Constants.id)})
        });
  }

  Future<void> checkEmpty() async {
    if (ids!.isEmpty) {
      FavoriteDatabase.instance
          .createID(ID(id: 1, source: "https://saytruyen.net/"));
    }
    ids = await FavoriteDatabase.instance.readAllID();
  }

  Future<void> checkAdd() async {
    ids = await FavoriteDatabase.instance.readAllID();
  }

  void checkID() {
    switch (ids![0].source) {
      case "https://ln.hako.re/":
        {
          Constants.baseUrl = "https://ln.hako.re/";
          Constants.id = 4;
          break;
        }
      case "https://truyentranh.net/":
        {
          Constants.baseUrl = "https://truyentranh.net/";
          Constants.id = 2;
          break;
        }
      case "http://www.nettruyenpro.com/":
        {
          Constants.baseUrl = "http://www.nettruyenpro.com/";
          Constants.id = 3;
          break;
        }
      default:
        {
          Constants.baseUrl = "https://saytruyen.net/";
          Constants.id = 1;
        }
    }
    print(ids![0].source);
  }

  Future<void> updateID(int id) async {
    switch (id) {
      case 1:
        await FavoriteDatabase.instance
            .updateID(ID(id: 1, source: "https://saytruyen.net/"));
        break;
      case 2:
        await FavoriteDatabase.instance
            .updateID(ID(id: 1, source: "https://truyentranh.net/"));
        break;
      case 3:
        await FavoriteDatabase.instance
            .updateID(ID(id: 1, source: "http://www.nettruyenpro.com/"));
        break;
      default:
        await FavoriteDatabase.instance
            .updateID(ID(id: 1, source: "https://ln.hako.re/"));
    }
  }

  @override
  void initState() {
    checkSource();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final SimpleDialog dialog = SimpleDialog(
      title: Text('Chọn nguồn'),
      children: [
        SimpleDialogItem(
          icon: Icons.link,
          color: Colors.blue,
          text: 'Saytruyen.net (Manga)',
          onPressed: () {
            setState(() {
              mangaLoaded = false;
            });
            updateID(1).then((value) => Restart.restartApp());

            Navigator.pop(context);
          },
        ),
        SimpleDialogItem(
          icon: Icons.link,
          color: Colors.blue,
          text: 'Truyentranh.net (Manga)',
          onPressed: () {
            setState(() {
              mangaLoaded = false;
            });
            updateID(2).then((value) => Restart.restartApp());

            Navigator.pop(context);
          },
        ),
        SimpleDialogItem(
          icon: Icons.link,
          color: Colors.blue,
          text: 'LN.hako.re (Novel)',
          onPressed: () {
            setState(() {
              mangaLoaded = false;
            });
            updateID(4).then((value) => Restart.restartApp());

            Navigator.pop(context);
          },
        ),
      ],
    );
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: screenSize.height * 0.2,
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  color: Constants.darkgray,
                ),
                child: Center(
                  child: Text(
                    'wReader',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Chọn nguồn',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                showDialog<void>(
                    context: context, builder: (context) => dialog);
              },
            ),
            ListTile(
              title: const Text(
                'Quản lý cache',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new CacheScreen(),
                ));
                // Update the state of the app.
                // ...
              },
            ),
            // ListTile(
            //   title: const Text(
            //     'Đồng bộ drive',
            //     style: TextStyle(fontSize: 20),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).push(new MaterialPageRoute(
            //       builder: (BuildContext context) => new WaitingScreen(),
            //     ));
            //   },
            // ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Center(
          child: Text("wReader"),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: Search());
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: mangaLoaded
          ? _buildChild()
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Constants.darkgray,
        selectedItemColor: Constants.lightblue,
        unselectedItemColor: Colors.white,
        currentIndex: selectedNavIndex,
        onTap: navBarTab,
        items: [
          botNavItem(Icons.home, 'Trang chủ'),
          botNavItem(Icons.favorite, 'Yêu thích'),
          botNavItem(Icons.watch_later, 'Lịch sử'),
        ],
      ),
    );
  }
}

class Search extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, "");
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return query == "" ? Container() : SearchContent(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  Widget buildSuggestionsSuccess(Size screenSize) {
    return Container();
  }
}
