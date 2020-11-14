import 'package:flutter/material.dart';
import 'package:to_do_app/data_layer/category.dart';
import 'package:to_do_app/data_layer/item.dart';
import 'package:to_do_app/databases/todo_database.dart';

/// A [StatefulWidget] subclass.
class ItemsScreen extends StatefulWidget {
  final String title;
  final Category category;

  ItemsScreen({Key key, this.title, this.category}) : super(key: key);

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
    _getItemsAccordingToCategory();
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
                    onPressed: () => _showUpdateDialog(_items[position])),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>_actionToDeleteItem(_items[position])));
              }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddDialog));
  }

  // -- Item --

  void _getItemsAccordingToCategory() async {
    await TodoDatabase()
        .getItemsAccordingToCategoryId(widget.category.id)
        .then((items) => setState(() => _items = items));
  }

  // -- Action --

  void _actionToInsertItem(String title, String description) async {
    final item = Item(
        categoryId: widget.category.id,
        title: title,
        description: description);
    final idOfRowInserted = await TodoDatabase().insertItem(item);
    print('DATABASE $ITEM_TABLE: INSERT row with id($idOfRowInserted)');

    // Update UI
    _getItemsAccordingToCategory();
  }

  void _actionToUpdateItem(Item item) async {
    final updatesNumber = await TodoDatabase().updateItem(item);
    print('DATABASE $ITEM_TABLE: UPDATE $updatesNumber change(s)');

    // Update UI
    _getItemsAccordingToCategory();
  }

  void _actionToDeleteItem(Item item) async {
    final deletedRowsNumber = await TodoDatabase().deleteItem(item);
    print('DATABASE $ITEM_TABLE: DELETE $deletedRowsNumber row(s)');

    // Update UI
    _getItemsAccordingToCategory();
  }

  // -- Dialog --

  void _showAddDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          String itemTitle;
          return SimpleDialog(
              title: Text('Add new Todo'),
              contentPadding: EdgeInsets.all(16.0),
              children: [
                TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'New Todo'),
                    onChanged: (name) => itemTitle = name),
                SizedBox(height: 16.0),
                RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _actionToInsertItem(itemTitle, null);
                      Navigator.pop(buildContext);
                    })
              ]);
        });
  }

  void _showUpdateDialog(Item item) async {
    return showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          String itemTitle;
          return SimpleDialog(
              title: Text('Update Todo'),
              contentPadding: EdgeInsets.all(16.0),
              children: [
                TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: item.title),
                    onChanged: (name) => itemTitle = name),
                SizedBox(height: 16.0),
                RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('Update', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _actionToUpdateItem(
                          Item(
                              id: item.id,
                              categoryId: item.categoryId,
                              title: itemTitle,
                              description: item.description,
                              isDone: item.isDone));
                      Navigator.pop(buildContext);
                    })
              ]);
        });
  }
}