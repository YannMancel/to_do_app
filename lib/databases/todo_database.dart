import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/data_layer/category.dart';
import 'package:to_do_app/data_layer/item.dart';

const String DATABASE_NAME = 'todo_database.db';

class TodoDatabase {

  // FIELDS --------------------------------------------------------------------

  Future<Database> _database;

  // METHODS -------------------------------------------------------------------

  Future<Database> getDatabase() async {
    _database ??= _createDatabase();
    return _database;
  }

  Future<Database> _createDatabase() async {
    return await openDatabase(
        join(await getDatabasesPath(), DATABASE_NAME),
        version: 1,
        onCreate: _onCreate,
        onOpen: _onOpen);
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE IF NOT EXISTS $CATEGORY_TABLE (
        $CATEGORY_COLUMN_ID INTEGER PRIMARY KEY,
        $CATEGORY_COLUMN_TITLE TEXT NOT NULL)
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $ITEM_TABLE (
        $ITEM_COLUMN_ID INTEGER PRIMARY KEY,
        $ITEM_COLUMN_CATEGORY_ID INTEGER,
        $ITEM_COLUMN_TITLE TEXT NOT NULL,
        $ITEM_COLUMN_DESCRIPTION TEXT,
        $ITEM_COLUMN_IS_DONE INTEGER,
        FOREIGN KEY($ITEM_COLUMN_CATEGORY_ID) REFERENCES $CATEGORY_TABLE($CATEGORY_COLUMN_ID))
    """);
  }

  void _onOpen(Database db) async {
    print('DATABASE OPEN: Version ${await db.getVersion()}');
  }

  // -- Category --

  /// Returns the id of row inserted
  Future<int> insertCategory(Category category) async {
    final database = await getDatabase();
    category.id = await database.insert(
        CATEGORY_TABLE,
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
    return category.id;
  }

  /// Returns a list of rows that were found
  Future<List<Category>> getAllCategories() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> maps =
      await database.query(CATEGORY_TABLE);

    List<Category> categories = [];
    maps.forEach((map) => categories.add(Category.fromMap(map)));

    return categories;
  }

  /// Returns the number of changes made
  Future<int> updateCategory(Category category) async {
    final database = await getDatabase();
    return await database.update(
        CATEGORY_TABLE,
        category.toMap(),
        where: '$CATEGORY_COLUMN_ID = ?',
        whereArgs: [category.id],
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  /// Returns the number of rows affected if a whereClause is passed in.
  Future<int> deleteCategory(Category category) async {
    final database = await getDatabase();
    return await database.delete(
        CATEGORY_TABLE,
        where: '$CATEGORY_COLUMN_ID = ?',
        whereArgs: [category.id]);
  }

  // -- Item --

  /// Returns the id of row inserted
  Future<int> insertItem(Item item) async {
    final database = await getDatabase();
    item.id = await database.insert(
        ITEM_TABLE,
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
    return item.id;
  }

  /// Returns a list of rows that were found
  Future<List<Item>> getItemsAccordingToCategoryId(int categoryId) async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> maps = await database.query(
        ITEM_TABLE,
        where: '$ITEM_COLUMN_CATEGORY_ID = ?',
        whereArgs: [categoryId]);

    List<Item> items = [];
    maps.forEach((map) => items.add(Item.fromMap(map)));

    return items;
  }

  /// Returns the number of changes made
  Future<int> updateItem(Item item) async {
    final database = await getDatabase();
    return await database.update(
        ITEM_TABLE,
        item.toMap(),
        where: '$ITEM_COLUMN_ID = ?',
        whereArgs: [item.id],
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  /// Returns the number of rows affected if a whereClause is passed in.
  Future<int> deleteItem(Item item) async {
    final database = await getDatabase();
    return await database.delete(
        ITEM_TABLE,
        where: '$ITEM_COLUMN_ID = ?',
        whereArgs: [item.id]);
  }
}