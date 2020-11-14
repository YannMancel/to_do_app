import 'package:flutter/material.dart';
import 'package:to_do_app/data_layer/category.dart';

typedef Action = void Function(Category category);

enum Mode { INSERT, UPDATE }

/// A [StatefulWidget] subclass.
// ignore: must_be_immutable
class CategoryDialog extends StatefulWidget {
  Mode mode;
  Action actionOnClick;
  Category oldCategory;

  CategoryDialog(
      {@required this.mode, @required this.actionOnClick, this.oldCategory});

  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

/// A [State] of [CategoryDialog] subclass.
class _CategoryDialogState extends State<CategoryDialog> {

  // FIELDS --------------------------------------------------------------------

  String _newTitle;

  // METHODS -------------------------------------------------------------------

  // -- State --

  @override
  void initState() {
    super.initState();
    _newTitle = widget.oldCategory?.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text((widget.mode == Mode.INSERT)
            ? 'Add new category' : 'Update category'),
        contentPadding: EdgeInsets.all(16.0),
        children: [
          TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: (widget.mode == Mode.INSERT)
                  ? 'New category' : widget.oldCategory.title),
              onChanged: (name) => _newTitle = name),
          SizedBox(height: 16.0),
          RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text((widget.mode == Mode.INSERT)
                  ? 'Add' : 'Update', style: TextStyle(color: Colors.white)),
              onPressed: _onClickButton)
        ]);
  }

  // -- Action --

  void _onClickButton() {
    Category category;
    switch (widget.mode) {
      case Mode.INSERT:
        category = Category(title: _newTitle);
        break;

      case Mode.UPDATE:
        category = Category(id: widget.oldCategory.id, title: _newTitle);
        break;
    }

    widget.actionOnClick(category);
    Navigator.pop(context);
  }
}