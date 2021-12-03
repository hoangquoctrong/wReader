import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wreader/components/FavoriteScreenComponents/favorite.dart';
import 'package:wreader/components/HistoryScreenComponents/history.dart';

class FavoriteDatabase {
  static final FavoriteDatabase instance = FavoriteDatabase._init();

  static Database? _database;

  FavoriteDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('mangas.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final StringType = 'TEXT';
    final intType = 'INTEGER NOT NULL';

    await db.execute('''
        CREATE TABLE $tableFavorites(
        ${FavoriteFields.id} $idType,
        ${FavoriteFields.mangaAuthor} $StringType,
        ${FavoriteFields.mangaDesc} $StringType,
        ${FavoriteFields.mangaGenres} $StringType,
        ${FavoriteFields.mangaImg} $StringType,
        ${FavoriteFields.mangaLink} $StringType,
        ${FavoriteFields.mangaTitle} $StringType)
        ''');
    await db.execute('''
        CREATE TABLE $tableHistory(
        ${HistoryFields.id} $idType,
        ${HistoryFields.mangaAuthor} $StringType,
        ${HistoryFields.mangaDesc} $StringType,
        ${HistoryFields.mangaGenres} $StringType,
        ${HistoryFields.mangaImg} $StringType,
        ${HistoryFields.mangaLink} $StringType,
        ${HistoryFields.mangaTitle} $StringType,
        ${HistoryFields.mangaChapter} $StringType,
        ${HistoryFields.mangaChapterLink} $StringType,
        ${HistoryFields.mangaChapterIndex} $intType)
        ''');
  }

  Future<Favorite> create(Favorite favorite) async {
    final db = await instance.database;
    final id = await db!.insert(tableFavorites, favorite.toJson());
    return favorite.copy(id: id);
  }

  Future<History> createHistory(History history) async {
    final db = await instance.database;
    final id = await db!.insert(tableHistory, history.toJson());
    return history.copy(id: id);
  }

  Future<Favorite> readFavorite(int id) async {
    final db = await instance.database;

    final maps = await db!.query(
      tableFavorites,
      columns: FavoriteFields.values,
      where: '${FavoriteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Favorite.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<History>> readHistory(String mangaLink) async {
    final db = await instance.database;

    final maps = await db!.query(
      tableHistory,
      columns: HistoryFields.values,
      where: '${HistoryFields.mangaLink} = ?',
      whereArgs: [mangaLink],
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => History.fromJson(json)).toList();
    } else {
      throw Exception('mangaLink $mangaLink not found');
    }
  }

  //  Future<List<History>> readAllHistory() async {
  //   final db = await instance.database;

  //   final result = await db!.query(tableHistory);

  //   return result.map((json) => History.fromJson(json)).toList();
  // }

  Future<bool> checkFavorite(String mangaLink) async {
    final db = await instance.database;

    final maps = await db!.query(
      tableFavorites,
      columns: FavoriteFields.values,
      where: '${FavoriteFields.mangaLink} = ?',
      whereArgs: [mangaLink],
    );

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkHistory(String mangaLink) async {
    final db = await instance.database;

    final maps = await db!.query(
      tableHistory,
      columns: HistoryFields.values,
      where: '${HistoryFields.mangaLink} = ?',
      whereArgs: [mangaLink],
    );

    if (maps.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<List<Favorite>> readAllFavorite() async {
    final db = await instance.database;

    final result = await db!.query(tableFavorites);

    return result.map((json) => Favorite.fromJson(json)).toList();
  }

  Future<List<History>> readAllHistory() async {
    final db = await instance.database;

    final result =
        await db!.query(tableHistory, orderBy: '${HistoryFields.id} desc');

    return result.map((json) => History.fromJson(json)).toList();
  }

  Future<int> update(Favorite favorite) async {
    final db = await instance.database;

    return db!.update(
      tableFavorites,
      favorite.toJson(),
      where: '${FavoriteFields.id} = ?',
      whereArgs: [favorite.id],
    );
  }

  Future<int> updateHistory(History history) async {
    final db = await instance.database;

    return db!.update(
      tableHistory,
      history.toJson(),
      where: '${HistoryFields.mangaLink} = ?',
      whereArgs: [history.mangaLink],
    );
  }

  Future<int> delete(String mangaLink) async {
    final db = await instance.database;

    return await db!.delete(
      tableFavorites,
      where: '${FavoriteFields.mangaLink} = ?',
      whereArgs: [mangaLink],
    );
  }

  Future close() async {
    final db = await instance.database;
    db!.close();
  }
}
