import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wreader/Screen/detail_screen.dart';
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
              color: Constants.darkgray,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Wrap(
                      children: [
                        Center(
                          child: isLoading
                              ? CircularProgressIndicator()
                              : SizedBox(
                                  height: 10,
                                ),
                        ),
                        for (int i = 0; i < mangaList!.length; i++)
                          Container(
                              margin: EdgeInsets.only(
                                  left: (screenSize.width * 0.025)),
                              height: 200,
                              width: screenSize.width * 0.3,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new DetailScreen(
                                          mangaImg: mangaList![i].mangaImg,
                                          mangaLink: mangaList![i].mangaLink,
                                          mangaTitle: mangaList![i].mangaTitle,
                                          sourceID: mangaList![i].sourceID,
                                        ),
                                      ))
                                      .then((value) => refreshFavorite());
                                },
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 75,
                                      child: Container(
                                          child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          mangaList![i].mangaImg,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                        ),
                                      )),
                                    ),
                                    Expanded(
                                      flex: 20,
                                      child: Container(
                                        child: Text(
                                          mangaList![i].mangaTitle,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Arial',
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                        // mangaCard(
                        //   mangaImg: mangaList![i].mangaImg,
                        //   mangaTitle: mangaList![i].mangaTitle,
                        //   mangaUrl: mangaList![i].mangaLink,
                        //   sourceID: mangaList![i].sourceID,
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
