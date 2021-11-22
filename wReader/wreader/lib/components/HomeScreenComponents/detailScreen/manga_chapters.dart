import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wreader/constants/constants.dart';
import 'package:wreader/widgets/HorDivider.dart';

class MangaChapters extends StatelessWidget {
  final List<Map<String, dynamic>>? mangaChapter;
  const MangaChapters({Key? key, this.mangaChapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: mangaChapter!.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                HorDivider(),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: Material(
                    color: Constants.darkgray,
                    child: InkWell(
                      onTap: () => print(mangaChapter![index]['href']),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          mangaChapter![index]['title'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
