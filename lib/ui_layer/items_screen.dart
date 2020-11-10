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
              itemBuilder: (BuildContext context, int position) {
                return ListTile(title: Text(_items[position].title));
              }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _actionToOnPressedButton));
  }

  // -- Item --

  void _getAllItems() async {
    await TodoDatabase().getAllItems().then((items) =>
        setState(() => _items = items));
  }

  // -- Action --

  void _actionToOnPressedButton() async {
    final item = Item.fromMap(<String, dynamic> {
      COLUMN_TITLE: 'Salut',
      COLUMN_IS_DONE: 1
    });

    await TodoDatabase().insertItem(item);
    _getAllItems();
  }
}