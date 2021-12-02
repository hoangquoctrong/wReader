final String tableFavorites = 'Favorites';

class FavoriteFields {
  static final List<String> values = [
    id,
    mangaImg,
    mangaDesc,
    mangaGenres,
    mangaGenres,
    mangaAuthor
  ];

  static final String id = '_id';
  static final String mangaImg = 'mangaImg';
  static final String mangaLink = 'mangaLink';
  static final String mangaDesc = 'mangaDesc';
  static final String mangaGenres = 'mangaGenres';
  static final String mangaAuthor = 'mangaAuthor';
  static final String mangaTitle = 'mangaTitle';
}

class Favorite {
  final int? id;
  final String mangaLink;
  final String mangaTitle;
  final String mangaImg;
  final String mangaDesc;
  final String mangaGenres;
  final String mangaAuthor;

  const Favorite({
    required this.mangaTitle,
    required this.mangaLink,
    required this.mangaImg,
    required this.mangaDesc,
    required this.mangaGenres,
    required this.mangaAuthor,
    this.id,
  });
  Favorite copy({
    int? id,
    String? mangaLink,
    String? mangaImg,
    String? mangaDesc,
    String? mangaGenres,
    String? mangaAuthor,
  }) =>
      Favorite(
        mangaLink: mangaLink ?? this.mangaLink,
        mangaImg: mangaImg ?? this.mangaImg,
        mangaDesc: mangaDesc ?? this.mangaDesc,
        mangaGenres: mangaGenres ?? this.mangaGenres,
        mangaAuthor: mangaAuthor ?? this.mangaAuthor,
        mangaTitle: mangaTitle ?? this.mangaTitle,
        id: id ?? this.id,
      );

  static Favorite fromJson(Map<String, Object?> json) => Favorite(
        id: json[FavoriteFields.id] as int,
        mangaLink: json[FavoriteFields.mangaLink] as String,
        mangaImg: json[FavoriteFields.mangaImg] as String,
        mangaDesc: json[FavoriteFields.mangaDesc] as String,
        mangaGenres: json[FavoriteFields.mangaGenres] as String,
        mangaAuthor: json[FavoriteFields.mangaAuthor] as String,
        mangaTitle: json[FavoriteFields.mangaTitle] as String,
      );
  // json[FavoriteFields.mangaLink] as String,
  // json[FavoriteFields.mangaImg] as String,
  // json[FavoriteFields.mangaDesc] as String,
  // json[FavoriteFields.mangaGenres] as String,
  // json[FavoriteFields.mangaAuthor] as String,
  // json[FavoriteFields.id] as int);

  Map<String, Object> toJson() => {
        FavoriteFields.id: id!,
        FavoriteFields.mangaAuthor: mangaAuthor,
        FavoriteFields.mangaDesc: mangaDesc,
        FavoriteFields.mangaGenres: mangaGenres,
        FavoriteFields.mangaImg: mangaImg,
        FavoriteFields.mangaLink: mangaLink,
        FavoriteFields.mangaTitle: mangaTitle,
      };
}
