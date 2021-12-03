import 'package:flutter/material.dart';
import 'package:swipe_back_detector/swipe_back_detector.dart';
import 'package:wreader/Screen/detail_screen.dart';
import 'package:wreader/components/FavoriteScreenComponents/favorite.dart';
import 'package:wreader/components/FavoriteScreenComponents/favoriteDAO.dart';
import 'package:wreader/constants/constants.dart';

class mangaCard extends StatefulWidget {
  final String? mangaImg, mangaTitle, mangaUrl;
  const mangaCard({Key? key, this.mangaImg, this.mangaTitle, this.mangaUrl})
      : super(key: key);

  @override
  _mangaCardState createState() => _mangaCardState();
}

class _mangaCardState extends State<mangaCard> {
  bool isLoading = false;
  bool isFavorite = false;
  void navigatorPush(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = Offset(1.0, 0.0);
          final end = Offset.zero;
          final curve = Curves.ease;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SwipeBackDetector(
            child: SlideTransition(
              position: animation.drive(tween),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(left: (screenSize.width * 0.025)),
        height: 200,
        width: screenSize.width * 0.3,
        child: GestureDetector(
          onTap: () {
            navigatorPush(
              context,
              DetailScreen(
                mangaImg: widget.mangaImg,
                mangaLink: widget.mangaUrl,
                mangaTitle: widget.mangaTitle,
              ),
            );
          },
          child: Column(
            children: [
              Expanded(
                flex: 75,
                child: Container(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.mangaImg.toString(),
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                )),
              ),
              Expanded(
                flex: 20,
                child: Container(
                  child: Text(
                    widget.mangaTitle!,
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
        ));
  }
}
// class mangaCard extends StatelessWidget {
//   final String? mangaImg, mangaTitle, mangaUrl;
//   const mangaCard({Key? key, this.mangaImg, this.mangaTitle, this.mangaUrl})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     return Container(
//         margin: EdgeInsets.only(left: (screenSize.width * 0.025)),
//         height: 200,
//         width: screenSize.width * 0.3,
//         child: GestureDetector(
//           onTap: () {
            
//             navigatorPush(
//               context,
//               DetailScreen(
//                 mangaImg: mangaImg,
//                 mangaLink: mangaUrl,
//                 mangaTitle: mangaTitle,
//                 isFavorite: false,
//               ),
//             );
//           },
//           child: Column(
//             children: [
//               Expanded(
//                 flex: 75,
//                 child: Container(
//                     child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10.0),
//                   child: Image.network(
//                     mangaImg.toString(),
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     },
//                   ),
//                 )),
//               ),
//               Expanded(
//                 flex: 15,
//                 child: Container(
//                   child: Text(
//                     mangaTitle!,
//                     textAlign: TextAlign.center,
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                     style: TextStyle(
//                         color: Colors.white, fontFamily: 'Arial', fontSize: 12),
//                   ),
//                 ),
//               ),
//               // Expanded(
//               //   flex: 10,
//               //   child: Container(
//               //     alignment: ,
//               //   ),
//               // )
//             ],
//           ),
//         ));
//   }

//   void navigatorPush(BuildContext context, Widget page) {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) => page,
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           final begin = Offset(1.0, 0.0);
//           final end = Offset.zero;
//           final curve = Curves.ease;
//           final tween =
//               Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//           return SwipeBackDetector(
//             child: SlideTransition(
//               position: animation.drive(tween),
//               child: child,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
