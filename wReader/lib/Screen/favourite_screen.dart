import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wreader/components/Databases/favorite.dart';
import 'package:wreader/components/Databases/favoriteDAO.dart';
import 'package:wreader/components/HomeScreenComponents/manga_cards.dart';
import 'package:wreader/constants/constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Favorite>? mangaList;
  bool isLoading = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await refreshFavorite();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future refreshFavorite() async {
    setState(() {
      isLoading = true;
    });
    this.mangaList = await FavoriteDatabase.instance.readAllFavorite();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    refreshFavorite();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SmartRefresher(
      enablePullDown: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: screenSize.height,
              width: double.infinity,
              color: Constants.black,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Wrap(
                      children: [
                        Center(
                          child: isLoading
                              ? CircularProgressIndicator()
                              : SizedBox(),
                        ),
                        Container(
                          width: double.infinity,
                          height: 30,
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Yêu thích",
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        for (int i = 0; i < mangaList!.length; i++)
                          mangaCard(
                            mangaImg: mangaList![i].mangaImg,
                            mangaTitle: mangaList![i].mangaTitle,
                            mangaUrl: mangaList![i].mangaLink,
                            sourceID: mangaList![i].sourceID,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
