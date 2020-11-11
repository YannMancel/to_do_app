import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart' as directory;
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/data_layer/item.dart';

class TodoDatabase {

  // FIELDS --------------------------------------------------------------------

  final _databaseName = 'todo_database.db';
  Future<Database> _database;

  // METHODS -------------------------------------------------------------------

  Future<Database> getDatabase() async {
    _database ??= _createDatabase();
    return _database;
  }

  Future<Database> _createDatabase() async {
    // Location of database path
    final appDirectory = await directory.getApplicationDocumentsDirectory();
    final String dbPath = join(appDirectory.path, _databaseName);

    final database = await openDatabase(
        dbPath, version: 1, onCreate: _onCreate, onOpen: _onOpen);

    return database;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE $ITEM_TABLE_NAME (
        $COLUMN_ID INTEGER PRIMARY KEY,
        $COLUMN_TITLE TEXT NOT NULL,
        $COLUMN_DESCRIPTION TEXT,
        $COLUMN_IS_DONE INTEGER)
    """);
  }

  void _onOpen(Database db) async {
    print('DATABASE $ITEM_TABLE_NAME: OPEN Version ${await db.getVersion()}');
  }

  // -- Create Item --

  /// Returns the id of row inserted
  Future<int> insertItem(Item item) async {
    final database = await getDatabase();
    item.id = await database.insert(ITEM_TABLE_NAME, item.toMap());
    return item.id;
  }

  // -- Read Item --

  /// Returns a list of rows that were found
  Future<List<Item>> getAllItems() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> maps =
      await database.query(ITEM_TABLE_NAME);

    List<Item> items = [];
    maps.forEach((map) => items.add(Item.fromMap(map)));

    return items;
  }

  // -- Update Item --

  /// Returns the number of changes made
  Future<int> updateItem(Item item) async {
    final database = await getDatabase();
    return await database.update(ITEM_TABLE_NAME, item.toMap(),
        where: '$COLUMN_ID = ?', whereArgs: [item.id]);
  }

  // -- Delete Item --

  /// Returns the number of rows affected if a whereClause is passed in.
  Future<int> deleteItem(Item item) async {
    final database = await getDatabase();
    return await database.delete(ITEM_TABLE_NAME,
        where: '$COLUMN_ID = ?', whereArgs: [item.id]);
  }
}