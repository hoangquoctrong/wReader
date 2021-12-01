import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wreader/Screen/detail_screen.dart';
import 'package:wreader/Screen/search_screen.dart';
import 'package:wreader/components/HomeScreenComponents/manga_cards.dart';
import 'package:wreader/components/HomeScreenComponents/manga_list.dart';
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

  void navBarTab(int index) {
    setState(() {
      selectedNavIndex = index;
    });
  }

  void fetchManga() async {
    final webscraper = WebScraper(Constants.baseUrl);
    print(Constants.baseUrl);
    if (await webscraper.loadWebPage('comic?page=1/')) {
      mangaList = webscraper.getElement(
        'div.content > div.box > div.card-list > div.card > a > img.card-img',
        ['src', 'alt'],
      );
      mangaUrlList = webscraper.getElement(
        'div.content > div.box > div.card-list > div.card > a',
        ['href'],
      );
    }
    setState(() {
      mangaLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchManga();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('wReader'),
        backgroundColor: Constants.blue,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: Search());
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: mangaLoaded
          ? MangaList(mangaList: mangaList, mangaUrlList: mangaUrlList)
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
          botNavItem(Icons.more_outlined, 'Thêm'),
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
    return SearchContent(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query == "" ? Container() : SearchContent(query: query);
  }

  Widget buildSuggestionsSuccess(Size screenSize) {
    return Container();
  }
}
