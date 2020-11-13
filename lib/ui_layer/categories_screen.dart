import 'package:flutter/material.dart';
import 'package:to_do_app/data_layer/category.dart';
import 'package:to_do_app/databases/todo_database.dart';
import 'package:to_do_app/ui_layer/items_screen.dart';

/// A [StatefulWidget] subclass.
class CategoriesScreen extends StatefulWidget {
  final String title;

  CategoriesScreen({Key key, this.title}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

/// A [State] of [CategoriesScreen] subclass.
class _CategoriesScreenState extends State<CategoriesScreen> {

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
                    onPressed: () => _showUpdateDialog(_categories[position])),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>_actionToDeleteCategory(_categories[position])),
                  onTap: () => _navigateToItemsOfCategory(_categories[position]));
              }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddDialog));
  }

  // -- Category --

  void _getAllCategories() async {
    await TodoDatabase().getAllCategories().then((categories) =>
        setState(() => _categories = categories));
  }

  // -- Action --

  void _actionToInsertCategory(String categoryName) async {
    final category = Category(title: categoryName);
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

  // -- Dialog --

  void _showAddDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          String categoryName;
          return SimpleDialog(
            title: Text('Add new category'),
            contentPadding: EdgeInsets.all(16.0),
            children: [
              TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'New category'),
                  onChanged: (name) => categoryName = name),
              SizedBox(height: 16.0),
              RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Add', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    _actionToInsertCategory(categoryName);
                    Navigator.pop(buildContext);
                  })
            ]);
        });
  }

  void _showUpdateDialog(Category category) async {
    return showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          String categoryName;
          return SimpleDialog(
              title: Text('Update category'),
              contentPadding: EdgeInsets.all(16.0),
              children: [
                TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: category.title),
                    onChanged: (name) => categoryName = name),
                SizedBox(height: 16.0),
                RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('Update', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _actionToUpdateCategory(
                          Category(id: category.id, title: categoryName));
                      Navigator.pop(buildContext);
                    })
              ]);
        });
  }

  // -- Navigation --

  void _navigateToItemsOfCategory(Category category) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemsScreen(
            title: "Todo of ${category.title}", category: category)));
  }
}