
const ITEM_TABLE = 'item';
const ITEM_COLUMN_ID = 'id';
const ITEM_COLUMN_CATEGORY_ID = 'category_id';
const ITEM_COLUMN_TITLE = 'title';
const ITEM_COLUMN_DESCRIPTION = 'description';
const ITEM_COLUMN_IS_DONE = 'is_done';

/*
    +----------------------------------+
    | item                             |
    +----------------------------------+
    | id: INTEGER PRIMARY KEY          |
    +----------------------------------+
    | category_id: INTEGER FOREIGN KEY |
    | title: TEXT NOT NULL             |
    | description: TEXT                |
    | is_done: INTEGER                 |
    +----------------------------------+
 */

class Item {

  // FIELDS --------------------------------------------------------------------

  int id;
  int categoryId;
  String title;
  String description;
  bool isDone;

  // CONSTRUCTORS --------------------------------------------------------------

  Item._();

  Item.fromMap(Map<String, dynamic> map) {
    id = map[ITEM_COLUMN_ID];
    categoryId = map[ITEM_COLUMN_CATEGORY_ID];
    title = map[ITEM_COLUMN_TITLE];
    description = map[ITEM_COLUMN_DESCRIPTION];
    isDone = map[ITEM_COLUMN_IS_DONE] == 1;
  }

  // METHODS -------------------------------------------------------------------

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      ITEM_COLUMN_TITLE: title,
      ITEM_COLUMN_IS_DONE: isDone == true ? 1 : 0
    };

    if (id != null) map[ITEM_COLUMN_ID] = id;
    if (categoryId != null) map[ITEM_COLUMN_CATEGORY_ID] = categoryId;
    if (description != null) map[ITEM_COLUMN_DESCRIPTION] = description;

    return map;
  }
}