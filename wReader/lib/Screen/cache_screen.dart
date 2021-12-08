import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:wreader/components/Databases/favoriteDAO.dart';
import 'package:wreader/components/Databases/history.dart';
import 'package:wreader/constants/constants.dart';
import 'package:wreader/widgets/HorDivider.dart';

class CacheScreen extends StatefulWidget {
  const CacheScreen({Key? key}) : super(key: key);

  @override
  _CacheScreenState createState() => _CacheScreenState();
}

class _CacheScreenState extends State<CacheScreen> {
  bool isLoading = true;
  double totalsize = 0;

  List<double> sizeList = [];

  List<History> historyList = [];

  double dirStatSync(String dirPath) {
    double fileNum = 0;
    double totalSize = 0;
    var dir = Directory(dirPath);
    try {
      if (dir.existsSync()) {
        dir
            .listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            fileNum++;
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }

    return totalSize;
  }

  void reFresh() {
    totalsize = 0;
    sizeList = [];
    for (int i = 0; i < historyList.length; i++) {
      List<String> historyCacheLink;
      if (historyList[i].id == 4) {
        historyCacheLink = historyList[i].mangaLink.split(".re/");
      } else {
        historyCacheLink = historyList[i].mangaLink.split(".net/");
      }

      double size = dirStatSync(
              "/data/data/com.example.wreader/cache/" + historyCacheLink[1]) /
          1024 /
          1024;
      sizeList.add(size);
      totalsize = totalsize + size;
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> init() async {
    historyList = await FavoriteDatabase.instance.readAllHistory();
  }

  Future<void> delete(String dirPath) async {
    final dir = Directory(dirPath);
    dir.deleteSync(recursive: true);
  }

  deleteOnClick(String mangaLink, int id) {
    List<String> historyCacheLink;
    if (id == 4) {
      historyCacheLink = mangaLink.split(".re/");
    } else {
      historyCacheLink = mangaLink.split(".net/");
    }
    String dirPath =
        "/data/data/com.example.wreader/cache/" + historyCacheLink[1];

    delete(dirPath).then((value) => reFreshCache());
  }

  void reFreshCache() {
    init().then((value) => reFresh());
  }

  Future<void> emptyCache() async {
    await DefaultCacheManager().emptyCache();
    historyList = await FavoriteDatabase.instance.readAllHistory();
  }

  onClick() {
    emptyCache().then((value) => reFreshCache());
  }

  showMyAlertDialog(BuildContext context, String mangaLink, id) {
    // Create AlertDialog
    AlertDialog dialog = AlertDialog(
      title: Text("Xóa cache"),
      content: Text("Bạn muốn xóa cache của bộ này?"),
      actions: [
        ElevatedButton(
            child: Text("Yes"),
            onPressed: () {
              deleteOnClick(mangaLink, id!);
              Navigator.of(context).pop("Yes, Of course!"); // Return value
            }),
        ElevatedButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context)
                  .pop("No, I will vote for Biden"); // Return value
            }),
      ],
    );
  }

  @override
  void initState() {
    reFreshCache();
    // size =
    //     dirStatSync("/data/data/com.example.wreader/cache/libCachedImageData");
    // size = size! / 1024 / 1024;
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
        : Scaffold(
            appBar: AppBar(
              title: Text("Tổng: " + totalsize.toStringAsFixed(2) + " MB"),
              actions: [],
            ),
            body: Ink(
              color: Constants.darkgray,
              child: ListView.builder(
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        deleteOnClick(historyList[index].mangaLink,
                            historyList[index].id!);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Container(
                                  width: screenSize.width * 0.12,
                                  child: Image.network(
                                    historyList[index].mangaImg,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: screenSize.width * 0.05,
                                ),
                                Container(
                                  width: screenSize.width * 0.75,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          historyList[index].mangaTitle,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Dung lượng cache: " +
                                              sizeList[index]
                                                  .toStringAsFixed(2) +
                                              " MB",
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
                          HorDivider(),
                        ],
                      ),
                    );
                  }),
            ),
          );
  }
}
