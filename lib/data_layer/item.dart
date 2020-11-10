
const ITEM_TABLE_NAME = 'item';
const COLUMN_ID = 'id';
const COLUMN_TITLE = 'title';
const COLUMN_DESCRIPTION = 'description';
const COLUMN_IS_DONE = 'is_done';

class Item {

  // FIELDS --------------------------------------------------------------------

  int id;
  String title;
  String description;
  bool isDone;

  // CONSTRUCTORS --------------------------------------------------------------

  Item._();

  Item.fromMap(Map<String, dynamic> map) {
    id = map[COLUMN_ID];
    title = map[COLUMN_TITLE];
    description = map[COLUMN_DESCRIPTION];
    isDone = map[COLUMN_IS_DONE] == 1;
  }

  // METHODS -------------------------------------------------------------------

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      COLUMN_TITLE: title,
      COLUMN_IS_DONE: isDone == true ? 1 : 0
    };

    if (id != null) map[COLUMN_ID] = id;
    if (description != null) map[COLUMN_DESCRIPTION] = description;

    return map;
  }
}