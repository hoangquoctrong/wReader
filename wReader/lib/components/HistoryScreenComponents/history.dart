import 'package:wreader/components/HomeScreenComponents/detailScreen/manga_chapters.dart';

final String tableHistory = 'History';

class HistoryFields {
  static final List<String> values = [
    id,
    mangaLink,
    mangaTitle,
    mangaImg,
    mangaDesc,
    mangaGenres,
    mangaAuthor,
    mangaChapter,
    mangaChapterLink,
    mangaChapterIndex,
  ];

  static final String id = '_id';
  static final String mangaImg = 'mangaImg';
  static final String mangaLink = 'mangaLink';
  static final String mangaDesc = 'mangaDesc';
  static final String mangaGenres = 'mangaGenres';
  static final String mangaAuthor = 'mangaAuthor';
  static final String mangaTitle = 'mangaTitle';
  static final String mangaChapter = 'mangaChapter';
  static final String mangaChapterLink = 'mangaChapterLink';
  static final String mangaChapterIndex = 'mangaChapterIndex';
}

class History {
  final int? id;
  final String mangaLink;
  final String mangaTitle;
  final String mangaImg;
  final String mangaDesc;
  final String mangaGenres;
  final String mangaAuthor;
  final String mangaChapter;
  final String mangaChapterLink;
  final int mangaChapterIndex;

  const History({
    required this.mangaTitle,
    required this.mangaLink,
    required this.mangaImg,
    required this.mangaDesc,
    required this.mangaGenres,
    required this.mangaAuthor,
    required this.mangaChapter,
    required this.mangaChapterLink,
    required this.mangaChapterIndex,
    this.id,
  });
  History copy({
    int? id,
    String? mangaTitle,
    String? mangaLink,
    String? mangaImg,
    String? mangaDesc,
    String? mangaGenres,
    String? mangaAuthor,
    String? mangaChapter,
    String? mangaChapterLink,
    int? mangaChapterIndex,
  }) =>
      History(
        mangaLink: mangaLink ?? this.mangaLink,
        mangaImg: mangaImg ?? this.mangaImg,
        mangaDesc: mangaDesc ?? this.mangaDesc,
        mangaGenres: mangaGenres ?? this.mangaGenres,
        mangaAuthor: mangaAuthor ?? this.mangaAuthor,
        mangaTitle: mangaTitle ?? this.mangaTitle,
        mangaChapter: mangaChapter ?? this.mangaChapter,
        mangaChapterLink: mangaChapterLink ?? this.mangaChapterLink,
        mangaChapterIndex: mangaChapterIndex ?? this.mangaChapterIndex,
        id: id ?? this.id,
      );

  static History fromJson(Map<String, Object?> json) => History(
        id: json[HistoryFields.id] as int,
        mangaLink: json[HistoryFields.mangaLink] as String,
        mangaImg: json[HistoryFields.mangaImg] as String,
        mangaDesc: json[HistoryFields.mangaDesc] as String,
        mangaGenres: json[HistoryFields.mangaGenres] as String,
        mangaAuthor: json[HistoryFields.mangaAuthor] as String,
        mangaTitle: json[HistoryFields.mangaTitle] as String,
        mangaChapter: json[HistoryFields.mangaChapter] as String,
        mangaChapterLink: json[HistoryFields.mangaChapterLink] as String,
        mangaChapterIndex: json[HistoryFields.mangaChapterIndex] as int,
      );
  // json[FavoriteFields.mangaLink] as String,
  // json[FavoriteFields.mangaImg] as String,
  // json[FavoriteFields.mangaDesc] as String,
  // json[FavoriteFields.mangaGenres] as String,
  // json[FavoriteFields.mangaAuthor] as String,
  // json[FavoriteFields.id] as int);

  Map<String, Object> toJson() => {
        HistoryFields.id: id!,
        HistoryFields.mangaAuthor: mangaAuthor,
        HistoryFields.mangaDesc: mangaDesc,
        HistoryFields.mangaGenres: mangaGenres,
        HistoryFields.mangaImg: mangaImg,
        HistoryFields.mangaLink: mangaLink,
        HistoryFields.mangaTitle: mangaTitle,
        HistoryFields.mangaChapter: mangaChapter,
        HistoryFields.mangaChapterLink: mangaChapterLink,
        HistoryFields.mangaChapterIndex: mangaChapterIndex,
      };
}
