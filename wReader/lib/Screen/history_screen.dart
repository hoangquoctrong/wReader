import 'package:flutter/material.dart';
import 'package:wreader/Screen/detail_screen.dart';
import 'package:wreader/components/FavoriteScreenComponents/favorite.dart';
import 'package:wreader/components/FavoriteScreenComponents/favoriteDAO.dart';
import 'package:wreader/components/HistoryScreenComponents/history.dart';
import 'package:wreader/constants/constants.dart';
import 'package:wreader/widgets/HorDivider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<History>? mangaList;
  bool isLoading = false;

  Future refreshHistory() async {
    setState(() {
      isLoading = true;
    });
    this.mangaList = await FavoriteDatabase.instance.readAllHistory();
    print(this.mangaList.toString());
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    refreshHistory();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: mangaList!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) => new DetailScreen(
                        mangaLink: mangaList![index].mangaLink,
                        mangaImg: mangaList![index].mangaImg,
                        mangaTitle: mangaList![index].mangaTitle,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: screenSize.width * 0.12,
                              child: Image.network(
                                mangaList![index].mangaImg,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.05,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mangaList![index].mangaTitle,
                                    overflow: TextOverflow.clip,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      mangaList![index].mangaChapter,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    HorDivider(),
                  ],
                ),
              );
            });
  }
}
