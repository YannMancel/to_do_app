import 'package:flutter/material.dart';
import 'package:to_do_app/data_layer/item.dart';
import 'package:to_do_app/databases/todo_database.dart';

/// A [StatefulWidget] subclass.
class ItemsScreen extends StatefulWidget {
  final String title;

  ItemsScreen({Key key, this.title}) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

/// A [State] of [ItemsScreen] subclass.
class _ItemsScreenState extends State<ItemsScreen> {

  // FIELDS --------------------------------------------------------------------

  List<Item> _items;

  // METHODS -------------------------------------------------------------------

  // -- State --

  @override
  void initState() {
    super.initState();
    _getAllItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: (_items == null || _items.length == 0 )
          ? Center(child: Text('No data'))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, int position) {
                return ListTile(
                  title: Text(_items[position].title),
                  leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      final item = _items[position]
                        ..title = 'Update Item test';
                      _actionToUpdateItem(item);
                    }),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>_actionToDeleteItem(_items[position])));
              }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _actionToInsertItem));
  }

  // -- Item --

  void _getAllItems() async {
    await TodoDatabase().getAllItems().then((items) =>
        setState(() => _items = items));
  }

  // -- Action --

  void _actionToInsertItem() async {
    final item = Item.fromMap(<String, dynamic> {
      COLUMN_TITLE: 'Item test',
      COLUMN_IS_DONE: 1
    });

    final idOfRowInserted = await TodoDatabase().insertItem(item);
    print('DATABASE $ITEM_TABLE_NAME: INSERT row with id($idOfRowInserted)');

    // Update UI
    _getAllItems();
  }

  void _actionToUpdateItem(Item item) async {
    final updatesNumber = await TodoDatabase().updateItem(item);
    print('DATABASE $ITEM_TABLE_NAME: UPDATE $updatesNumber change(s)');

    // Update UI
    _getAllItems();
  }

  void _actionToDeleteItem(Item item) async {
    final deletedRowsNumber = await TodoDatabase().deleteItem(item);
    print('DATABASE $ITEM_TABLE_NAME: DELETE $deletedRowsNumber row(s)');

    // Update UI
    _getAllItems();
  }
}