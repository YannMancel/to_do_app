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
    print('DATABASE CREATION');
    await db.execute("""
      CREATE TABLE $ITEM_TABLE_NAME (
        $COLUMN_ID INTEGER PRIMARY KEY,
        $COLUMN_TITLE TEXT NOT NULL,
        $COLUMN_DESCRIPTION TEXT,
        $COLUMN_IS_DONE INTEGER)
    """);
  }

  void _onOpen(Database db) async {
    print('DATABASE OPEN: Version ${await db.getVersion()}');
  }

  // -- Create Item --

  Future<Item> insertItem(Item item) async {
    final database = await getDatabase();
    item.id = await database.insert(ITEM_TABLE_NAME, item.toMap());
    return item;
  }

  // -- Read Item --

  Future<List<Item>> getAllItems() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> maps =
      await database.query(ITEM_TABLE_NAME);
      // await database.rawQuery('SELECT * FROM $ITEM_TABLE_NAME')

    List<Item> items = [];
    maps.forEach((map) => items.add(Item.fromMap(map)));

    return items;
  }
}