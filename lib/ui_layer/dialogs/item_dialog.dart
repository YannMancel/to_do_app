import 'package:flutter/material.dart';
import 'package:to_do_app/data_layer/item.dart';

typedef Action = void Function(Item item);

enum Mode { INSERT, UPDATE }

/// A [StatefulWidget] subclass.
class ItemDialog extends StatefulWidget {
  final Mode mode;
  final int categoryId;
  final Action actionOnClick;
  final Item oldItem;

  ItemDialog({
    @required this.mode,
    @required this.categoryId,
    @required this.actionOnClick,
    this.oldItem});

  @override
  _ItemDialogState createState() => _ItemDialogState();
}

/// A [State] of [ItemDialog] subclass.
class _ItemDialogState extends State<ItemDialog> {

  // FIELDS --------------------------------------------------------------------

  String _newTitle;
  String _newDescription;

  // METHODS -------------------------------------------------------------------

  // -- State --

  @override
  void initState() {
    super.initState();
    _newTitle = widget.oldItem?.title ?? '';
    _newDescription = widget.oldItem?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text((widget.mode == Mode.INSERT)
            ? 'Add new Todo' : 'Update Todo'),
        contentPadding: EdgeInsets.all(16.0),
        children: [
          TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: (widget.mode == Mode.INSERT)
                  ? 'New Todo' : widget.oldItem.title),
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
    Item item;
    switch (widget.mode) {
      case Mode.INSERT:
        item = Item(
            categoryId: widget.categoryId,
            title: _newTitle,
            description: _newDescription);
        break;

      case Mode.UPDATE:
        item = Item(
            id: widget.oldItem.id,
            categoryId: widget.oldItem.categoryId,
            title: _newTitle,
            description: _newDescription);
        break;
    }

    widget.actionOnClick(item);
    Navigator.pop(context);
  }
}