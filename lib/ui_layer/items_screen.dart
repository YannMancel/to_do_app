import 'package:flutter/material.dart';
import 'package:to_do_app/data_layer/category.dart';
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

  List<Category> _categories;

  // METHODS -------------------------------------------------------------------

  // -- State --

  @override
  void initState() {
    super.initState();
    _getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: (_categories == null || _categories.length == 0 )
          ? Center(child: Text('No data'))
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (_, int position) {
                return ListTile(
                  title: Text(_categories[position].title),
                  leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      final category = _categories[position]
                        ..title = 'Update Category test';
                      _actionToUpdateCategory(category);
                    }),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>_actionToDeleteCategory(_categories[position])));
              }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _actionToInsertCategory));
  }

  // -- Category --

  void _getAllCategories() async {
    await TodoDatabase().getAllCategories().then((categories) =>
        setState(() => _categories = categories));
  }

  // -- Action --

  void _actionToInsertCategory() async {
    final category = Category.fromMap(<String, dynamic> {
      CATEGORY_COLUMN_TITLE: 'Category test'
    });

    final idOfRowInserted = await TodoDatabase().insertCategory(category);
    print('DATABASE $CATEGORY_TABLE: INSERT row with id($idOfRowInserted)');

    // Update UI
    _getAllCategories();
  }

  void _actionToUpdateCategory(Category category) async {
    final updatesNumber = await TodoDatabase().updateCategory(category);
    print('DATABASE $CATEGORY_TABLE: UPDATE $updatesNumber change(s)');

    // Update UI
    _getAllCategories();
  }

  void _actionToDeleteCategory(Category category) async {
    final deletedRowsNumber = await TodoDatabase().deleteCategory(category);
    print('DATABASE $CATEGORY_TABLE: DELETE $deletedRowsNumber row(s)');

    // Update UI
    _getAllCategories();
  }
}