import 'package:flutter/material.dart';
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
    if (await webscraper.loadWebPage('')) {
      mangaList = webscraper.getElement(
        'div.ModuleContent > div.items > div.row > div.item > figure > div.image > a > img.lazy',
        ['data-original', 'alt'],
      );
      mangaUrlList = webscraper.getElement(
        'div.ModuleContent > div.items > div.row > div.item > figure > div.image > a',
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
